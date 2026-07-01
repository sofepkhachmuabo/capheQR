<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Nhúng Header dùng chung -->
<jsp:include page="common/header.jsp" />

<div class="container-fluid px-0">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="fw-bold text-dark"><i class="bi bi-cup-hot-fill text-warning me-2"></i>Quản Lý Thực Đơn Nước Uống</h2>
            <p class="text-muted">Xem danh sách, thêm, chỉnh sửa thông tin hoặc xóa các món nước trong quán của bạn.</p>
        </div>
    </div>

    <div class="row g-4">
        <!-- Cột Danh sách đồ uống (Chiếm 8 phần cột trên màn hình trung bình trở lên) -->
        <div class="col-12 col-lg-8">
            <div class="custom-card">
                <div class="card-title-container">
                    <h5 class="custom-card-title"><i class="bi bi-list-stars me-2 text-warning"></i>Danh Sách Đồ Uống</h5>
                    <span class="badge bg-secondary-subtle text-dark border">${drinks.size()} món</span>
                </div>
                
                <div class="table-responsive">
                    <table class="table custom-table align-middle">
                        <thead>
                            <tr>
                                <th style="width: 80px;">Hình Ảnh</th>
                                <th>Tên Món</th>
                                <th>Danh Mục</th>
                                <th class="text-end">Giá Cơ Bản</th>
                                <th class="text-center">Trạng Thái</th>
                                <th class="text-center" style="width: 100px;">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="drink" items="${drinks}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty drink.hinhAnh}">
                                                <img src="${drink.hinhAnh}" class="rounded border shadow-sm" 
                                                     style="width: 60px; height: 60px; object-fit: cover;" 
                                                     alt="${drink.tenSanPham}"
                                                     onerror="this.onerror=null; this.src='https://placehold.co/100x100/f3ece4/8c6239?text=Coffee';">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rounded border bg-light text-muted d-flex align-items-center justify-content-center shadow-sm" style="width: 60px; height: 60px;">
                                                    <i class="bi bi-image fs-4"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark">${drink.tenSanPham}</div>
                                        <div class="text-muted text-truncate" style="max-width: 200px; font-size: 0.85rem;" title="${drink.moTa}">
                                            ${not empty drink.moTa ? drink.moTa : 'Chưa có mô tả'}
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border rounded-pill">${drink.category.tenDanhMuc}</span>
                                    </td>
                                    <td class="text-end fw-semibold text-success">
                                        <fmt:formatNumber value="${drink.giaCoBan}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${drink.trangThai == 'DangBan'}">
                                                <span class="badge-active"><i class="bi bi-check-circle-fill me-1"></i>Đang bán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-inactive"><i class="bi bi-x-circle-fill me-1"></i>Ngừng bán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <!-- Nút sửa món -->
                                        <a href="${pageContext.request.contextPath}/admin/drinks?action=edit&id=${drink.maSanPham}" 
                                           class="btn btn-sm btn-outline-warning action-btn" title="Chỉnh sửa">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <!-- Nút xóa món -->
                                        <a href="${pageContext.request.contextPath}/admin/drinks?action=delete&id=${drink.maSanPham}" 
                                           class="btn btn-sm btn-outline-danger action-btn" title="Xóa"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa món nước \'${drink.tenSanPham}\' này không?');">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty drinks}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                        Chưa có đồ uống nào trong cơ sở dữ liệu. Hãy thêm món mới bên cạnh!
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Cột Form thêm / cập nhật đồ uống (sticky sidebar form) -->
        <div class="col-12 col-lg-4">
            <div class="form-card">
                <h5 class="fw-bold mb-4 border-bottom pb-2">
                    <c:choose>
                        <c:when test="${isEdit}">
                            <i class="bi bi-pencil-square text-warning me-2"></i>Cập Nhật Đồ Uống
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-plus-circle-fill text-success me-2"></i>Thêm Món Nước Mới
                        </c:otherwise>
                    </c:choose>
                </h5>

                <form action="${pageContext.request.contextPath}/admin/drinks" method="post">
                    <!-- Truyền ID và Hành động tương ứng -->
                    <c:choose>
                        <c:when test="${isEdit}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${selectedDrink.maSanPham}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="insert">
                        </c:otherwise>
                    </c:choose>

                    <!-- Tên sản phẩm -->
                    <div class="mb-3">
                        <label for="tenSanPham" class="form-label">Tên món nước <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="tenSanPham" name="tenSanPham" 
                               placeholder="Ví dụ: Bạc Xỉu Đá" value="${selectedDrink.tenSanPham}" required>
                    </div>

                    <!-- Danh mục sản phẩm -->
                    <div class="mb-3">
                        <label for="maDanhMuc" class="form-label">Danh mục thực đơn <span class="text-danger">*</span></label>
                        <select class="form-select" id="maDanhMuc" name="maDanhMuc" required>
                            <option value="" disabled ${empty selectedDrink ? 'selected' : ''}>-- Chọn danh mục --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.maDanhMuc}" ${selectedDrink.category.maDanhMuc == cat.maDanhMuc ? 'selected' : ''}>
                                    ${cat.tenDanhMuc}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Giá cơ bản -->
                    <div class="mb-3">
                        <label for="giaCoBan" class="form-label">Giá cơ bản (đ) <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="giaCoBan" name="giaCoBan" min="0" step="500"
                               placeholder="Ví dụ: 25000" value="${isEdit ? String.format('%.0f', selectedDrink.giaCoBan) : ''}" required>
                    </div>

                    <!-- Link ảnh đại diện -->
                    <div class="mb-3">
                        <label for="hinhAnh" class="form-label">Đường dẫn hình ảnh (URL)</label>
                        <input type="text" class="form-control" id="hinhAnh" name="hinhAnh" 
                               placeholder="https://example.com/image.jpg" value="${selectedDrink.hinhAnh}">
                    </div>

                    <!-- Trạng thái bán -->
                    <div class="mb-3">
                        <label for="trangThai" class="form-label">Trạng thái bán</label>
                        <select class="form-select" id="trangThai" name="trangThai">
                            <option value="DangBan" ${selectedDrink.trangThai == 'DangBan' ? 'selected' : ''}>Đang bán</option>
                            <option value="NgungBan" ${selectedDrink.trangThai == 'NgungBan' ? 'selected' : ''}>Ngừng bán</option>
                        </select>
                    </div>

                    <!-- Mô tả sản phẩm -->
                    <div class="mb-4">
                        <label for="moTa" class="form-label">Mô tả sản phẩm</label>
                        <textarea class="form-control" id="moTa" name="moTa" rows="3" 
                                  placeholder="Mô tả nguyên liệu, hương vị món...">${selectedDrink.moTa}</textarea>
                    </div>

                    <!-- Nút gửi -->
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-coffee flex-grow-1">
                            <i class="bi bi-cloud-arrow-up-fill me-2"></i>Lưu lại
                        </button>
                        <c:if test="${isEdit}">
                            <a href="${pageContext.request.contextPath}/admin/drinks" class="btn btn-outline-secondary">
                                Hủy
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Nhúng Footer dùng chung -->
<jsp:include page="common/footer.jsp" />
