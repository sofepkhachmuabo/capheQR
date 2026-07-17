package controller.staff;

import dao.OrderDao;
import dao.UserDao;
import entity.Order;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Servlet xử lý danh sách đơn hàng dành riêng cho nhân viên.
 * Cho phép lọc danh sách theo trạng thái và cập nhật nhanh trạng thái đơn hàng.
 */
@WebServlet("/staff/orders")
public class StaffOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private OrderDao orderDao;
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDao();
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Xử lý yêu cầu Ping ngầm (Heartbeat) để giữ session
        if ("ping".equals(action)) {
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("pong");
            return;
        }

        // Lấy bộ lọc trạng thái từ request parameter
        String statusFilter = request.getParameter("status"); // ChoThanhToan, DangCheBien, DaGiao, DaThanhToan, DaHuy

        // Lấy tất cả đơn hàng từ CSDL
        List<Order> allOrders = orderDao.findAll();
        List<Order> filteredOrders;

        if (statusFilter == null || statusFilter.trim().isEmpty() || "Active".equals(statusFilter)) {
            // Mặc định: Hiển thị các đơn hàng đang hoạt động (chưa hoàn thành / chưa hủy)
            filteredOrders = allOrders.stream()
                    .filter(o -> !"DaThanhToan".equals(o.getTrangThai()) && !"DaHuy".equals(o.getTrangThai()))
                    .collect(Collectors.toList());
            request.setAttribute("currentTab", "active");
        } else if ("All".equals(statusFilter)) {
            filteredOrders = allOrders;
            request.setAttribute("currentTab", "all");
        } else if ("ChoThanhToan".equals(statusFilter)) {
            // Chờ thanh toán bao gồm: Đơn mới đặt (ChoThanhToan) và Đơn đã phục vụ xong nhưng chưa tính tiền (DaGiao)
            filteredOrders = allOrders.stream()
                    .filter(o -> "ChoThanhToan".equals(o.getTrangThai()) || "DaGiao".equals(o.getTrangThai()))
                    .collect(Collectors.toList());
            request.setAttribute("currentTab", "ChoThanhToan");
        } else {
            // Lọc theo trạng thái cụ thể
            filteredOrders = allOrders.stream()
                    .filter(o -> statusFilter.equals(o.getTrangThai()))
                    .collect(Collectors.toList());
            request.setAttribute("currentTab", statusFilter);
        }

        // Gửi dữ liệu sang trang JSP
        request.setAttribute("orders", filteredOrders);
        request.getRequestDispatcher("/staff/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String action = request.getParameter("action");
        
        if ("update-status".equals(action)) {
            String idStr = request.getParameter("id");
            String status = request.getParameter("status");

            if (idStr != null && status != null) {
                try {
                    int orderId = Integer.parseInt(idStr);
                    Order order = orderDao.findById(orderId);

                    if (order != null) {
                        // Cập nhật trạng thái mới
                        order.setTrangThai(status);

                        // Gán nhân viên xử lý hiện tại nếu đơn hàng chưa có nhân viên hoặc khi nhân viên đổi trạng thái
                        String employeeEmail = (String) session.getAttribute("adminUser");
                        if (employeeEmail != null) {
                            User currentUser = userDao.findByEmail(employeeEmail);
                            if (currentUser != null) {
                                order.setUser(currentUser);
                            }
                        }

                        orderDao.update(order);
                        session.setAttribute("orderSuccess", "Đã cập nhật trạng thái đơn hàng #" + orderId + " thành công!");
                    } else {
                        session.setAttribute("orderError", "Không tìm thấy đơn hàng #" + orderId);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("orderError", "Có lỗi xảy ra: " + e.getMessage());
                }
            }
        }

        // Quay lại trang danh sách đơn hàng
        String status = request.getParameter("status");
        if ("DaThanhToan".equals(status)) {
            response.sendRedirect(request.getContextPath() + "/staff/orders?status=DaThanhToan");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/orders");
        }
    }
}
