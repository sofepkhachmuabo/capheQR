package controller.staff;

import dao.TableDao;
import entity.Table;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet quản lý trạng thái các bàn ăn dành riêng cho nhân viên.
 */
@WebServlet("/staff/tables")
public class StaffTableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TableDao tableDao;

    @Override
    public void init() throws ServletException {
        tableDao = new TableDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Table> tables = tableDao.findAll();
        request.setAttribute("tables", tables);
        request.setAttribute("activeMenu", "tables");
        
        request.getRequestDispatcher("/staff/tables.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String tableIdStr = request.getParameter("tableId");
        String status = request.getParameter("status");

        if (tableIdStr != null && status != null) {
            try {
                int tableId = Integer.parseInt(tableIdStr.trim());
                Table table = tableDao.findById(tableId);

                if (table != null) {
                    table.setTrangThai(status.trim());
                    tableDao.update(table);
                    session.setAttribute("tableSuccess", "Đã cập nhật trạng thái " + table.getTenBan() + " thành công!");
                } else {
                    session.setAttribute("tableError", "Không tìm thấy bàn yêu cầu.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("tableError", "Có lỗi xảy ra: " + e.getMessage());
            }
        }

        response.sendRedirect(request.getContextPath() + "/staff/tables");
    }
}
