<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QRCoffeePoly - Trang Quản Trị</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/slide/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Custom CSS Dành riêng cho Admin -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css">
</head>
<body>

<div id="wrapper">
    <!-- Thanh điều hướng Sidebar -->
    <nav id="sidebar">
        <div class="sidebar-header">
            <h3>QRCoffeePoly</h3>
        </div>

        <ul class="list-unstyled components">
            <li class="${requestScope['javax.servlet.forward.servlet_path'] == '/admin/dashboard' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-speedometer2"></i> Bảng điều khiển
                </a>
            </li>
            <li class="${requestScope['javax.servlet.forward.servlet_path'] == '/admin/drinks' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/drinks">
                    <i class="bi bi-cup-hot"></i> Quản lý thức uống
                </a>
            </li>
            <li class="${requestScope['javax.servlet.forward.servlet_path'] == '/admin/employees' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/employees">
                    <i class="bi bi-people"></i> Quản lý nhân viên
                </a>
            </li>
            <li class="${requestScope['javax.servlet.forward.servlet_path'] == '/admin/customers' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/customers">
                    <i class="bi bi-person-badge"></i> Quản lý khách hàng
                </a>
            </li>
            <li class="${requestScope['javax.servlet.forward.servlet_path'] == '/admin/revenue' ? 'active' : ''}">
                <a href="${pageContext.request.contextPath}/admin/revenue">
                    <i class="bi bi-cash-coin"></i> Báo cáo doanh thu
                </a>
            </li>
            <li class="mt-5">
                <a href="${pageContext.request.contextPath}/admin/logout" class="text-danger">
                    <i class="bi bi-box-arrow-right text-danger"></i> Đăng xuất
                </a>
            </li>
        </ul>
    </nav>

    <!-- Khối nội dung chính bên phải -->
    <div id="content">
        <!-- Top Navbar -->
        <nav class="navbar navbar-expand-lg top-navbar">
            <div class="container-fluid p-0">
                <!-- Nút Thu gọn Sidebar trên Mobile -->
                <button type="button" id="sidebarCollapse" class="btn btn-outline-secondary border-0">
                    <i class="bi bi-list fs-4"></i>
                </button>
                
                <div class="ms-auto d-flex align-items-center">
                    <span class="me-3 d-none d-md-inline-block text-muted">Xin chào, <strong>${sessionScope.adminName}</strong></span>
                    <div class="dropdown">
                        <div class="user-profile dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                            <c:choose>
                                <c:when test="${not empty sessionScope.adminAvatar}">
                                    <c:choose>
                                        <c:when test="${sessionScope.adminAvatar.startsWith('http')}">
                                            <img src="${sessionScope.adminAvatar}" alt="Avatar Admin">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/admin/images/${sessionScope.adminAvatar}" alt="Avatar Admin" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100';">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100" alt="Avatar Admin">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <ul class="dropdown-menu dropdown-menu-end shadow border-0" style="border-radius: 12px;">
                            <li><a class="dropdown-item py-2" href="#"><i class="bi bi-person me-2"></i> Hồ sơ</a></li>
                            <li><a class="dropdown-item py-2" href="#"><i class="bi bi-gear me-2"></i> Thiết lập</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/admin/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>
