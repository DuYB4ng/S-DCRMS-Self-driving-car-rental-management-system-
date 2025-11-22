import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getMessaging } from "firebase/messaging";
import { getAnalytics, isSupported } from "firebase/analytics";

const firebaseConfig = {
  apiKey: "AIzaSyBZ8qElzq9wZbDnfK0wljm3qfTPce53WUw",
  authDomain: "fir-dcrms.firebaseapp.com",
  projectId: "fir-dcrms",
  storageBucket: "fir-dcrms.firebasestorage.app",
  messagingSenderId: "958372819801",
  appId: "1:958372819801:web:708e1f07eefa4a4f595248",
  measurementId: "G-X316WX1DST"
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const messaging = getMessaging(app);

// Analytics chỉ nên khởi tạo nếu chạy trên trình duyệt
let analytics = null;
if (typeof window !== "undefined") {
  isSupported().then((supported) => {
    if (supported) analytics = getAnalytics(app);
  });
}

export { app, auth, messaging, analytics };