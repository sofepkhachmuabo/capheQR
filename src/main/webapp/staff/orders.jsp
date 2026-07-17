<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="common/staff-header.jsp" />

<div class="row mb-4">
    <div class="col-12">
        <h2 class="fw-bold text-dark"><i class="bi bi-card-list text-warning me-2"></i>Bảng Quản Lý Nhận Đơn Hàng</h2>
        <p class="text-muted">Xem, nhận đơn từ mã QR khách hàng gọi và cập nhật tiến trình chế biến của bếp.</p>
    </div>
</div>

<!-- Hiển thị thông báo kết quả hành động -->
<c:if test="${not empty sessionScope.orderSuccess}">
    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm" role="alert" style="border-radius: 10px;">
        <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.orderSuccess}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>
<c:if test="${not empty sessionScope.orderError}">
    <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm" role="alert" style="border-radius: 10px;">
        <i class="bi bi-exclamation-triangle-fill me-2"></i> ${sessionScope.orderError}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<!-- Thanh bộ lọc trạng thái (Tabs) -->
<div class="card border-0 shadow-sm mb-4" style="border-radius: 12px; overflow: hidden;">
    <div class="card-body p-2 bg-white">
        <ul class="nav nav-pills nav-fill">
            <li class="nav-item">
                <a class="nav-link py-2.5 ${currentTab == 'active' ? 'active bg-warning text-dark fw-bold' : 'text-secondary'}" 
                   href="${pageContext.request.contextPath}/staff/orders">
                    <i class="bi bi-lightning-charge me-1"></i> Cần Xử Lý
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2.5 ${currentTab == 'ChoThanhToan' ? 'active bg-warning text-dark fw-bold' : 'text-secondary'}" 
                   href="${pageContext.request.contextPath}/staff/orders?status=ChoThanhToan">
                    <i class="bi bi-hourglass-split me-1"></i> Chờ Thanh Toán
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2.5 ${currentTab == 'DangCheBien' ? 'active bg-warning text-dark fw-bold' : 'text-secondary'}" 
                   href="${pageContext.request.contextPath}/staff/orders?status=DangCheBien">
                    <i class="bi bi-fire me-1"></i> Đang Chế Biến
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2.5 ${currentTab == 'DaGiao' ? 'active bg-warning text-dark fw-bold' : 'text-secondary'}" 
                   href="${pageContext.request.contextPath}/staff/orders?status=DaGiao">
                    <i class="bi bi-check2-square me-1"></i> Đã Giao Món
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2.5 ${currentTab == 'DaThanhToan' ? 'active bg-warning text-dark fw-bold' : 'text-secondary'}" 
                   href="${pageContext.request.contextPath}/staff/orders?status=DaThanhToan">
                    <i class="bi bi-currency-dollar me-1"></i> Đã Thanh Toán
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2.5 ${currentTab == 'DaHuy' ? 'active bg-warning text-dark fw-bold' : 'text-secondary'}" 
                   href="${pageContext.request.contextPath}/staff/orders?status=DaHuy">
                    <i class="bi bi-x-circle me-1"></i> Đã Hủy
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link py-2.5 ${currentTab == 'all' ? 'active bg-warning text-dark fw-bold' : 'text-secondary'}" 
                   href="${pageContext.request.contextPath}/staff/orders?status=All">
                    <i class="bi bi-list-nested me-1"></i> Tất Cả
                </a>
            </li>
        </ul>
    </div>
</div>

