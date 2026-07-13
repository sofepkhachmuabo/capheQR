package entity;

import jakarta.persistence.*;
import jakarta.persistence.Table;

import java.io.Serializable;
import java.util.Date;

/**
 * Entity đại diện cho bảng KhachHang (Khách hàng).
 */
@Entity
@Table(name = "KhachHang")
public class Customer implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaKhachHang")
    private int maKhachHang;

    @Column(name = "HoTen", nullable = false, length = 100)
    private String hoTen;

    @Column(name = "SoDienThoai", unique = true, nullable = false, length = 15)
    private String soDienThoai;

    @Column(name = "Email", unique = true, length = 100)
    private String email;

    @Column(name = "DiemTichLuy")
    private int diemTichLuy = 0;

    @Column(name = "TrangThai", length = 20)
    private String trangThai = "HoatDong"; // HoatDong, NgungHoatDong

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "NgayDangKy")
    private Date ngayDangKy = new Date();

    public Customer() {
    }

    public Customer(String hoTen, String soDienThoai, String email, int diemTichLuy, String trangThai) {
        this.hoTen = hoTen;
        this.soDienThoai = soDienThoai;
        this.email = email;
        this.diemTichLuy = diemTichLuy;
        this.trangThai = trangThai;
    }

    // Getters and Setters
    public int getMaKhachHang() {
        return maKhachHang;
    }

    public void setMaKhachHang(int maKhachHang) {
        this.maKhachHang = maKhachHang;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getSoDienThoai() {
        return soDienThoai;
    }

    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getDiemTichLuy() {
        return diemTichLuy;
    }

    public void setDiemTichLuy(int diemTichLuy) {
        this.diemTichLuy = diemTichLuy;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public Date getNgayDangKy() {
        return ngayDangKy;
    }

    public void setNgayDangKy(Date ngayDangKy) {
        this.ngayDangKy = ngayDangKy;
    }
}
