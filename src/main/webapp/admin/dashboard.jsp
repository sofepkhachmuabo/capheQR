<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Nhúng Header dùng chung (Chứa Sidebar & Top Navbar) -->
<jsp:include page="common/header.jsp" />

<div class="container-fluid px-0">
    <div class="row mb-4">
        <div class="col-12">
            <h2 class="fw-bold text-dark">Tổng Quan Hoạt Động</h2>
            <p class="text-muted">Cập nhật thống kê hoạt động kinh doanh của quán nước hôm nay.</p>
        </div>
    </div>

    <!-- Hàng chứa thẻ Chỉ số KPI -->
    <div class="row g-4 mb-5">
        <!-- Doanh thu thẻ -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="bi bi-wallet2"></i>
                </div>
                <div class="stat-title">Doanh Thu Tháng Này</div>
                <div class="stat-number">
                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                </div>
            </div>
        </div>

        <!-- Đơn hàng thẻ -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="bi bi-receipt"></i>
                </div>
                <div class="stat-title">Đơn Hàng Đã Giao</div>
                <div class="stat-number">${ordersCount} đơn</div>
            </div>
        </div>

        <!-- Món bán chạy thẻ -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="bi bi-cup-hot"></i>
                </div>
                <div class="stat-title">Món Trong Thực Đơn</div>
                <div class="stat-number">${drinksCount} món</div>
            </div>
        </div>

        <!-- Bàn hoạt động thẻ -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="bi bi-shop"></i>
                </div>
                <div class="stat-title">Bàn Đang Hoạt Động</div>
                <div class="stat-number">${activeTables} / ${totalTables} bàn</div>
            </div>
        </div>
    </div>

    <!-- Hàng chứa: Nước Bán Chạy Nhất & Nhân Viên Xuất Sắc -->
    <div class="row g-4 mb-4">
        <!-- 1. Bảng Các loại nước bán chạy nhất -->
        <div class="col-12 col-md-6">
            <div class="custom-card h-100">
                <div class="card-title-container">
                    <h5 class="custom-card-title"><i class="bi bi-star-fill me-2 text-warning"></i>Nước Bán Chạy Nhất</h5>
                </div>
                <div class="table-responsive">
                    <table class="table custom-table">
                        <thead>
                            <tr>
                                <th>Tên Món</th>
                                <th class="text-end">Đã Bán</th>
                                <th class="text-end">Doanh Thu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="drink" items="${bestSellers}">
                                <tr>
                                    <td>
                                        <div class="fw-semibold">${drink.name}</div>
                                        <small class="text-muted">${drink.category}</small>
                                    </td>
                                    <td class="text-end"><strong>${drink.soldCount} ly</strong></td>
                                    <td class="text-end text-success"><fmt:formatNumber value="${drink.totalSales}" type="currency" currencySymbol="đ" maxFractionDigits="0" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 2. Bảng Nhân viên xuất sắc của tháng -->
        <div class="col-12 col-md-6">
            <div class="custom-card h-100">
                <div class="card-title-container">
                    <h5 class="custom-card-title"><i class="bi bi-award-fill me-2 text-warning"></i>Nhân Viên Xuất Sắc</h5>
                </div>
                <div class="table-responsive">
                    <table class="table custom-table">
                        <thead>
                            <tr>
                                <th>Nhân Viên</th>
                                <th class="text-end">Số Đơn</th>
                                <th class="text-end">Hiệu Suất</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="emp" items="${topEmployees}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="${emp.avatar}" class="avatar-table" alt="${emp.name}">
                                            <div>
                                                <div class="fw-semibold">${emp.name}</div>
                                                <small class="text-muted">${emp.role}</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-end"><strong>${emp.orders}</strong></td>
                                    <td class="text-end text-primary"><fmt:formatNumber value="${emp.sales}" type="currency" currencySymbol="đ" maxFractionDigits="0" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Hàng chứa: Giao Dịch Gần Đây (Chiếm 100% bề rộng) -->
    <div class="row g-4">
        <!-- 3. Bảng Thống kê Doanh thu & Hóa đơn gần đây -->
        <div class="col-12">
            <div class="custom-card">
                <div class="card-title-container">
                    <h5 class="custom-card-title"><i class="bi bi-currency-dollar me-2 text-warning"></i>Giao Dịch Gần Đây</h5>
                    <span class="badge bg-light text-dark border">Tháng này</span>
                </div>
                <div class="table-responsive">
                    <table class="table custom-table">
                        <thead>
                            <tr>
                                <th>Mã Hóa Đơn</th>
                                <th>Thời Gian</th>
                                <th>Số Tiền</th>
                                <th>Phương Thức</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tx" items="${recentTransactions}">
                                <tr>
                                    <td><strong>${tx.id}</strong></td>
                                    <td>${tx.time}</td>
                                    <td><fmt:formatNumber value="${tx.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${tx.method == 'Ví MoMo'}"><span class="badge bg-danger-subtle text-danger" style="font-size: 0.8rem;">MoMo</span></c:when>
                                            <c:when test="${tx.method == 'Ví VNPAY'}"><span class="badge bg-primary-subtle text-primary" style="font-size: 0.8rem;">VNPAY</span></c:when>
                                            <c:when test="${tx.method == 'ChuyenKhoan'}"><span class="badge bg-info-subtle text-info" style="font-size: 0.8rem;">Chuyển khoản</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary-subtle text-dark" style="font-size: 0.8rem;">Tiền mặt</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="badge-active">${tx.status}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Nhúng Footer dùng chung (Đóng các thẻ div và thêm scripts) -->
<jsp:include page="common/footer.jsp" />
