package com.notificationservice.controller;

import com.notificationservice.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/notification")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;


    /**
     * Lưu FCM token — Frontend gọi khi login hoặc khi refresh token
     */
    @PostMapping("/save-token")
    public ResponseEntity<?> saveToken(@RequestBody Map<String, String> request) {

        String firebaseUid = request.get("firebaseUid");
        String fcmToken = request.get("fcmToken");

        if (firebaseUid == null || fcmToken == null) {
            return ResponseEntity.badRequest().body("firebaseUid hoặc fcmToken bị thiếu");
        }

        return ResponseEntity.ok(notificationService.saveToken(firebaseUid, fcmToken));
    }


    /**
     * Gửi notification — backend sử dụng
     */
    @PostMapping("/send")
    public ResponseEntity<?> sendNotification(@RequestBody Map<String, Object> request) {

        try {
            String firebaseUid = (String) request.get("firebaseUid");
            String title = (String) request.get("title");
            String body = (String) request.get("body");

            @SuppressWarnings("unchecked")
            Map<String, String> data = (Map<String, String>) request.get("data");

            if (firebaseUid == null) {
                return ResponseEntity.badRequest().body("firebaseUid bị thiếu");
            }

            notificationService.sendNotificationToFirebaseUid(firebaseUid, title, body, data);

            return ResponseEntity.ok("Notification sent");

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Lỗi gửi thông báo: " + e.getMessage());
        }
    }
}
