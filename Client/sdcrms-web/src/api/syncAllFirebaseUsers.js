import axiosClient from "./axiosClient";

// Lấy toàn bộ user từ Firebase và đồng bộ vào DB
export const syncAllFirebaseUsers = async () => {
  // 1. Lấy danh sách user từ Firebase
  const firebaseUsers = await axiosClient.get("/firebase-users");

  // 2. Gửi từng user lên /api/users/sync
  for (const fbUser of firebaseUsers.data) {
    const userSyncDto = {
      firebaseUid: fbUser.uid,
      username: fbUser.email || fbUser.uid,
      role: fbUser.customClaims?.role || "User",
      phoneNumber: fbUser.phoneNumber || "",
      lastName: "", // hoặc tách từ displayName nếu muốn
      firstName: "",
      email: fbUser.email || "",
      sex: "",
      birthday: null,
      address: "",
    };
    try {
      await axiosClient.post("/users/sync", userSyncDto);
      console.log(`Đã sync user: ${userSyncDto.email}`);
    } catch (err) {
      console.error(`Lỗi sync user: ${userSyncDto.email}`, err.message);
    }
  }
};

export default syncAllFirebaseUsers;
