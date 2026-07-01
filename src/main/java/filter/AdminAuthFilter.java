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

        // Cho phép đi qua nếu yêu cầu là trang đăng nhập hoặc tài nguyên CSS của admin
        boolean isLoginRequest = requestURI.equals(loginURI) || requestURI.endsWith("login.jsp");
        boolean isCssRequest = requestURI.contains("/admin/css/");

        // Kiểm tra xem admin đã đăng nhập chưa (thông tin đăng nhập lưu trong session)
        boolean loggedIn = (session != null && session.getAttribute("adminUser") != null);

        if (loggedIn || isLoginRequest || isCssRequest) {
            // Cho phép tiếp tục xử lý yêu cầu
            chain.doFilter(request, response);
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
