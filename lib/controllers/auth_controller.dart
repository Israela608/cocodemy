import 'package:cocodemy/firebase_ref/references.dart';
import 'package:cocodemy/screens/home/home_screen.dart';
import 'package:cocodemy/screens/login/login_screen.dart';
import 'package:cocodemy/utils/app_logger.dart';
import 'package:cocodemy/widgets/dialogs/dialog_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  //onReady is a GetxController method that is called initially when the app is run
  @override
  void onReady() {
    initAuth();
    super.onReady();
  }

  late FirebaseAuth _auth;

  final _user = Rxn<User>();

  //The Stream will tell us whether the user is connected (Logged in) or not connected with the app
  late Stream<User?> _authStateChanges;

  void initAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    _auth = FirebaseAuth.instance;
    //Check whether the user is logged in or not and listen for changes
    _authStateChanges = _auth.authStateChanges();
    _authStateChanges.listen((User? user) {
      _user.value = user;
    });
    navigateToIntroduction();
  }

  signInWithGoogle() async {
    // GoogleSignIn method is used to get sign in information from google
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      //Sign out any previous account. This will bring out the options to choose which google account you want to sign into
      await _googleSignIn.signOut();
      //We try to sign in. If we can, then we get the account information and assign it to the 'account' variable
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        //We get the authentication object
        final _authAccount = await account.authentication;
        //We save the id and access token from the authentication object in this 'credential' variable
        final _credential = GoogleAuthProvider.credential(
          idToken: _authAccount.idToken,
          accessToken: _authAccount.accessToken,
        );

        await _auth.signInWithCredential(_credential);
        await saveUser(account);
        navigateToHomePage();
      }
    } on Exception catch (error) {
      AppLogger.e(error);
    }
  }

  //Get the current user
  User? getUser() {
    //Whatever we get from firebase as the current user, we assign it to our 'user' value
    _user.value = _auth.currentUser;
    return _user.value;
  }

  //Save the user's profile info to firebase
  saveUser(GoogleSignInAccount account) {
    userRF.doc(account.email).set({
      'email': account.email,
      'name': account.displayName,
      'profilepic': account.photoUrl
    });
  }

  //Move to introduction screen
  void navigateToIntroduction() {
    Get.offAllNamed('/introduction');
  }

  //Dialog that requests the user to log in
  void showLoginAlertDialog() {
    Get.dialog(
      Dialogs.questionStartDialog(
        onTap: () {
          Get.back();
          navigateToLoginPage();
        },
      ),
      barrierDismissible: false,
    );
  }

  void navigateToLoginPage() {
    Get.toNamed(LoginScreen.routeName);
  }

  //Check if the user is logged in or not
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  Future<void> signOut() async {
    AppLogger.d('Sign out');
    try {
      print('LOGOUT 3');
      //Call the firebase method for signing out the current user
      await _auth.signOut();
      navigateToHomePage();
    } on FirebaseAuthException catch (e) {
      AppLogger.e(e);
    }
  }

  void navigateToHomePage() {
    Get.offAllNamed(HomeScreen.routeName);
  }
}
