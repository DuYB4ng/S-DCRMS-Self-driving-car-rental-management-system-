import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getAnalytics } from "firebase/analytics";
import { getMessaging, isSupported } from "firebase/messaging";

const firebaseConfig = {
  apiKey: "AIzaSyBvz7YPG7ER4kf4Wj7T9GQVOqzMVIA8S8o",
  authDomain: "sdcrms-49dfb.firebaseapp.com",
  projectId: "sdcrms-49dfb",
  storageBucket: "sdcrms-49dfb.appspot.com",
  messagingSenderId: "491044052539",
  appId: "1:491044052539:web:01224e03dda4164b3b861e",
  measurementId: "G-GQ1X82DRGP",
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
