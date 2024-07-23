import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:habitual/src/presentation/authentication_screen/view/sign_in_screen.dart';

import 'package:habitual/src/presentation/home_screen/view/homepage.dart';
import '../../common_widgets/toast.dart';
import 'package:get/state_manager.dart';

class FirebaseAuthService extends GetxController {
  static FirebaseAuthService instance  = Get.find();

  FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> _user;

  getUser() {
    User? user =  _auth.currentUser;
    return user;
  }

  @override
  void onReady(){
    super.onReady();
    _user = Rx<User?>(_auth.currentUser);
    _user.bindStream(_auth.userChanges());

    ever(_user, _initialScreen);
  }

  _initialScreen(User? user){
    print(user);
    if (user == null){
      print("login  page");
      Future.delayed(Duration(seconds: 1), () {
        Get.offAll(() => const SignInScreen());
      });
    }else {
      Future.delayed(Duration(seconds: 1), () {
        Get.offAll(() => HomePage());
      })
     ;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password
      );
      return credential.user;
    } catch (e) {
      print("Some Error Occured");
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found" || e.code == 'wrong-password'){
        showToast(message: "Invalid email or password.", type: "error");
      } else{
        showToast(message: "An error occurred: ${e.code}", type: "error");
      }
    }
  }

  void logOut() async {
    await _auth.signOut();
  }
}