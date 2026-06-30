package utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Lớp tiện ích quản lý kết nối và cung cấp EntityManager cho dự án sử dụng JPA / Hibernate.
 */
public class JpaUtils {
    private static final EntityManagerFactory factory;

    static {
        try {
            // Khởi tạo EntityManagerFactory dựa trên Persistence Unit "CoffeeShopPU" đã định nghĩa trong persistence.xml
            factory = Persistence.createEntityManagerFactory("CoffeeShopPU");
        } catch (Throwable ex) {
            System.err.println("Khởi tạo EntityManagerFactory thất bại: " + ex.getMessage());
            ex.printStackTrace();
            throw new ExceptionInInitializerError(ex);
        }
    }

    /**
     * Tạo và trả về một EntityManager mới.
     * Cần đóng (close) EntityManager sau khi hoàn thành phiên làm việc với Database để giải phóng tài nguyên.
     *
     * @return EntityManager đối tượng dùng để thực hiện các thao tác CRUD.
     */
    public static EntityManager getEntityManager() {
        return factory.createEntityManager();
    }

    /**
     * Giải phóng tài nguyên của EntityManagerFactory khi đóng ứng dụng.
     */
    public static void shutdown() {
        if (factory != null && factory.isOpen()) {
            factory.close();
        }
    }
}
