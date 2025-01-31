import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';
import 'terms_conditions_checkbox.dart';

class SignupForm extends StatelessWidget {
  SignupForm({
    super.key,
  });
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: controller
                .pickProfileImage, // Méthode pour sélectionner l'image
            child: Obx(() {
              return CircleAvatar(
                radius: 70,
                backgroundImage: controller.profileImagePath.value.isNotEmpty
                    ? FileImage(File(controller.profileImagePath.value))
                    : null, // Si aucune image n'est sélectionnée, ne pas définir l'image de fond
                backgroundColor: dark ? MyColors.white : MyColors.black,
                child: controller.profileImagePath.value.isEmpty
                    ? Icon(
                        Iconsax.user, // Icône de profil au lieu de caméra
                        color: dark ? MyColors.black : MyColors.white,
                        size: MySizes.iconxXLg,
                      )
                    : null, // Pas d'icône si l'image est sélectionnée
              );
            }),
          ),
        ),
        const SizedBox(
          height: MySizes.spaceBtwSections,
        ),
        Row(
          children: [
            // Champ de First Name
            Expanded(
              child: TextFormField(
                validator: (value) =>
                    MyValidator.validateEmptyText('First Name', value),
                expands: false,
                decoration: const InputDecoration(
                  labelText: MyTexts.firstName,
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
            ),
            const SizedBox(width: MySizes.spaceBtwInputFields),
            // Champ de Last Name
            Expanded(
              child: TextFormField(
                validator: (value) =>
                    MyValidator.validateEmptyText('Last Name', value),
                expands: false,
                decoration: const InputDecoration(
                  labelText: MyTexts.lastName,
                  prefixIcon: Icon(Iconsax.user),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: MySizes.spaceBtwInputFields,
        ),
        // Champ de User Name
        TextFormField(
          validator: (value) =>
              MyValidator.validateEmptyText('User Name', value),
          expands: false,
          decoration: const InputDecoration(
            labelText: MyTexts.username,
            prefixIcon: Icon(Iconsax.user_edit),
          ),
        ),
        const SizedBox(
          height: MySizes.spaceBtwInputFields,
        ),
        // Champ de E-mail
        TextFormField(
          validator: (value) => MyValidator.validateEmail(value),
          expands: false,
          decoration: const InputDecoration(
            labelText: MyTexts.email,
            prefixIcon: Icon(Iconsax.direct),
          ),
        ),
        const SizedBox(
          height: MySizes.spaceBtwInputFields,
        ),
        // Champ de Phone Number
        TextFormField(
          validator: (value) => MyValidator.validatePhoneNumber(value),
          expands: false,
          decoration: const InputDecoration(
            labelText: MyTexts.phoneNo,
            prefixIcon: Icon(Iconsax.call),
          ),
        ),
        const SizedBox(
          height: MySizes.spaceBtwInputFields,
        ),
        // Champs de Password
        TextFormField(
            validator: (value) => MyValidator.validatePassword(value),
            decoration: const InputDecoration(
              labelText: MyTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye),
            )),
        const SizedBox(
          height: MySizes.spaceBtwInputFields,
        ),
        // Champ de Confirmation de Password
        TextFormField(
            validator: (value) => MyValidator.validatePassword(value),
            decoration: InputDecoration(
              labelText: MyTexts.confirmPassword,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye),
            )),
        const SizedBox(
          height: MySizes.spaceBtwSections,
        ),
        TermsAndConditionsCheckbox(),
      ],
    );
  }
}
