package com.notificationservice.repository;

import com.notificationservice.model.UserToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserTokenRepository extends JpaRepository<UserToken, Long> {

    // Lấy tất cả token của 1 user
    List<UserToken> findAllByFirebaseUid(String firebaseUid);

    // Kiểm tra token có tồn tại chưa
    Optional<UserToken> findByFcmToken(String fcmToken);
}
