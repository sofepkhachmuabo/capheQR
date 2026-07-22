-- SQL Script khởi tạo CSDL PostgreSQL cho Supabase (Không dùng ngoặc kép để PostgreSQL tự khớp tên bảng với Hibernate)
-- Dự án: QRCoffeePoly

-- 0. Xóa các bảng cũ nếu tồn tại
DROP TABLE IF EXISTS ChiTietHoaDon CASCADE;
DROP TABLE IF EXISTS HoaDon CASCADE;
DROP TABLE IF EXISTS Ban CASCADE;
DROP TABLE IF EXISTS NguoiDung CASCADE;
DROP TABLE IF EXISTS VaiTro CASCADE;
DROP TABLE IF EXISTS SanPham CASCADE;
DROP TABLE IF EXISTS DanhMuc CASCADE;
DROP TABLE IF EXISTS KhachHang CASCADE;

-- 1. Bảng Vai trò (VaiTro)
CREATE TABLE VaiTro (
    MaVaiTro VARCHAR(20) PRIMARY KEY,
    TenVaiTro VARCHAR(50) NOT NULL
);

-- 2. Bảng Người dùng / Nhân viên (NguoiDung)
CREATE TABLE NguoiDung (
    MaNguoiDung SERIAL PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    SoDienThoai VARCHAR(15) UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    TrangThai VARCHAR(20) DEFAULT 'HoatDong',
    MaVaiTro VARCHAR(20) REFERENCES VaiTro(MaVaiTro),
    HinhAnh VARCHAR(2000)
);

-- 3. Bảng Bàn ăn (Ban)
CREATE TABLE Ban (
    MaBan SERIAL PRIMARY KEY,
    TenBan VARCHAR(50) NOT NULL,
    MaCodeQR VARCHAR(255) UNIQUE,
    TrangThai VARCHAR(20) DEFAULT 'Trong'
);

-- 4. Bảng Danh mục (DanhMuc)
CREATE TABLE DanhMuc (
    MaDanhMuc SERIAL PRIMARY KEY,
    TenDanhMuc VARCHAR(100) NOT NULL,
    MoTa VARCHAR(255)
);

-- 5. Bảng Sản phẩm (SanPham)
CREATE TABLE SanPham (
    MaSanPham SERIAL PRIMARY KEY,
    TenSanPham VARCHAR(100) NOT NULL,
    GiaCoBan DECIMAL(18,2) NOT NULL CHECK (GiaCoBan >= 0),
    HinhAnh VARCHAR(2000),
    MoTa TEXT,
    TrangThai VARCHAR(20) DEFAULT 'DangBan',
    MaDanhMuc INT REFERENCES DanhMuc(MaDanhMuc) ON DELETE SET NULL
);

-- 6. Bảng Khách hàng (KhachHang)
CREATE TABLE KhachHang (
    MaKhachHang SERIAL PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) NULL,
    DiemTichLuy INT DEFAULT 0 CHECK (DiemTichLuy >= 0),
    TrangThai VARCHAR(20) DEFAULT 'HoatDong',
    NgayDangKy TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Bảng Hóa đơn (HoaDon)
CREATE TABLE HoaDon (
    MaHoaDon SERIAL PRIMARY KEY,
    NgayTao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    MaBan INT NULL REFERENCES Ban(MaBan) ON DELETE SET NULL,
    MaNguoiDung INT NULL REFERENCES NguoiDung(MaNguoiDung) ON DELETE SET NULL,
    MaKhachHang INT NULL REFERENCES KhachHang(MaKhachHang) ON DELETE SET NULL,
    TongTien DECIMAL(18,2) NOT NULL DEFAULT 0 CHECK (TongTien >= 0),
    TrangThai VARCHAR(50) DEFAULT 'ChoThanhToan',
    LoaiHoaDon VARCHAR(20) DEFAULT 'TaiCho',
    GhiChu VARCHAR(255)
);

-- 8. Bảng Chi tiết hóa đơn (ChiTietHoaDon)
CREATE TABLE ChiTietHoaDon (
    MaChiTiet SERIAL PRIMARY KEY,
    MaHoaDon INT REFERENCES HoaDon(MaHoaDon) ON DELETE CASCADE,
    MaSanPham INT REFERENCES SanPham(MaSanPham) ON DELETE CASCADE,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(18,2) NOT NULL CHECK (DonGia >= 0),
    GhiChu VARCHAR(255)
);

-- ===================================================
-- CHÈN DỮ LIỆU MẪU (SEED DATA)
-- ===================================================

-- 1. Chèn vai trò
INSERT INTO VaiTro (MaVaiTro, TenVaiTro) VALUES 
('ADMIN', 'Quản trị viên'),
('NHANVIEN', 'Nhân viên bán hàng');

