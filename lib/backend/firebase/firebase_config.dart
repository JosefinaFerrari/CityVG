import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyALQEI7qqbqMplhUOZy9RQmo4uhF7EOX40",
            authDomain: "cityvg-1f3e7.firebaseapp.com",
            projectId: "cityvg-1f3e7",
            storageBucket: "cityvg-1f3e7.firebasestorage.app",
            messagingSenderId: "591873855467",
            appId: "1:591873855467:web:3119b6f37533558adc13ae",
            measurementId: "G-DRCB3V4F7J"));
  } else {
    await Firebase.initializeApp();
  }
}
