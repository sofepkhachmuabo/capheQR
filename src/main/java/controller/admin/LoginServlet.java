package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet xử lý Đăng nhập (Login) và Đăng xuất (Logout) của khu vực quản trị.
 */
@WebServlet(urlPatterns = {"/admin/login", "/admin/logout"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Tài khoản admin mặc định dùng để kiểm tra
    private static final String ADMIN_EMAIL = "admin@qrcoffee.com";
    private static final String ADMIN_PASSWORD = "admin123";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/admin/logout".equals(path)) {
            // Nghiệp vụ đăng xuất: Xóa session
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            // Chuyển hướng về trang login
            response.sendRedirect(request.getContextPath() + "/admin/login");
        } else {
            // Nghiệp vụ hiển thị trang đăng nhập
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        dao.UserDao userDao = new dao.UserDao();
        entity.User user = userDao.findByEmail(email);

        // Kiểm tra thông tin đăng nhập từ cơ sở dữ liệu
        if (user != null && user.getMatKhau().equals(password) && "HoatDong".equals(user.getTrangThai())) {
            // Đăng nhập thành công: Tạo session và lưu thông tin đăng nhập
            HttpSession session = request.getSession(true);
            session.setAttribute("adminUser", email);
            session.setAttribute("adminName", user.getHoTen());
            session.setAttribute("adminAvatar", user.getHinhAnh());

            // Chuyển hướng tới trang Dashboard
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            // Đăng nhập thất bại: Quay lại trang đăng nhập và hiển thị lỗi
            request.setAttribute("errorMessage", "Email, mật khẩu không chính xác hoặc tài khoản đã bị khóa!");
            request.setAttribute("oldEmail", email); // Giữ lại email đã nhập
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}
