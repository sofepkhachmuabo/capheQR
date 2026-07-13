package controller.admin;

import entity.Order;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.JpaUtils;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet xử lý hiển thị Bảng điều khiển Admin (Dashboard) chứa dữ liệu thống kê thật từ cơ sở dữ liệu.
 */
@WebServlet("/admin/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        EntityManager em = JpaUtils.getEntityManager();
        try {
            // Tính toán khoảng thời gian bắt đầu và kết thúc của tháng hiện tại để tối ưu câu truy vấn (SARGable)
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.set(java.util.Calendar.DAY_OF_MONTH, 1);
            cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);
            cal.set(java.util.Calendar.MILLISECOND, 0);
            java.util.Date startDate = cal.getTime();

            cal.add(java.util.Calendar.MONTH, 1);
            java.util.Date endDate = cal.getTime();

            // 1. Thống kê Doanh thu tháng này (đơn đã thanh toán trong tháng/năm hiện tại)
            String jpqlRevenue = "SELECT COALESCE(SUM(o.tongTien), 0.0) FROM Order o " +
                                 "WHERE o.trangThai = 'DaThanhToan' " +
                                 "AND o.ngayTao >= :startDate AND o.ngayTao < :endDate";
            Double totalRevenue = em.createQuery(jpqlRevenue, Double.class)
                                    .setParameter("startDate", startDate)
                                    .setParameter("endDate", endDate)
                                    .getSingleResult();
            request.setAttribute("totalRevenue", totalRevenue);

            // 2. Số lượng đơn hàng đã giao (thanh toán thành công trong tháng)
            String jpqlOrdersCount = "SELECT COUNT(o) FROM Order o " +
                                     "WHERE o.trangThai = 'DaThanhToan' " +
                                     "AND o.ngayTao >= :startDate AND o.ngayTao < :endDate";
            Long ordersCount = em.createQuery(jpqlOrdersCount, Long.class)
                                 .setParameter("startDate", startDate)
                                 .setParameter("endDate", endDate)
                                 .getSingleResult();
            request.setAttribute("ordersCount", ordersCount);

            // 3. Số lượng món trong thực đơn
            String jpqlDrinksCount = "SELECT COUNT(d) FROM Drink d";
            Long drinksCount = em.createQuery(jpqlDrinksCount, Long.class).getSingleResult();
            request.setAttribute("drinksCount", drinksCount);

            // 4. Số bàn đang hoạt động / Tổng số bàn
            String jpqlActiveTables = "SELECT COUNT(t) FROM Table t WHERE t.trangThai = 'CoKhach'";
            Long activeTables = em.createQuery(jpqlActiveTables, Long.class).getSingleResult();
            
            String jpqlTotalTables = "SELECT COUNT(t) FROM Table t";
            Long totalTables = em.createQuery(jpqlTotalTables, Long.class).getSingleResult();
            
            request.setAttribute("activeTables", activeTables);
            request.setAttribute("totalTables", totalTables);

            // 5. Giao dịch gần đây (Lấy 5 hóa đơn mới nhất, dùng JOIN FETCH để tránh lỗi N+1 SELECT)
            String jpqlTransactions = "SELECT o FROM Order o LEFT JOIN FETCH o.table LEFT JOIN FETCH o.user ORDER BY o.ngayTao DESC";
            List<Order> recentOrders = em.createQuery(jpqlTransactions, Order.class)
                                         .setMaxResults(5)
                                         .getResultList();
            
            List<Map<String, Object>> recentTransactions = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm - dd/MM/yyyy");
            for (Order o : recentOrders) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", "HD" + o.getMaHoaDon());
                map.put("time", sdf.format(o.getNgayTao()));
                map.put("amount", o.getTongTien());
                map.put("method", "TaiCho".equals(o.getLoaiHoaDon()) ? "Tại bàn" : "Mang về");
                
                String statusStr = "Chờ thanh toán";
                if ("DaThanhToan".equals(o.getTrangThai())) {
                    statusStr = "Đã thanh toán";
                } else if ("DaHuy".equals(o.getTrangThai())) {
                    statusStr = "Đã hủy";
                }
                map.put("status", statusStr);
                recentTransactions.add(map);
            }
            request.setAttribute("recentTransactions", recentTransactions);

            // 6. Các loại nước bán chạy nhất (Nhóm theo sản phẩm, sắp xếp theo tổng số lượng bán)
            String jpqlBestSellers = "SELECT od.drink.tenSanPham, od.drink.category.tenDanhMuc, " +
                                     "SUM(od.soLuong), SUM(od.soLuong * od.donGia) " +
                                     "FROM OrderDetail od " +
                                     "WHERE od.order.trangThai = 'DaThanhToan' " +
                                     "GROUP BY od.drink.tenSanPham, od.drink.category.tenDanhMuc " +
                                     "ORDER BY SUM(od.soLuong) DESC";
            List<Object[]> bestSellersRaw = em.createQuery(jpqlBestSellers, Object[].class)
                                              .setMaxResults(4)
                                              .getResultList();
            
            List<Map<String, Object>> bestSellers = new ArrayList<>();
            for (Object[] row : bestSellersRaw) {
                Map<String, Object> map = new HashMap<>();
                map.put("name", row[0]);
                map.put("category", row[1]);
                map.put("soldCount", row[2]);
                map.put("totalSales", row[3]);
                bestSellers.add(map);
            }
            request.setAttribute("bestSellers", bestSellers);

            // 7. Nhân viên xuất sắc của tháng (Nhóm theo tài khoản người xử lý hóa đơn)
            String jpqlTopEmployees = "SELECT o.user.hoTen, o.user.role.tenVaiTro, " +
                                      "COUNT(o), SUM(o.tongTien), o.user.hinhAnh " +
                                      "FROM Order o " +
                                      "WHERE o.trangThai = 'DaThanhToan' " +
                                      "AND o.user IS NOT NULL " +
                                      "GROUP BY o.user.hoTen, o.user.role.tenVaiTro, o.user.hinhAnh " +
                                      "ORDER BY SUM(o.tongTien) DESC";
            List<Object[]> topEmployeesRaw = em.createQuery(jpqlTopEmployees, Object[].class)
                                               .setMaxResults(3)
                                               .getResultList();
            
            List<Map<String, Object>> topEmployees = new ArrayList<>();
            for (Object[] row : topEmployeesRaw) {
                Map<String, Object> map = new HashMap<>();
                map.put("name", row[0]);
                map.put("role", row[1]);
                map.put("orders", row[2]);
                map.put("sales", row[3]);
                
                String empAvatar = (String) row[4];
                if (empAvatar == null || empAvatar.trim().isEmpty()) {
                    empAvatar = "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100"; // default placeholder
                } else if (!empAvatar.startsWith("http")) {
                    empAvatar = request.getContextPath() + "/admin/images/" + empAvatar;
                }
                map.put("avatar", empAvatar);
                topEmployees.add(map);
            }
            request.setAttribute("topEmployees", topEmployees);

        } finally {
            em.close();
        }

        // Chuyển hướng sang trang JSP hiển thị
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
