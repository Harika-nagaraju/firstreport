// Firebase Cloud Messaging Service Worker
// Required for background push notifications on Flutter Web

importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyBAzL2ymoj7dIoPLJ3V-XmSjxgtCM75-90",
    authDomain: "first-report-24222.firebaseapp.com",
    projectId: "first-report-24222",
    storageBucket: "first-report-24222.firebasestorage.app",
    messagingSenderId: "918786192277",
    appId: "1:918786192277:web:ce0bdd706b6c5d4acc7c9c",
    measurementId: "G-9E71C1ZLN7"
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: '/icons/Icon-192.png'
    };
    self.registration.showNotification(notificationTitle, notificationOptions);
});
