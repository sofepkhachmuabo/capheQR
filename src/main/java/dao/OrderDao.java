package dao;

import entity.Order;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import utils.JpaUtils;
import java.util.List;

/**
 * Lớp DAO thực hiện các thao tác trên bảng HoaDon (Order).
 */
public class OrderDao {

    /**
     * Lưu đơn hàng mới vào cơ sở dữ liệu.
     * Cả Order và các OrderDetail liên quan sẽ được lưu nhờ CascadeType.ALL.
     * 
     * @param order Đối tượng đơn hàng cần lưu
     * @return Order đối tượng sau khi lưu
     */
    public Order create(Order order) {
        EntityManager em = JpaUtils.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(order);
            tx.commit();
            return order;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Lỗi khi tạo đơn hàng: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public Order findById(int id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            Order order = em.find(Order.class, id);
            if (order != null) {
                // Khởi tạo các quan hệ Lazy/Proxy khi EntityManager còn mở để tránh LazyInitializationException ngoài JSP
                if (order.getOrderDetails() != null) {
                    order.getOrderDetails().size();
                    for (entity.OrderDetail detail : order.getOrderDetails()) {
                        if (detail.getDrink() != null) {
                            detail.getDrink().getTenSanPham();
                        }
                    }
                }
                if (order.getCustomer() != null) {
                    order.getCustomer().getHoTen();
                    order.getCustomer().getSoDienThoai();
                }
                if (order.getTable() != null) {
                    order.getTable().getTenBan();
                }
                if (order.getUser() != null) {
                    order.getUser().getHoTen();
                    order.getUser().getEmail();
                }
            }
            return order;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy toàn bộ danh sách đơn hàng sắp xếp theo ngày tạo mới nhất.
     * Tránh LazyInitializationException bằng cách nạp trước các quan hệ.
     */
    public List<Order> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT DISTINCT o FROM Order o " +
                          "LEFT JOIN FETCH o.table " +
                          "LEFT JOIN FETCH o.customer " +
                          "LEFT JOIN FETCH o.user " +
                          "ORDER BY o.ngayTao DESC";
            TypedQuery<Order> query = em.createQuery(jpql, Order.class);
            List<Order> list = query.getResultList();
            for (Order o : list) {
                if (o.getOrderDetails() != null) {
                    o.getOrderDetails().size(); // Khởi tạo danh sách chi tiết
                    for (entity.OrderDetail detail : o.getOrderDetails()) {
                        if (detail.getDrink() != null) {
                            detail.getDrink().getTenSanPham(); // Khởi tạo đồ uống
                        }
                    }
                }
            }
            return list;
        } finally {
            em.close();
        }
    }

    /**
     * Cập nhật thông tin đơn hàng vào cơ sở dữ liệu.
     */
    public Order update(Order order) {
        EntityManager em = JpaUtils.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Order mergedOrder = em.merge(order);
            tx.commit();
            return mergedOrder;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Lỗi khi cập nhật đơn hàng: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}
