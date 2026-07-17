package dao;

import entity.Table;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.JpaUtils;

import java.util.List;

/**
 * Lớp DAO thực hiện các truy vấn trên bảng Ban (Bàn ăn / Bàn nước).
 */
public class TableDao {

    /**
     * Lấy toàn bộ danh sách bàn.
     * 
     * @return List<Table>
     */
    public List<Table> findAll() {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT t FROM Table t ORDER BY t.maBan ASC";
            TypedQuery<Table> query = em.createQuery(jpql, Table.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Tìm bàn dựa trên mã Code QR.
     * 
     * @param qrCode Mã Code QR của bàn (Ví dụ: TABLE_01)
     * @return Table đối tượng bàn tìm thấy hoặc null nếu không tồn tại
     */
    public Table findByQR(String qrCode) {
        if (qrCode == null || qrCode.trim().isEmpty()) {
            return null;
        }
        EntityManager em = JpaUtils.getEntityManager();
        try {
            String jpql = "SELECT t FROM Table t WHERE t.maCodeQR = :qrCode";
            TypedQuery<Table> query = em.createQuery(jpql, Table.class);
            query.setParameter("qrCode", qrCode);
            List<Table> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    /**
     * Tìm bàn theo mã bàn (ID).
     * 
     * @param id Mã bàn
     * @return Table
     */
    public Table findById(int id) {
        EntityManager em = JpaUtils.getEntityManager();
        try {
            return em.find(Table.class, id);
        } finally {
            em.close();
        }
    }

    /**
     * Cập nhật thông tin bàn ăn (Trạng thái).
     */
    public Table update(Table table) {
        EntityManager em = JpaUtils.getEntityManager();
        jakarta.persistence.EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Table merged = em.merge(table);
            tx.commit();
            return merged;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Lỗi khi cập nhật trạng thái bàn: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}
