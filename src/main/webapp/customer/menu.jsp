<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    // Bảo vệ: Nếu người dùng truy cập trực tiếp file JSP này thay vì qua Servlet /menu
    if (request.getAttribute("drinks") == null) {
        response.sendRedirect(request.getContextPath() + "/menu");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thực Đơn - QRCoffeePoly</title>
    <!-- Google Fonts: Outfit & Plus Jakarta Sans -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        /* Định nghĩa biến màu sắc: Giao diện sáng ấm áp (Light Warm Cream Theme) */
        :root {
            --primary-color: #00704a;       /* Xanh lá đậm ấm áp */
            --primary-hover: #1e3932;      /* Xanh lá rừng sâu */
            --accent-color: #b5835a;       /* Nâu đồng cà phê */
            --bg-color: #f8f6f2;           /* Nền kem sáng ấm */
            --card-bg: #ffffff;            /* Nền thẻ trắng tinh */
            --card-text: #2d1a12;          /* Chữ nâu Espresso đậm - Cực kỳ dễ đọc */
            --text-muted: #6e625e;         /* Chữ phụ màu nâu hạt dẻ */
            --border-color: rgba(45, 26, 18, 0.12);
            --overlay-color: linear-gradient(180deg, rgba(248, 246, 242, 0.85) 0%, rgba(248, 246, 242, 0.96) 100%);
            --shadow-color: rgba(45, 26, 18, 0.06);
            --header-bg: rgba(248, 246, 242, 0.9);
            --panel-bg: #ffffff;
            --input-bg: rgba(45, 26, 18, 0.04);
            --pill-bg: rgba(45, 26, 18, 0.04);
            --pill-text: #6e625e;
            --badge-bg: #00704a;
            --badge-text: #ffffff;
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Outfit', sans-serif;
            background-color: var(--bg-color);
            background-image: url('https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=1600');
            background-repeat: no-repeat;
            background-position: center center;
            background-attachment: fixed;
            background-size: cover;
            color: var(--card-text);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* Video Background */
        .video-background {
            position: fixed;
            right: 0;
            bottom: 0;
            min-width: 100%;
            min-height: 100%;
            width: auto;
            height: auto;
            z-index: -100;
            object-fit: cover;
            opacity: 0.18; /* Độ mờ video nhẹ nhàng */
            filter: saturate(0.8) contrast(1.05);
        }

        /* Background overlay */
        .bg-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--overlay-color);
            z-index: -99;
        }

        /* Glassmorphism Classes */
        .glass-header {
            background: var(--header-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border-color);
            z-index: 1000;
            position: sticky;
            top: 0;
        }

        .glass-card {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            box-shadow: 0 6px 18px var(--shadow-color);
            transition: transform 0.3s cubic-bezier(0.165, 0.84, 0.44, 1), 
                        border-color 0.3s ease, 
                        box-shadow 0.3s ease;
            overflow: hidden;
            height: 100%;
        }

        .glass-card:hover {
            transform: translateY(-6px);
            border-color: var(--primary-color);
            box-shadow: 0 12px 24px rgba(45, 26, 18, 0.12);
        }

        .glass-panel {
            background: var(--panel-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            box-shadow: 0 8px 24px var(--shadow-color);
        }

        /* Thẻ tính toán giỏ hàng bên phải sticky */
        .sticky-cart-panel {
            position: sticky;
            top: 100px;
            max-height: calc(100vh - 140px);
            overflow-y: auto;
        }

        /* Drink Image Hover zoom */
        .drink-img-wrapper {
            position: relative;
            overflow: hidden;
            height: 200px;
        }

        .drink-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .glass-card:hover .drink-img {
            transform: scale(1.06);
        }

        /* Buttons & Badges */
        .btn-coffee {
            background: var(--primary-color);
            border: none;
            color: #fff !important;
            font-weight: 600;
            border-radius: 50px;
            padding: 10px 22px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 112, 74, 0.15);
        }

        .btn-coffee:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0, 112, 74, 0.25);
        }

        .category-pill {
            background: var(--pill-bg);
            border: 1px solid var(--border-color);
            color: var(--pill-text);
            border-radius: 50px;
            padding: 8px 18px;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
            white-space: nowrap;
            font-size: 0.9rem;
        }

        .category-pill:hover, .category-pill.active {
            background: var(--primary-color);
            color: #ffffff;
            border-color: var(--primary-color);
            box-shadow: 0 4px 12px rgba(0, 112, 74, 0.2);
        }

        /* Form Inputs style */
        .glass-input {
            background: var(--input-bg);
            border: 1px solid var(--border-color);
            color: var(--card-text);
            border-radius: 12px;
            padding: 12px 16px;
            transition: all 0.3s ease;
        }

        .glass-input:focus {
            background: #ffffff;
            border-color: var(--primary-color);
            color: var(--card-text);
            box-shadow: 0 0 8px rgba(0, 112, 74, 0.1);
            outline: none;
        }

        /* Dropdown Select Option styling */
        select.glass-input option {
            background-color: #ffffff;
            color: var(--card-text);
        }

        .glass-input::placeholder {
            color: #9e928e;
        }

        .brand-title {
            color: var(--card-text);
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .brand-logo-circle {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            box-shadow: 0 4px 8px rgba(0, 112, 74, 0.2);
        }
    </style>
</head>
<body>

    <!-- Video Nền Loop -->
    <video class="video-background" autoplay muted loop playsinline id="bgVideo">
        <source src="https://assets.mixkit.co/videos/preview/mixkit-pouring-hot-coffee-into-a-cup-42283-large.mp4" type="video/mp4">
    </video>
    <div class="bg-overlay"></div>

    <!-- Thanh tiêu đề Glassmorphism (Loại bỏ ô chọn bàn) -->
    <header class="glass-header py-3 mb-4 shadow-sm">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-3">
                <div class="brand-logo-circle">
                    <i class="bi bi-cup-hot"></i>
                </div>
                <div>
                    <h1 class="h4 m-0 brand-title">QRCoffeePoly</h1>
                    <small class="text-success fw-bold">Coffee and Chill</small>
                </div>
            </div>
            
            <div>
                <!-- Chỉ hiển thị trạng thái cửa hàng -->
                <span class="badge bg-success text-white px-3 py-2 fs-6 rounded-pill">
                    <i class="bi bi-clock-fill me-1"></i> Open: 7:00 - 22:00
                </span>
            </div>
        </div>
    </header>

    <div class="container pb-5">
        <!-- Báo lỗi nếu có -->
        <c:if test="${not empty sessionScope.orderError}">
            <div class="alert alert-danger alert-dismissible fade show border-0 glass-panel shadow mb-4 text-danger" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <strong>Lỗi đặt món!</strong> ${sessionScope.orderError}
                <% session.removeAttribute("orderError"); %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- CỘT TRÁI: Thanh tìm kiếm, các bộ lọc và danh sách nước uống -->
            <div class="col-12 col-lg-8">
                <!-- Khối tìm kiếm & lọc danh mục -->
                <div class="glass-panel p-4 mb-4">
                    <div class="row g-3 align-items-center">
                        <!-- Tìm kiếm -->
                        <div class="col-12 col-md-7">
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-0 text-muted" id="search-addon">
                                    <i class="bi bi-search"></i>
                                </span>
                                <input type="text" class="form-control glass-input border-0 ps-0" 
                                       id="searchInput" placeholder="Tìm kiếm đồ uống yêu thích của bạn..." aria-describedby="search-addon"
                                       onkeyup="filterDrinks()">
                            </div>
                        </div>
                        <!-- Sắp xếp theo giá -->
                        <div class="col-12 col-md-5">
                            <select class="form-select glass-input border-0" id="sortSelect" onchange="filterDrinks()">
                                <option value="">Sắp xếp mặc định</option>
                                <option value="asc">Giá: Thấp đến Cao</option>
                                <option value="desc">Giá: Cao đến Thấp</option>
                            </select>
                        </div>
                    </div>

                    <!-- Thanh trượt Danh mục -->
                    <div class="d-flex gap-2 overflow-x-auto mt-3 py-2 scroll-x-hidden">
                        <div class="category-pill active" data-category="all" onclick="selectCategory('all', this)">Tất cả</div>
                        <c:forEach var="cat" items="${categories}">
                            <div class="category-pill" data-category="${cat.maDanhMuc}" onclick="selectCategory('${cat.maDanhMuc}', this)">
                                ${cat.tenDanhMuc}
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Tiêu đề thực đơn -->
                <div class="row mb-3">
                    <div class="col-12 d-flex justify-content-between align-items-center">
                        <h3 class="fw-bold m-0 brand-title"><i class="bi bi-cup-straw text-success me-2"></i>Thực Đơn Đồ Uống</h3>
                        <span class="text-muted fw-semibold" id="drinksCountText">Đang hiển thị: ${drinks.size()} món</span>
                    </div>
                </div>

                <!-- Lưới món ăn (Grid) -->
                <div class="row g-3" id="drinksGrid">
                    <c:forEach var="drink" items="${drinks}">
                        <div class="col-12 col-sm-6 col-md-6 col-lg-4 drink-card-item" 
                             data-id="${drink.maSanPham}" 
                             data-name="${drink.tenSanPham}" 
                             data-price="${drink.giaCoBan}" 
                             data-category="${drink.category.maDanhMuc}">
                            <div class="glass-card d-flex flex-column">
                                <div class="drink-img-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty drink.hinhAnh}">
                                            <img src="${drink.hinhAnh}" class="drink-img" alt="${drink.tenSanPham}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500" class="drink-img" alt="${drink.tenSanPham}">
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="badge bg-dark bg-opacity-75 text-warning px-2.5 py-1.5 fs-7 position-absolute top-3 end-3 rounded-pill border border-warning border-opacity-25">
                                        ${drink.category.tenDanhMuc}
                                    </span>
                                </div>
                                <div class="p-3 flex-grow-1 d-flex flex-column justify-content-between">
                                    <div>
                                        <h5 class="fw-bold mb-1 text-truncate-2" style="color: var(--card-text);">${drink.tenSanPham}</h5>
                                        <p class="text-muted small text-truncate-2 mb-3" style="min-height: 38px;">${drink.moTa}</p>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                        <span class="fs-5 fw-bold text-success">
                                            <fmt:formatNumber value="${drink.giaCoBan}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </span>
                                        <button onclick="addToCart(${drink.maSanPham}, '${drink.tenSanPham}', ${drink.giaCoBan}, '${drink.hinhAnh}')" 
                                                class="btn btn-coffee btn-sm px-3 rounded-pill">
                                            <i class="bi-plus-lg me-1"></i> Thêm món
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- THÔNG BÁO LỖI KHÔNG CÓ DỮ LIỆU -->
                    <c:if test="${empty drinks}">
                        <div class="col-12 py-5 text-center">
                            <div class="glass-panel p-5 mx-auto" style="max-width: 600px;">
                                <i class="bi bi-cup-hot text-success fs-1 mb-3"></i>
                                <h4 class="fw-bold mb-3">Chào mừng bạn đến với CoffeePoly!</h4>
                                <p class="text-muted mb-4">
                                    Hiện tại hệ thống thực đơn chưa được nạp dữ liệu đồ uống hoặc đang nâng cấp.
                                    Quản trị viên vui lòng chạy lại toàn bộ script SQL để chèn dữ liệu mẫu, hoặc thêm các đồ uống ở trạng thái "Đang bán" trong trang quản trị.
                                </p>
                                <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-coffee px-4 rounded-pill">
                                    <i class="bi bi-shield-lock-fill me-2"></i> Truy cập Trang Quản Trị
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- CỘT PHẢI: Bảng chứa và tính toán giá tiền (Checkout Panel) -->
            <div class="col-12 col-lg-4">
                <div class="glass-panel p-4 sticky-cart-panel shadow-sm">
                    <h5 class="fw-bold mb-3 brand-title pb-2 border-bottom border-light border-opacity-10">
                        <i class="bi bi-cart-check-fill text-success me-2"></i>Giỏ hàng của bạn
                    </h5>

                    <!-- Danh sách món đặt nước uống -->
                    <div id="cartItemsList" class="mb-3" style="max-height: 250px; overflow-y: auto;">
                        <div class="text-center text-muted py-4" id="emptyCartMessage">
                            <i class="bi bi-basket fs-2 d-block mb-2"></i>
                            Chưa chọn món nước nào.
                        </div>
                    </div>

                    <!-- Tổng cộng chi phí tính toán -->
                    <div class="glass-panel p-3 mb-4 d-flex justify-content-between align-items-center" style="background: rgba(45, 26, 18, 0.02); border-color: rgba(45, 26, 18, 0.06);">
                        <span class="text-muted fw-bold">Tổng cộng tạm tính:</span>
                        <span class="fs-4 fw-bold text-success" id="drawerTotalSum">0đ</span>
                    </div>

                    <!-- Form thông tin khách hàng & Bàn ăn -->
                    <form action="${pageContext.request.contextPath}/place-order" method="POST" id="orderCheckoutForm" onsubmit="return validateCheckoutForm()">
                        <h6 class="fw-bold mb-3 brand-title"><i class="bi bi-person-badge-fill text-success me-2"></i>Thông tin đặt hàng</h6>
                        
                        <!-- Tên khách hàng -->
                        <div class="mb-3">
                            <label for="customerName" class="form-label text-muted small fw-bold">Tên khách hàng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control glass-input w-100" id="customerName" name="customerName" 
                                   placeholder="Nhập tên của bạn" required>
                            <div class="invalid-feedback text-danger" id="nameError" style="display:none;">Tên từ 2-50 kí tự tiếng Việt có dấu.</div>
                        </div>

                        <!-- Số điện thoại -->
                        <div class="mb-3">
                            <label for="customerPhone" class="form-label text-muted small fw-bold">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control glass-input w-100" id="customerPhone" name="customerPhone" 
                                   placeholder="Ví dụ: 0912345678" required>
                            <div class="invalid-feedback text-danger" id="phoneError" style="display:none;">Số điện thoại không hợp lệ (10 số).</div>
                        </div>

                        <!-- Bàn ăn (Lọc ẩn bàn có người, hiển thị bảo trì hoặc trống) -->
                        <div class="mb-3">
                            <label for="orderTableId" class="form-label text-muted small fw-bold">Bàn của bạn <span class="text-danger">*</span></label>
                            <select class="form-select glass-input w-100" id="orderTableId" name="tableId" required onchange="saveTableToSession(this.value)">
                                <option value="">-- Chọn bàn --</option>
                                <c:forEach var="tbl" items="${tables}">
                                    <c:choose>
                                        <%-- Trạng thái 'Trong': hiển thị bình thường --%>
                                        <c:when test="${tbl.trangThai == 'Trong'}">
                                            <option value="${tbl.maBan}" ${sessionScope.customerTable.maBan == tbl.maBan ? 'selected' : ''}>
                                                ${tbl.tenBan} (Trống)
                                            </option>
                                        </c:when>
                                        <%-- Trạng thái 'BaoTri': hiển thị nhưng disabled (không thể chọn) --%>
                                        <c:when test="${tbl.trangThai == 'BaoTri'}">
                                            <option value="${tbl.maBan}" disabled style="color: #9e928e;">
                                                ${tbl.tenBan} (Bảo trì)
                                            </option>
                                        </c:when>
                                        <%-- Trạng thái 'CoKhach' hoặc 'DatTruoc' (Đã có người): ẩn đi hoàn toàn --%>
                                    </c:choose>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Ghi chú món nước -->
                        <div class="mb-3">
                            <label for="note" class="form-label text-muted small fw-bold">Ghi chú pha chế</label>
                            <textarea class="form-control glass-input w-100" id="note" name="note" rows="2" placeholder="Ví dụ: Ít đá, ít ngọt..."></textarea>
                        </div>

                        <!-- Nơi chứa các input ẩn chứa giỏ hàng gửi lên server -->
                        <div id="hiddenCartInputs"></div>

                        <!-- Nút Đặt món -->
                        <button type="button" id="submitOrderBtn" onclick="submitOrder()" class="btn btn-coffee w-100 py-3 fs-5 mt-2">
                            <i class="bi bi-check2-circle me-2"></i> Gửi Yêu Cầu Đặt Món
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Javascript xử lý hoạt động Menu, Giỏ hàng & Lọc dữ liệu -->
    <script>
        // Trạng thái giỏ hàng
        let cart = [];
        let activeCategory = 'all';

        // 1. Tải giỏ hàng từ localStorage
        document.addEventListener("DOMContentLoaded", function() {
            // Tải giỏ hàng
            if (localStorage.getItem("coffee_cart")) {
                try {
                    cart = JSON.parse(localStorage.getItem("coffee_cart"));
                    updateCartUI();
                } catch (e) {
                    cart = [];
                }
            }
            
            // Đồng bộ hoá Table ID ban đầu
            const tblId = document.getElementById("orderTableId").value;
            if (tblId) {
                saveTableToSession(tblId);
            }
        });

        // 2. Hàm thêm sản phẩm vào giỏ hàng
        function addToCart(id, name, price, img) {
            const existingItem = cart.find(item => item.id === id);
            if (existingItem) {
                existingItem.quantity += 1;
            } else {
                cart.push({
                    id: id,
                    name: name,
                    price: price,
                    img: img || 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500',
                    quantity: 1
                });
            }
            saveCart();
            updateCartUI();
        }

        // Tăng giảm số lượng trong Giỏ hàng
        function changeQty(id, delta) {
            const item = cart.find(item => item.id === id);
            if (item) {
                item.quantity += delta;
                if (item.quantity <= 0) {
                    cart = cart.filter(c => c.id !== id);
                }
                saveCart();
                updateCartUI();
            }
        }

        // Lưu giỏ hàng vào localStorage
        function saveCart() {
            localStorage.setItem("coffee_cart", JSON.stringify(cart));
        }

        // Cập nhật giao diện giỏ hàng bên phải (Dùng nối chuỗi an toàn tránh EL)
        function updateCartUI() {
            const drawerTotalSum = document.getElementById("drawerTotalSum");
            const cartItemsList = document.getElementById("cartItemsList");
            const submitOrderBtn = document.getElementById("submitOrderBtn");
            
            let totalQty = 0;
            let totalPrice = 0;

            if (cart.length === 0) {
                cartItemsList.innerHTML = 
                    '<div class="text-center text-muted py-4" id="emptyCartMessage">' +
                    '  <i class="bi bi-basket fs-2 d-block mb-2"></i>' +
                    '  Chưa chọn món nước nào.' +
                    '</div>';
                if (drawerTotalSum) drawerTotalSum.innerText = '0đ';
                if (submitOrderBtn) submitOrderBtn.disabled = true;
                return;
            }

            if (submitOrderBtn) submitOrderBtn.disabled = false;

            // Render danh sách món bằng nối chuỗi
            let itemsHtml = '';
            cart.forEach(item => {
                totalQty += item.quantity;
                totalPrice += item.price * item.quantity;

                itemsHtml += '<div class="d-flex align-items-center justify-content-between mb-3 pb-3 border-bottom border-light border-opacity-10">';
                itemsHtml += '  <div class="d-flex align-items-center" style="max-width: 60%;">';
                itemsHtml += '    <img src="' + item.img + '" alt="' + item.name + '" class="rounded" style="width: 40px; height: 40px; object-fit: cover;">';
                itemsHtml += '    <div class="ms-2">';
                itemsHtml += '      <h6 class="fw-bold mb-0 text-truncate text-wrap" style="font-size: 0.9rem; color: var(--card-text);">' + item.name + '</h6>';
                itemsHtml += '      <small class="text-success fw-bold">' + formatMoney(item.price) + '</small>';
                itemsHtml += '    </div>';
                itemsHtml += '  </div>';
                itemsHtml += '  <div class="d-flex align-items-center">';
                itemsHtml += '    <button type="button" class="btn btn-sm btn-outline-secondary border-opacity-25 rounded-circle p-0" style="width:24px; height:24px; line-height:1;" onclick="changeQty(' + item.id + ', -1)">';
                itemsHtml += '      <i class="bi bi-dash"></i>';
                itemsHtml += '    </button>';
                itemsHtml += '    <span class="mx-2 fw-bold" style="font-size: 0.9rem; color: var(--card-text);">' + item.quantity + '</span>';
                itemsHtml += '    <button type="button" class="btn btn-sm btn-outline-secondary border-opacity-25 rounded-circle p-0" style="width:24px; height:24px; line-height:1;" onclick="changeQty(' + item.id + ', 1)">';
                itemsHtml += '      <i class="bi bi-plus"></i>';
                itemsHtml += '    </button>';
                itemsHtml += '  </div>';
                itemsHtml += '</div>';
            });

            cartItemsList.innerHTML = itemsHtml;
            if (drawerTotalSum) drawerTotalSum.innerText = formatMoney(totalPrice);
        }

        // Format tiền tệ dạng VNĐ
        function formatMoney(num) {
            return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num).replace('₫', 'đ');
        }

        // Lưu bàn ăn vào Server Session thông qua AJAX khi thay đổi ở panel đặt món
        function saveTableToSession(val) {
            if (!val) return;
            fetch('${pageContext.request.contextPath}/menu?table_ajax_save=true', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'tableId=' + val
            });
        }

        // 3. XỬ LÝ LỌC & TÌM KIẾM ĐỒ UỐNG (Real-time Filtering)
        function selectCategory(catId, element) {
            activeCategory = catId;
            
            document.querySelectorAll('.category-pill').forEach(pill => {
                pill.classList.remove('active');
            });
            element.classList.add('active');

            filterDrinks();
        }

        // Khắc phục bộ lọc bằng cách lấy đúng thuộc tính
        function filterDrinks() {
            const searchVal = document.getElementById("searchInput").value.toLowerCase().trim();
            const sortVal = document.getElementById("sortSelect").value;
            const items = document.querySelectorAll(".drink-card-item");
            
            let visibleCount = 0;
            let drinkArr = [];

            items.forEach(item => {
                const name = item.getAttribute("data-name").toLowerCase();
                const category = item.getAttribute("data-category");

                const matchesCategory = (activeCategory === 'all' || category === activeCategory);
                const matchesSearch = (searchVal === '' || name.includes(searchVal));

                if (matchesCategory && matchesSearch) {
                    item.style.display = "block";
                    drinkArr.push(item);
                    visibleCount++;
                } else {
                    item.style.display = "none";
                }
            });

            // Sắp xếp các món đang hiển thị
            const grid = document.getElementById("drinksGrid");
            if (sortVal === 'asc') {
                drinkArr.sort((a, b) => parseFloat(a.getAttribute("data-price")) - parseFloat(b.getAttribute("data-price")));
                drinkArr.forEach(item => grid.appendChild(item));
            } else if (sortVal === 'desc') {
                drinkArr.sort((a, b) => parseFloat(b.getAttribute("data-price")) - parseFloat(a.getAttribute("data-price")));
                drinkArr.forEach(item => grid.appendChild(item));
            }

            const txt = document.getElementById("drinksCountText");
            if (txt) {
                txt.innerText = "Đang hiển thị: " + visibleCount + " món";
            }
        }

        // 4. BẢO MẬT THÔNG TIN & KIỂM TRA DỮ LIỆU ĐẦU VÀO (Validation)
        function validateCheckoutForm() {
            const name = document.getElementById("customerName").value.trim();
            const phone = document.getElementById("customerPhone").value.trim();
            const table = document.getElementById("orderTableId").value;
            
            let isValid = true;

            document.getElementById("nameError").style.display = "none";
            document.getElementById("phoneError").style.display = "none";

            // Kiểm tra tên hợp lệ (không chứa ký tự đặc biệt độc hại, dài 2-50 ký tự)
            const namePattern = /^[\p{L}\s']{2,50}$/u;
            if (!namePattern.test(name)) {
                document.getElementById("nameError").style.display = "block";
                isValid = false;
            }

            // Kiểm tra số điện thoại (đủ 10 chữ số)
            const phonePattern = /^(0[3|5|7|8|9])+([0-9]{8})$/;
            if (!phonePattern.test(phone)) {
                document.getElementById("phoneError").style.display = "block";
                isValid = false;
            }

            if (!table) {
                isValid = false;
            }

            // Phòng chống XSS: loại bỏ các ký tự tag HTML
            document.getElementById("customerName").value = name.replace(/<[^>]*>/g, "");
            
            return isValid;
        }

        // Gửi biểu mẫu đặt món lên Server
        function submitOrder() {
            if (cart.length === 0) {
                alert("Giỏ hàng của bạn đang trống!");
                return;
            }

            if (!validateCheckoutForm()) {
                alert("Vui lòng nhập đầy đủ và chính xác thông tin đặt hàng!");
                return;
            }

            const form = document.getElementById("orderCheckoutForm");
            const hiddenContainer = document.getElementById("hiddenCartInputs");
            hiddenContainer.innerHTML = ''; // Xóa sạch dữ liệu cũ

            // Chèn các input ẩn
            cart.forEach(item => {
                const idInput = document.createElement("input");
                idInput.type = "hidden";
                idInput.name = "drinkIds";
                idInput.value = item.id;

                const qtyInput = document.createElement("input");
                qtyInput.type = "hidden";
                qtyInput.name = "quantities";
                qtyInput.value = item.quantity;

                hiddenContainer.appendChild(idInput);
                hiddenContainer.appendChild(qtyInput);
            });

            // Vô hiệu hóa nút để tránh click trùng lặp (Double click prevention)
            const submitBtn = document.getElementById("submitOrderBtn");
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Đang gửi đặt món...';

            // Xóa giỏ hàng trong localStorage để khách không đặt trùng sau khi submit thành công
            localStorage.removeItem("coffee_cart");

            form.submit();
        }
    </script>
</body>
</html>
