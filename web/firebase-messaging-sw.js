importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: "AIzaSyCiQz5WJD8--ZU20mEseVFiZvE6Cv-qZIY",
  authDomain: "yogya-app.firebaseapp.com",
  projectId: "yogya-app",
  storageBucket: "yogya-app.firebasestorage.app",
  messagingSenderId: "858823327301",
  appId: "1:858823327301:web:26b91f3e66164cb9022d2c",
  measurementId: "G-VGRFC80KGH"
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
});
