import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../screens/auth_screen.dart';

class AuthController extends GetxController {
  var isLogin = true.obs; // Tracks whether the user is in login or signup mode
  var isLoading = false.obs; // Observable for loading state
  var isRememberMeChecked = false.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
  }

  void toggleRememberMe(bool? value) {
    isRememberMeChecked.value = value ?? false;
  }

  //  Reset Password Function
  Future<String> resetPassword(String email) async {
    try {
      isLoading.value = true;
      // Step 1: Check if user exists in Firestore
      QuerySnapshot userQuery =
          await firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      if (userQuery.docs.isEmpty) {
        isLoading.value = false;
        return "no_user_found_with_this_email".tr;
      }
      await auth.sendPasswordResetEmail(email: email);
      isLoading.value = false;
      return "reset_link_sent_successfully".tr;
    } on FirebaseAuthException catch (e) {
      return handleFirebaseAuthException(e);
    } catch (e) {
      isLoading.value = false;
      return "Error: ${e.toString()}";
    }
  }

  String handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email address is already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-not-found':
        return 'Email not found. Please check the email address or sign up.';
      case 'wrong-password':
        return 'The password entered is incorrect.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many requests have been made to Firebase Authentication in a short period of time';
      case 'network-request-failed':
        return 'A network error occurred, such as being offline.';
      case 'invalid-credential':
        return 'invalid Email Or Password.';
      default:
        return 'Error ${e.code}: ${e.message}';
    }
  }

  // Sign Up User and Save Data to Firestore
  Future<String?> signUpUser(UserModel userData) async {
    try {
      isLoading.value = true;
      // Create User in Firebase Auth
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );

      String userId = user.user!.uid;
      userData.id = userId;

      // Save User Data to Firestore
      await firestore.collection('users').doc(userId).set(userData.toJson());
      auth.signOut();

      return "signup_success".tr;
    } catch (e) {
      return "Error: ${e.toString()}";
    } finally {
      isLoading.value = false; // Set loading to false once done
    }
  }

  // Login User and Fetch Data from Firestore
  Future<String?> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      // Authenticate User
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      // Get User Data from Firestore
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        UserModel loggedInUser = UserModel.fromJson(
          userDoc.data() as Map<String, dynamic>,
        );
        // Store user data if "Remember Me" is checked
        if (isRememberMeChecked.value) {
          await saveUserData(loggedInUser);
        }
      }

      return "login_success".tr;
    } catch (e) {
      return "Error: ${e.toString()}";
    } finally {
      isLoading.value = false; // Set loading to false once done
    }
  }

  // Save user data to SharedPreferences
  Future<void> saveUserData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  // Retrieve user data from SharedPreferences
  Future<UserModel?> getSavedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_data');
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Logout Function - Also clears stored data
  Future<void> logout() async {
    await auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data'); // Remove stored data on logout
    Get.offAll(() => AuthScreen());
  }
}
