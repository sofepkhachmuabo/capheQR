<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
    </div> <!-- Đóng thẻ div #content -->
</div> <!-- Đóng thẻ div #wrapper -->

<!-- Bootstrap 5 JS Bundle (bao gồm Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script Điều khiển Sidebar và các hiệu ứng động -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const sidebar = document.getElementById('sidebar');
        const content = document.getElementById('content');
        const collapseBtn = document.getElementById('sidebarCollapse');
        
        if (collapseBtn) {
            collapseBtn.addEventListener('click', function () {
                sidebar.classList.toggle('active');
                content.classList.toggle('active');
            });
        }
    });
</script>
</body>
</html>
