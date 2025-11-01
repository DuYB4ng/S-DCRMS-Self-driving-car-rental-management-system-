// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth"
// import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBvz7YPG7ER4kf4Wj7T9GQVOqzMVIA8S8o",
  authDomain: "sdcrms-49dfb.firebaseapp.com",
  projectId: "sdcrms-49dfb",
  storageBucket: "sdcrms-49dfb.firebasestorage.app",
  messagingSenderId: "491044052539",
  appId: "1:491044052539:web:01224e03dda4164b3b861e",
  measurementId: "G-GQ1X82DRGP"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
// const analytics = getAnalytics(app);

// Khởi tạo module xác thực
export const auth = getAuth(app);