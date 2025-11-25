const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

async function setRole(email, role) {
  try {
    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().setCustomUserClaims(user.uid, { role });
    console.log(`✅ Đã gán quyền "${role}" cho user: ${email}`);
  } catch (error) {
    console.error("❌ Lỗi khi gán role:", error.message);
  }
}

setRole("triuu1212@gmail.com", "Admin");