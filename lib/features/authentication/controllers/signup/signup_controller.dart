import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../network_manager.dart';
import '../../../transition_screens/account_created_screen.dart';
import '../../screens/signup/verify_email.dart';

class SignupController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final pageController = PageController();
  var currentStep = 0.obs;
  RxString profileImagePath = ''.obs;
  static SignupController get instance => Get.find();

  // Observables and Controllers for form data
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final firstName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  final identityFront = Rx<File?>(null);
  final identityBack = Rx<File?>(null);
  final personalPhoto = Rx<File?>(null);

  // Toggle password visibility
  void togglePasswordVisibility() => hidePassword.value = !hidePassword.value;

  void nextStep() {
    if (currentStep.value == 2) {
      Get.to(AccountCreatedScreen());
    } else {
      currentStep.value++;
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  // Image Picker
  Future<void> pickImage(Rx<File?> targetFile) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      targetFile.value = File(pickedFile.path);
    }
  }

  // Sign Up Function
  Future<void> signup() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Processing your information...', MyImages.loadingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        FullScreenLoader.stopLoading();
        Loaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'You must accept the Privacy Policy & Terms of Use to continue.',
        );
        return;
      }

      // Successfully move to next screen
      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(
          title: 'Congratulations', message: 'Account created successfully!');
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  // Méthode pour sélectionner l'image de profil
  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImagePath.value = image.path;
    }
  }
}
