package controller.customer;

import dao.CustomerDao;
import dao.DrinkDao;
import dao.OrderDao;
import dao.TableDao;
import entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Servlet xử lý yêu cầu đặt món (đặt hàng) từ phía khách hàng (Không cần đăng nhập).
 */
@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CustomerDao customerDao;
    private TableDao tableDao;
    private DrinkDao drinkDao;
    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        customerDao = new CustomerDao();
        tableDao = new TableDao();
        drinkDao = new DrinkDao();
        orderDao = new OrderDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        // 1. Nhận thông tin khách hàng và bàn ăn
        String customerName = request.getParameter("customerName");
        String customerPhone = request.getParameter("customerPhone");
        String note = request.getParameter("note");
        String tableIdStr = request.getParameter("tableId");

        // 2. Nhận thông tin giỏ hàng
        String[] drinkIds = request.getParameterValues("drinkIds");
        String[] quantities = request.getParameterValues("quantities");

        // Kiểm tra hợp lệ dữ liệu cơ bản
        if (customerName == null || customerName.trim().isEmpty() ||
            customerPhone == null || customerPhone.trim().isEmpty() ||
            drinkIds == null || drinkIds.length == 0) {
            
            session.setAttribute("orderError", "Thông tin đặt món hoặc giỏ hàng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        try {
            // 3. Xử lý thông tin Khách hàng (bảo mật thông tin & kiểm tra tồn tại)
            customerName = customerName.trim();
            customerPhone = customerPhone.trim();
            
            // Tìm kiếm khách hàng theo số điện thoại
            Customer customer = customerDao.findByPhone(customerPhone);
            if (customer == null) {
                // Tạo mới nếu chưa tồn tại
                customer = new Customer();
                customer.setHoTen(customerName);
                customer.setSoDienThoai(customerPhone);
                // Tránh lỗi UNIQUE constraint của SQL Server khi có nhiều khách hàng vãng lai không điền email
                customer.setEmail(customerPhone + "@guest.coffeepoly.com");
                customer.setDiemTichLuy(0);
                customer.setTrangThai("HoatDong");
                customer.setNgayDangKy(new Date());
                customerDao.create(customer);
            } else {
                // Nếu khách hàng cũ đổi tên, cập nhật lại tên mới cho họ
                if (!customer.getHoTen().equalsIgnoreCase(customerName)) {
                    customer.setHoTen(customerName);
                    customerDao.update(customer);
                }
            }

            // 4. Xử lý thông tin Bàn ăn
            Table table = null;
            if (tableIdStr != null && !tableIdStr.trim().isEmpty()) {
                int tableId = Integer.parseInt(tableIdStr.trim());
                table = tableDao.findById(tableId);
            }
            
            // Nếu bàn ăn chưa được truyền qua Form, thử tìm từ Session
            if (table == null) {
                table = (Table) session.getAttribute("customerTable");
            }

            // 5. Tạo Hóa đơn (Order)
            Order order = new Order();
            order.setNgayTao(new Date());
            order.setTrangThai("ChoThanhToan");
            order.setLoaiHoaDon(table != null ? "TaiCho" : "MangVe");
            order.setTable(table);
            order.setCustomer(customer);
            order.setGhiChu(note != null ? note.trim() : "");
            order.setUser(null); // Chưa có nhân viên xử lý

            // 6. Tạo chi tiết hóa đơn (OrderDetail) & Tính tổng tiền
            List<OrderDetail> details = new ArrayList<>();
            double totalAmount = 0;

            for (int i = 0; i < drinkIds.length; i++) {
                int drinkId = Integer.parseInt(drinkIds[i]);
                int qty = Integer.parseInt(quantities[i]);

                if (qty <= 0) continue;

                Drink drink = drinkDao.findById(drinkId);
                if (drink != null && "DangBan".equals(drink.getTrangThai())) {
                    OrderDetail detail = new OrderDetail();
                    detail.setDrink(drink);
                    detail.setSoLuong(qty);
                    detail.setDonGia(drink.getGiaCoBan());
                    detail.setGhiChu("");
                    detail.setOrder(order);
                    
                    details.add(detail);
                    totalAmount += drink.getGiaCoBan() * qty;
                }
            }

            if (details.isEmpty()) {
                session.setAttribute("orderError", "Giỏ hàng của bạn không có món nào đang bán!");
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }

            order.setOrderDetails(details);
            order.setTongTien(totalAmount);

            // 7. Lưu hóa đơn vào cơ sở dữ liệu
            orderDao.create(order);
            
            // Đặt điểm tích lũy: Cộng 5% tổng tiền làm điểm tích lũy (ví dụ: 10,000đ = 1 điểm)
            int newPoints = (int) (totalAmount / 10000);
            customer.setDiemTichLuy(customer.getDiemTichLuy() + newPoints);
            customerDao.update(customer);

            // Xóa thông tin giỏ hàng ở Client (sẽ do JS xử lý sau khi chuyển sang thành công)
            // Chuyển hướng sang trang đặt món thành công (trong thư mục customer)
            response.sendRedirect(request.getContextPath() + "/customer/order-success.jsp?orderId=" + order.getMaHoaDon());

        } catch (Exception ex) {
            ex.printStackTrace();
            session.setAttribute("orderError", "Có lỗi xảy ra trong quá trình đặt món: " + ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/menu");
        }
    }
}
