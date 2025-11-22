package com.notificationservice.service;

import com.google.firebase.messaging.*;
import com.notificationservice.model.UserToken;
import com.notificationservice.repository.UserTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
public class NotificationService {

    @Autowired
    private UserTokenRepository userTokenRepository;


    /**
     * Lưu token — mỗi user có thể có nhiều token
     */
    public UserToken saveToken(String firebaseUid, String fcmToken) {

        if (firebaseUid == null || fcmToken == null || fcmToken.isBlank()) {
            throw new RuntimeException("firebaseUid hoặc fcmToken null");
        }

        // Nếu token đã tồn tại → cập nhật firebaseUid + updatedAt
        UserToken token = userTokenRepository.findByFcmToken(fcmToken)
                .orElseGet(UserToken::new);

        token.setFirebaseUid(firebaseUid);
        token.setFcmToken(fcmToken);
        token.setUpdatedAt(LocalDateTime.now());

        return userTokenRepository.save(token);
    }


    /**
     * Gửi notification tới tất cả thiết bị của user
     */
    public void sendNotificationToFirebaseUid(
            String firebaseUid,
            String title,
            String body,
            Map<String, String> data
    ) {

        List<UserToken> tokens = userTokenRepository.findAllByFirebaseUid(firebaseUid);

        if (tokens.isEmpty()) {
            throw new RuntimeException("Không tìm thấy FCM token của user: " + firebaseUid);
        }

        for (UserToken token : tokens) {

            Message.Builder builder = Message.builder()
                    .setToken(token.getFcmToken());

            // Notification popup
            if (title != null || body != null) {
                builder.setNotification(
                        Notification.builder()
                                .setTitle(title)
                                .setBody(body)
                                .build()
                );
            }

            // Data
            if (data != null && !data.isEmpty()) {
                builder.putAllData(data);
            }

            try {
                FirebaseMessaging.getInstance().send(builder.build());
            }
            catch (FirebaseMessagingException e) {

                String error = String.valueOf(e.getErrorCode());

                // Token chết → xóa
                if ("registration-token-not-registered".equals(error) ||
                        "invalid-argument".equals(error)) {

                    userTokenRepository.delete(token);
                }
                else {
                    throw new RuntimeException("Lỗi gửi FCM: " + error, e);
                }
            }
        }
    }
}
