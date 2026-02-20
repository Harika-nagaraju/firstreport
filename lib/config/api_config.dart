class ApiConfig {
  // 1. PRODUCTION URL (Render)
  static const String baseUrl = "https://newsapp-backend-mly8.onrender.com";

  // 2. ANDROID EMULATOR (Local)
  // static const String baseUrl = "http://10.0.2.2:5000";

  // 3. REAL DEVICE (Local PC IP)
  // Change this to your computer's IP address (run 'ipconfig' in cmd)
  // static const String baseUrl = "http://192.168.1.47:5000";
  
  // Note: If you see data in Postman but not in the app, ensure:
  // a) You are using the SAME baseUrl in both.
  // b) If using local IP, your phone and PC are on the same WiFi.
  // c) You are logged in within the app (token is required).
}
