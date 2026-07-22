package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Bộ lọc bảo mật chặn các yêu cầu chưa đăng nhập truy cập vào khu vực /admin/*.
 */
@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo bộ lọc (nếu cần)
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String loginURI = contextPath + "/admin/login";
        String logoutURI = contextPath + "/admin/logout";

        // Cho phép đi qua nếu yêu cầu là trang đăng nhập, đăng xuất hoặc tài nguyên CSS của admin
        boolean isLoginRequest = requestURI.equals(loginURI) || requestURI.endsWith("login.jsp");
        boolean isLogoutRequest = requestURI.equals(logoutURI);
        boolean isCssRequest = requestURI.contains("/admin/css/");

        // Kiểm tra xem người dùng đã đăng nhập chưa và có vai trò là ADMIN không
        boolean loggedIn = (session != null && session.getAttribute("adminUser") != null);
        boolean isAdmin = loggedIn && "ADMIN".equals(session.getAttribute("userRole"));

        if ((loggedIn && isAdmin) || isLoginRequest || isLogoutRequest || isCssRequest) {
            // Cho phép tiếp tục xử lý yêu cầu
            chain.doFilter(request, response);
        } else if (loggedIn && !isAdmin) {
            // Đã đăng nhập nhưng không phải ADMIN (là Nhân viên): Chuyển hướng đến trang nhận đơn của nhân viên
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/staff/orders");
        } else {
            // Chưa đăng nhập: Chuyển hướng về trang đăng nhập
            httpResponse.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
        // Giải phóng tài nguyên (nếu có)
    }
}