-- 2. Chèn người dùng
INSERT INTO NguoiDung (HoTen, Email, SoDienThoai, MatKhau, TrangThai, MaVaiTro) VALUES
('Nguyễn Văn Anh', 'admin@qrcoffee.com', '0912345678', 'admin123', 'HoatDong', 'ADMIN'),
('Trần Thị Bình', 'binh.tt@qrcoffee.com', '0987654321', 'staff123', 'HoatDong', 'NHANVIEN'),
('Lê Văn Cường', 'cuong.lv@qrcoffee.com', '0905556667', 'staff123', 'HoatDong', 'NHANVIEN');

-- 3. Chèn danh mục
INSERT INTO DanhMuc (TenDanhMuc, MoTa) VALUES 
('Cà Phê', 'Các món nước chế biến từ hạt cà phê chất lượng cao'),
('Trà Sữa', 'Trà sữa béo ngậy kèm các loại topping phong phú'),
('Nước Ép & Sinh Tố', 'Nước trái cây tươi mát, giàu vitamin');

-- 4. Chèn sản phẩm
INSERT INTO SanPham (TenSanPham, GiaCoBan, HinhAnh, MoTa, TrangThai, MaDanhMuc) VALUES 
('Cà Phê Sữa Đá', 29000, 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=500', 'Cà phê sữa đá truyền thống đậm vị.', 'DangBan', 1),
('Cà Phê Đen Đá', 25000, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500', 'Cà phê đen nguyên chất không đường.', 'DangBan', 1),
('Trà Sữa Trân Châu Hoàng Kim', 39000, 'https://images.unsplash.com/photo-1541658016709-82535e94bc69?w=500', 'Trà sữa béo ngậy và trân châu hoàng kim.', 'DangBan', 2),
('Trà Đào Cam Sả', 35000, 'https://images.unsplash.com/photo-1497534446932-c925b458314e?w=500', 'Trà đào hương cam sả thanh ngọt.', 'DangBan', 2),
('Nước Ép Cam Tươi', 32000, 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=500', 'Nước cam vắt giàu vitamin C.', 'DangBan', 3),
('Sinh Tố Bơ', 42000, 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=500', 'Sinh tố bơ sáp béo ngậy.', 'DangBan', 3);

-- 5. Chèn bàn ăn
INSERT INTO Ban (TenBan, MaCodeQR, TrangThai) VALUES
('Bàn 1', 'TABLE_01', 'CoKhach'),
('Bàn 2', 'TABLE_02', 'Trong'),
('Bàn 3', 'TABLE_03', 'CoKhach'),
('Bàn 4', 'TABLE_04', 'Trong'),
('Bàn 5', 'TABLE_05', 'DatTruoc'),
('Bàn 6', 'TABLE_06', 'Trong'),
('Bàn 7', 'TABLE_07', 'Trong'),
('Bàn 8', 'TABLE_08', 'CoKhach');

-- 6. Chèn khách hàng
INSERT INTO KhachHang (HoTen, SoDienThoai, Email, DiemTichLuy) VALUES
('Nguyễn Thị Mai', '0981112222', 'mai.nt@gmail.com', 150),
('Phạm Văn Nam', '0973334444', 'nam.pv@gmail.com', 80),
('Lê Hoàng Long', '0965556666', 'long.lh@gmail.com', 320);

-- 7. Chèn hóa đơn mẫu
INSERT INTO HoaDon (NgayTao, MaBan, MaNguoiDung, MaKhachHang, TongTien, TrangThai, LoaiHoaDon) VALUES
(CURRENT_TIMESTAMP, 1, 2, 1, 58000.0, 'DaThanhToan', 'TaiCho'),
(CURRENT_TIMESTAMP, 3, 2, 2, 117000.0, 'DaThanhToan', 'TaiCho'),
(CURRENT_TIMESTAMP, 8, 3, 3, 35000.0, 'DaThanhToan', 'TaiCho'),
(CURRENT_TIMESTAMP - INTERVAL '1 day', 2, 3, NULL, 67000.0, 'DaThanhToan', 'TaiCho'),
(CURRENT_TIMESTAMP, 5, 2, NULL, 39000.0, 'ChoThanhToan', 'TaiCho');

-- 8. Chèn chi tiết hóa đơn
INSERT INTO ChiTietHoaDon (MaHoaDon, MaSanPham, SoLuong, DonGia) VALUES
(1, 1, 2, 29000.0),
(2, 3, 3, 39000.0),
(3, 4, 1, 35000.0),
(4, 1, 1, 29000.0),
(4, 3, 1, 38000.0),
(5, 3, 1, 39000.0);

-- 9. Tạo Index
CREATE INDEX IX_HoaDon_NgayTao_TrangThai ON HoaDon(NgayTao, TrangThai);
CREATE INDEX IX_SanPham_TrangThai ON SanPham(TrangThai);
CREATE UNIQUE INDEX UX_KhachHang_Email ON KhachHang(Email) WHERE Email IS NOT NULL;
