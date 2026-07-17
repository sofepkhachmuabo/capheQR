package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Bộ lọc bảo mật chặn các yêu cầu chưa đăng nhập truy cập vào khu vực /staff/*.
 * Cho phép cả ADMIN và NHANVIEN truy cập.
 */
@WebFilter("/staff/*")
public class StaffAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Kiểm tra đăng nhập
        boolean loggedIn = (session != null && session.getAttribute("adminUser") != null);
        
        if (loggedIn) {
            // Cho phép tiếp tục xử lý yêu cầu
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập: Chuyển hướng về trang đăng nhập của admin
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/login");
        }
    }

    @Override
    public void destroy() {
    }
}