<!-- Khối danh sách đơn hàng -->
<div class="custom-card">
    <div class="table-responsive">
        <table class="table table-hover align-middle custom-table">
            <thead>
                <tr>
                    <th style="width: 80px;">Mã Đơn</th>
                    <th>Thời Gian Đặt</th>
                    <th>Hình Thức / Vị Trí</th>
                    <th>Khách Hàng</th>
                    <th class="text-end">Tổng Tiền</th>
                    <th>Phụ Trách</th>
                    <th class="text-center">Trạng Thái</th>
                    <th class="text-center" style="width: 280px;">Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>
                            <strong class="text-dark">#${order.maHoaDon}</strong>
                        </td>
                        <td>
                            <span class="text-muted" style="font-size: 0.9rem;">
                                <fmt:formatDate value="${order.ngayTao}" pattern="dd/MM/yyyy HH:mm:ss" />
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${order.loaiHoaDon == 'TaiCho'}">
                                    <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">
                                        <i class="bi bi-shop me-1"></i> ${not empty order.table ? order.table.tenBan : 'Tại chỗ'}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-primary-subtle text-primary border border-primary-subtle rounded-pill">
                                        <i class="bi bi-bag-dash me-1"></i> Mang về
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="fw-semibold text-dark">${order.customer.hoTen}</div>
                            <small class="text-muted"><i class="bi bi-telephone me-1"></i>${order.customer.soDienThoai}</small>
                        </td>
                        <td class="text-end fw-bold text-dark">
                            <fmt:formatNumber value="${order.tongTien}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty order.user}">
                                    <span class="text-secondary" style="font-size: 0.95rem;">
                                        <i class="bi bi-person-badge me-1"></i>${order.user.hoTen}
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger fw-semibold" style="font-size: 0.9rem;">
                                        <i class="bi bi-patch-question me-1"></i>Chưa nhận đơn
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${order.trangThai == 'ChoThanhToan'}">
                                    <span class="badge-status status-chothanhtoan">Chờ thanh toán</span>
                                </c:when>
                                <c:when test="${order.trangThai == 'DangCheBien'}">
                                    <span class="badge-status status-dangchebien">Đang chế biến</span>
                                </c:when>
                                <c:when test="${order.trangThai == 'DaGiao'}">
                                    <span class="badge-status status-dagiao">Đã giao món</span>
                                </c:when>
                                <c:when test="${order.trangThai == 'DaThanhToan'}">
                                    <span class="badge-status status-dathanhtoan">Đã thanh toán</span>
                                </c:when>
                                <c:when test="${order.trangThai == 'DaHuy'}">
                                    <span class="badge-status status-dahuy">Đã hủy</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <div class="d-flex justify-content-center align-items-center gap-1">
                                <!-- Nút Xem chi tiết -->
                                <a href="${pageContext.request.contextPath}/staff/orders/detail?id=${order.maHoaDon}" 
                                   class="btn btn-sm btn-outline-secondary px-3 py-1.5" style="border-radius: 8px;">
                                    <i class="bi bi-eye-fill"></i> Chi Tiết
                                </a>

                                <!-- Hành động nhanh theo trạng thái -->
                                <c:choose>
                                    <c:when test="${order.trangThai == 'ChoThanhToan'}">
                                        <form action="${pageContext.request.contextPath}/staff/orders" method="post" class="m-0">
                                            <input type="hidden" name="action" value="update-status">
                                            <input type="hidden" name="id" value="${order.maHoaDon}">
                                            <input type="hidden" name="status" value="DangCheBien">
                                            <button type="submit" class="btn btn-sm btn-warning px-3 py-1.5 fw-bold" style="border-radius: 8px;">
                                                <i class="bi bi-fire me-1"></i> Làm món
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${order.trangThai == 'DangCheBien'}">
                                        <form action="${pageContext.request.contextPath}/staff/orders" method="post" class="m-0">
                                            <input type="hidden" name="action" value="update-status">
                                            <input type="hidden" name="id" value="${order.maHoaDon}">
                                            <input type="hidden" name="status" value="DaGiao">
                                            <button type="submit" class="btn btn-sm btn-primary px-3 py-1.5 fw-bold" style="border-radius: 8px;">
                                                <i class="bi bi-check2-circle me-1"></i> Giao món
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:when test="${order.trangThai == 'DaGiao'}">
                                        <c:set var="itemsStr" value="" />
                                        <c:forEach var="detail" items="${order.orderDetails}" varStatus="vs">
                                            <c:set var="itemsStr" value="${itemsStr}${detail.soLuong}x ${detail.drink.tenSanPham}${!vs.last ? ', ' : ''}" />
                                        </c:forEach>
                                        <button type="button" class="btn btn-sm btn-success px-3 py-1.5 fw-bold" style="border-radius: 8px;"
                                                data-bs-toggle="modal" 
                                                data-bs-target="#paymentConfirmModal"
                                                data-id="${order.maHoaDon}"
                                                data-customer-name="${order.customer.hoTen}"
                                                data-customer-phone="${order.customer.soDienThoai}"
                                                data-staff-name="${not empty order.user ? order.user.hoTen : 'Chưa nhận'}"
                                                data-total-amount="${order.tongTien}"
                                                data-items="${itemsStr}">
                                            <i class="bi bi-currency-dollar me-1"></i> Thanh toán
                                        </button>
                                    </c:when>
                                </c:choose>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="8" class="text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-1 d-block mb-3 text-secondary"></i>
                            Không tìm thấy đơn hàng nào ở trạng thái này.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<%
    session.removeAttribute("orderSuccess");
    session.removeAttribute("orderError");
