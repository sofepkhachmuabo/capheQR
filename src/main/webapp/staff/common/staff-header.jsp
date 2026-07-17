<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QRCoffeePoly - Nhân Viên Nhận Đơn</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts Outfit -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-coffee: #8c6239;
            --primary-coffee-hover: #6f4e2c;
            --secondary-gold: #d4a373;
            --bg-dark: #1e1b18;
            --bg-light-coffee: #fbf8f3;
            --text-dark: #3a322d;
            --text-muted: #8c837c;
            --card-shadow: 0 10px 30px rgba(140, 98, 57, 0.08);
            --border-radius: 12px;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg-light-coffee);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Top Navbar */
        .staff-navbar {
            background-color: var(--bg-dark);
            padding: 15px 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }

        .staff-navbar .navbar-brand {
            font-weight: 700;
            font-size: 1.4rem;
            color: var(--secondary-gold) !important;
            display: flex;
            align-items: center;
        }

        .staff-navbar .nav-link {
            color: #c4bbb3 !important;
            font-weight: 500;
            padding: 8px 16px !important;
            border-radius: 8px;
            transition: all 0.3s;
            margin-right: 10px;
        }

        .staff-navbar .nav-link:hover, 
        .staff-navbar .nav-link.active {
            color: white !important;
            background-color: rgba(212, 163, 115, 0.15);
        }

        .staff-navbar .nav-link.active {
            border-bottom: 2px solid var(--secondary-gold);
            border-radius: 8px 8px 0 0;
        }

        .user-profile {
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .user-profile img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            border: 2px solid var(--secondary-gold);
            object-fit: cover;
        }

        /* Custom UI Components */
        .custom-card {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 25px;
            box-shadow: var(--card-shadow);
            border: none;
            margin-bottom: 25px;
        }

        .badge-status {
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 30px;
            font-size: 0.85rem;
            display: inline-block;
        }

        .status-chothanhtoan {
            background-color: rgba(255, 193, 7, 0.15);
            color: #ff9800;
            border: 1px solid rgba(255, 193, 7, 0.3);
        }

        .status-dangchebien {
            background-color: rgba(13, 110, 253, 0.15);
            color: #0d6efd;
            border: 1px solid rgba(13, 110, 253, 0.3);
        }

        .status-dagiao {
            background-color: rgba(111, 66, 193, 0.15);
            color: #6f42c1;
            border: 1px solid rgba(111, 66, 193, 0.3);
        }

        .status-dathanhtoan {
            background-color: rgba(25, 135, 84, 0.15);
            color: #198754;
            border: 1px solid rgba(25, 135, 84, 0.3);
        }

        .status-dahuy {
            background-color: rgba(220, 53, 69, 0.15);
            color: #dc3545;
            border: 1px solid rgba(220, 53, 69, 0.3);
        }

        /* Print Invoice Style Optimization */
        @media print {
            body {
                background-color: white;
                color: black;
            }
            .staff-navbar, .no-print, footer, .btn-action-container {
                display: none !important;
            }
            .print-invoice-card {
                box-shadow: none !important;
                border: none !important;
                padding: 0 !important;
                margin: 0 !important;
                width: 100% !important;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg staff-navbar navbar-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/orders">
            <i class="bi bi-cup-hot-fill me-2"></i> QRCoffeePoly - Nhân Viên
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#staffNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="staffNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                <li class="nav-item">
                    <a class="nav-link ${currentTab == 'active' && activeMenu != 'tables' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/orders">
                        <i class="bi bi-receipt-cutoff me-1"></i> Đơn Hàng Đang Xử Lý
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${currentTab == 'all' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/orders?status=All">
                        <i class="bi bi-clock-history me-1"></i> Lịch Sử Đơn Hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeMenu == 'tables' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/tables">
                        <i class="bi bi-grid-3x3-gap-fill me-1"></i> Quản Lý Bàn Ăn
                    </a>
                </li>
            </ul>
            
            <div class="d-flex align-items-center">
                <span class="text-light me-3 d-none d-md-inline-block">
                    Xin chào, <strong style="color: var(--secondary-gold);">${sessionScope.adminName}</strong> (Nhân viên)
                </span>
                <div class="dropdown">
                    <div class="user-profile dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                        <c:choose>
                            <c:when test="${not empty sessionScope.adminAvatar}">
                                <c:choose>
                                    <c:when test="${sessionScope.adminAvatar.startsWith('http')}">
                                        <img src="${sessionScope.adminAvatar}" alt="Avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/admin/images/${sessionScope.adminAvatar}" alt="Avatar" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100';">
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100" alt="Avatar">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0" style="border-radius: 12px; margin-top: 10px;">
                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/admin/logout"><i class="bi bi-box-arrow-right me-2"></i> Đăng xuất (Giao ca)</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="container my-4 flex-grow-1">
