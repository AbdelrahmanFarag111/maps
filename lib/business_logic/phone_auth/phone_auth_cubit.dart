import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verficationId;
  PhoneAuthCubit() : super(PhoneAuthInitial());

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(Loading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 14),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationCompleted');
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException exception) {
    print('verificationFailed ${exception.toString()}');
    emit(ErrorOccurred(errorMsg: exception.toString()));
  }

  void codeSent(String verficationId, int? resendToken) {
    print('codeSent');
    this.verficationId = verficationId;
    emit(PhoneNumberSubmited());
  }

  void codeAutoRetrievalTimeout(String verficationId) {
    print('codeAutoRetrievalTimeout');
  }

  Future<void> submitOTP(String otpcode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verficationId, smsCode: otpcode);
    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerfied());
    } catch (error) {
      emit(ErrorOccurred(errorMsg: error.toString()));
      print(error);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedUser(){
    User firebaseUser= FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }

}