%>

<!-- Modal Xác Nhận Thanh Toán -->
<div class="modal fade" id="paymentConfirmModal" tabindex="-1" aria-labelledby="paymentConfirmModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 16px;">
            <div class="modal-header bg-success text-white py-3" style="border-radius: 16px 16px 0 0;">
                <h5 class="modal-title fw-bold" id="paymentConfirmModalLabel">
                    <i class="bi bi-check2-circle me-2"></i>Xác Nhận Thanh Toán Đơn Hàng
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/staff/orders" method="post" class="m-0">
                <input type="hidden" name="action" value="update-status">
                <input type="hidden" name="id" id="modalOrderId" value="">
                <input type="hidden" name="status" value="DaThanhToan">
                
                <div class="modal-body p-4">
                    <div class="text-center mb-4">
                        <span class="text-muted small uppercase tracking-wider d-block mb-1">MÃ HÓA ĐƠN</span>
                        <h3 class="fw-bold text-success mb-0 fs-2" id="displayOrderId">#00</h3>
                    </div>
                    
                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <span class="text-muted small d-block mb-1"><i class="bi bi-person me-1"></i>Khách Hàng</span>
                            <strong class="text-dark fs-6 d-block" id="displayCustomerName">Tên Khách</strong>
                        </div>
                        <div class="col-6">
                            <span class="text-muted small d-block mb-1"><i class="bi bi-telephone me-1"></i>Số Điện Thoại</span>
                            <strong class="text-dark fs-6 d-block" id="displayCustomerPhone">090****000</strong>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <span class="text-muted small d-block mb-1"><i class="bi bi-person-badge me-1"></i>Nhân Viên Phụ Trách</span>
                        <strong class="text-secondary d-block" id="displayStaffName">Tên Nhân Viên</strong>
                    </div>
                    
                    <div class="mb-4">
                        <span class="text-muted small d-block mb-2"><i class="bi bi-receipt me-1"></i>Danh Sách Món Đã Đặt</span>
                        <div class="bg-light p-3 rounded-3 border border-light" id="displayDrinkItems" style="max-height: 160px; overflow-y: auto;">
                            <!-- JS will inject list items here -->
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between align-items-center bg-success-subtle p-3 rounded-3 border border-success-subtle">
                        <span class="fs-6 text-success-emphasis fw-bold">Tổng tiền cần thu:</span>
                        <span class="fs-3 fw-black text-success" id="displayTotalAmount" style="font-weight: 800;">0 đ</span>
                    </div>
                </div>
                
                <div class="modal-footer border-0 p-3 pt-0 d-flex gap-2">
                    <button type="button" class="btn btn-light border flex-grow-1 py-2 fw-semibold" data-bs-dismiss="modal" style="border-radius: 10px;">
                        Hủy
                    </button>
                    <button type="submit" class="btn btn-success flex-grow-1 py-2 fw-bold" style="border-radius: 10px;">
                        <i class="bi bi-credit-card-2-back me-1"></i> Xác Nhận Thanh Toán
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="common/staff-footer.jsp" />
