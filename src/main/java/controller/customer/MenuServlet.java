package controller.customer;

import dao.CategoryDao;
import dao.DrinkDao;
import dao.TableDao;
import entity.Category;
import entity.Drink;
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
 * Servlet hiển thị thực đơn đồ uống cho khách hàng (Không cần đăng nhập).
 */
@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private DrinkDao drinkDao;
    private CategoryDao categoryDao;
    private TableDao tableDao;

    @Override
    public void init() throws ServletException {
        drinkDao = new DrinkDao();
        categoryDao = new CategoryDao();
        tableDao = new TableDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(true);
        String tableCode = request.getParameter("table");

        // Nếu khách quét QR Code (Ví dụ: /menu?table=TABLE_01)
        if (tableCode != null && !tableCode.trim().isEmpty()) {
            Table scannedTable = tableDao.findByQR(tableCode.trim());
            if (scannedTable != null) {
                // Lưu bàn ăn vào session
                session.setAttribute("customerTable", scannedTable);
            }
        }

        // Nếu khách chọn bàn từ dropdown (gửi qua AJAX/POST)
        String tableIdParam = request.getParameter("tableId");
        if (tableIdParam != null && !tableIdParam.trim().isEmpty()) {
            try {
                int tableId = Integer.parseInt(tableIdParam.trim());
                Table selectedTbl = tableDao.findById(tableId);
                if (selectedTbl != null) {
                    session.setAttribute("customerTable", selectedTbl);
                }
            } catch (Exception e) {
                // Bỏ qua
            }
        }

        // Tải danh sách đồ uống đang bán
        List<Drink> drinks = drinkDao.findActive();
        
        // Tải danh sách danh mục để làm bộ lọc
        List<Category> categories = categoryDao.findAll();

        // Tải tất cả danh sách bàn để khách có thể chọn bàn thủ công nếu không quét QR
        List<Table> tables = tableDao.findAll();

        request.setAttribute("drinks", drinks);
        request.setAttribute("categories", categories);
        request.setAttribute("tables", tables);

        // Chuyển tiếp tới trang giao diện menu khách hàng mới (nằm trong thư mục customer)
        request.getRequestDispatcher("/customer/menu.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
