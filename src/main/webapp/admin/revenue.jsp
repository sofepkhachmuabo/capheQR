<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Nhúng Header dùng chung -->
<jsp:include page="common/header.jsp" />

<div class="container-fluid px-0">
    <!-- Tiêu đề trang -->
    <div class="row mb-4">
        <div class="col-12 col-md-6">
            <h2 class="fw-bold text-dark"><i class="bi bi-bar-chart-line-fill text-warning me-2"></i>Báo Cáo Doanh Thu</h2>
            <p class="text-muted">Theo dõi chỉ số kinh doanh, phân tích xu hướng doanh thu và tỷ trọng sản phẩm bán ra.</p>
        </div>
        <!-- Bộ lọc ngày -->
        <div class="col-12 col-md-6 d-flex align-items-center justify-content-md-end">
            <form action="${pageContext.request.contextPath}/admin/revenue" method="get" class="row g-2 align-items-center">
                <div class="col-auto">
                    <input type="date" class="form-control" name="startDate" value="${startDateStr}" required>
                </div>
                <div class="col-auto text-muted">đến</div>
                <div class="col-auto">
                    <input type="date" class="form-control" name="endDate" value="${endDateStr}" required>
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-coffee px-3">
                        <i class="bi bi-filter me-1"></i>Lọc
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Khối thẻ KPI nổi bật -->
    <div class="row g-4 mb-4">
        <!-- Doanh thu tổng -->
        <div class="col-12 col-sm-4">
            <div class="stat-card">
                <div class="stat-icon bg-success-subtle text-success">
                    <i class="bi bi-cash-coin"></i>
                </div>
                <div class="stat-title">Tổng Doanh Thu</div>
                <div class="stat-number text-success">
                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                </div>
            </div>
        </div>

        <!-- Tổng đơn hàng -->
        <div class="col-12 col-sm-4">
            <div class="stat-card">
                <div class="stat-icon bg-primary-subtle text-primary">
                    <i class="bi bi-receipt-cutoff"></i>
                </div>
                <div class="stat-title">Số Đơn Hoàn Thành</div>
                <div class="stat-number text-primary">${totalOrders} đơn</div>
            </div>
        </div>

        <!-- Doanh thu trung bình / đơn -->
        <div class="col-12 col-sm-4">
            <div class="stat-card">
                <div class="stat-icon bg-warning-subtle text-warning">
                    <i class="bi bi-calculator"></i>
                </div>
                <div class="stat-title">Giá Trị Đơn Trung Bình (AOV)</div>
                <div class="stat-number text-warning">
                    <fmt:formatNumber value="${aov}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                </div>
            </div>
        </div>
    </div>

    <!-- Khối biểu đồ -->
    <div class="row g-4 mb-4">
        <!-- Biểu đồ doanh số ngày -->
        <div class="col-12 col-lg-8">
            <div class="custom-card">
                <div class="card-title-container">
                    <h5 class="custom-card-title"><i class="bi bi-graph-up text-warning me-2"></i>Biểu Đồ Xu Hướng Doanh Thu</h5>
                </div>
                <div style="height: 320px; position: relative;">
                    <canvas id="revenueLineChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Biểu đồ tỷ trọng danh mục -->
        <div class="col-12 col-lg-4">
            <div class="custom-card">
                <div class="card-title-container">
                    <h5 class="custom-card-title"><i class="bi bi-pie-chart-fill text-warning me-2"></i>Tỷ Trọng Theo Nhóm Món</h5>
                </div>
                <div style="height: 320px; position: relative;" class="d-flex align-items-center justify-content-center">
                    <c:choose>
                        <c:when test="${not empty catData}">
                            <canvas id="categoryPieChart"></canvas>
                        </c:when>
                        <c:otherwise>
                            <div class="text-muted text-center py-5">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                Không có dữ liệu danh mục trong khoảng thời gian này
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Bảng chi tiết báo cáo -->
    <div class="row">
        <div class="col-12">
            <div class="custom-card">
                <div class="card-title-container">
                    <h5 class="custom-card-title"><i class="bi bi-table text-warning me-2"></i>Bảng Tổng Hợp Chi Tiết Theo Ngày</h5>
                </div>
                <div class="table-responsive">
                    <table class="table custom-table align-middle">
                        <thead>
                            <tr>
                                <th>Ngày Báo Cáo</th>
                                <th class="text-center">Số Đơn Đã Giao</th>
                                <th class="text-end">Doanh Thu Ngày</th>
                                <th class="text-end">Doanh Thu TB / Đơn (AOV)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="stat" items="${dailyStats}">
                                <tr>
                                    <td><strong>${stat.date}</strong></td>
                                    <td class="text-center">${stat.orders} đơn</td>
                                    <td class="text-end text-success fw-bold">
                                        <fmt:formatNumber value="${stat.revenue}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                                    </td>
                                    <td class="text-end text-secondary">
                                        <fmt:formatNumber value="${stat.aov}" type="currency" currencySymbol="đ" maxFractionDigits="0" />
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty dailyStats}">
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-muted">
                                        <i class="bi bi-clipboard2-x fs-1 d-block mb-3"></i>
                                        Không tìm thấy dữ liệu hóa đơn nào trong khoảng thời gian đã chọn.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Tải thư viện vẽ biểu đồ Chart.js qua CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // --- 1. BIỂU ĐỒ ĐƯỜNG XU HƯỚNG DOANH THU ---
        const dailyLabels = [
            <c:forEach var="lbl" items="${chartLabels}" varStatus="status">
                "${lbl}"${!status.last ? ',' : ''}
            </c:forEach>
        ];
        const dailyData = [
            <c:forEach var="val" items="${chartData}" varStatus="status">
                ${val}${!status.last ? ',' : ''}
            </c:forEach>
        ];

        const lineCtx = document.getElementById('revenueLineChart').getContext('2d');
        
        // Tạo gradient màu nền cho biểu đồ đường
        const revenueGradient = lineCtx.createLinearGradient(0, 0, 0, 300);
        revenueGradient.addColorStop(0, 'rgba(235, 161, 52, 0.4)');
        revenueGradient.addColorStop(1, 'rgba(235, 161, 52, 0.0)');

        new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: dailyLabels,
                datasets: [{
                    label: 'Doanh thu (đ)',
                    data: dailyData,
                    borderColor: '#eba134',
                    borderWidth: 3,
                    backgroundColor: revenueGradient,
                    fill: true,
                    tension: 0.35, // Bo tròn các góc nối
                    pointBackgroundColor: '#fff',
                    pointBorderColor: '#eba134',
                    pointBorderWidth: 2,
                    pointRadius: 5,
                    pointHoverRadius: 7
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.dataset.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                if (context.parsed.y !== null) {
                                    label += new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(context.parsed.y);
                                }
                                return label;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f0ebd8'
                        },
                        ticks: {
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', { notation: "compact", compactDisplay: "short" }).format(value) + 'đ';
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });

        // --- 2. BIỂU ĐỒ TRÒN TỶ TRỌNG THEO NHÓM MÓN ---
        <c:if test="${not empty catData}">
            const catLabels = [
                <c:forEach var="lbl" items="${catLabels}" varStatus="status">
                    "${lbl}"${!status.last ? ',' : ''}
                </c:forEach>
            ];
            const catData = [
                <c:forEach var="val" items="${catData}" varStatus="status">
                    ${val}${!status.last ? ',' : ''}
                </c:forEach>
            ];

            const pieCtx = document.getElementById('categoryPieChart').getContext('2d');
            new Chart(pieCtx, {
                type: 'doughnut',
                data: {
                    labels: catLabels,
                    datasets: [{
                        data: catData,
                        backgroundColor: [
                            '#8c6239', // Nâu cà phê đậm
                            '#dcae82', // Nâu sữa nhạt
                            '#5c8a67', // Xanh lục
                            '#cf5b5b', // Đỏ san hô
                            '#eba134'  // Vàng cam
                        ],
                        borderWidth: 2,
                        borderColor: '#ffffff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                boxWidth: 12,
                                padding: 15,
                                font: {
                                    size: 11
                                }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const value = context.raw;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = Math.round((value / total) * 100);
                                    const formattedVal = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
                                    return ` ${context.label}: ${formattedVal} (${percentage}%)`;
                                }
                            }
                        }
                    },
                    cutout: '65%' // Làm vòng tròn rỗng giữa (donut style)
                }
            });
        </c:if>
    });
</script>

<!-- Nhúng Footer dùng chung -->
<jsp:include page="common/footer.jsp" />
