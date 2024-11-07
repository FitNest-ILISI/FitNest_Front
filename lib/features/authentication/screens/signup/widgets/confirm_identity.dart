import 'package:fitnest/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/buttons/square_button.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signup/confirm_identity_controller.dart';

class ConfirmIdentityForm extends StatelessWidget {
  final ConfirmIdentityController controller =
      Get.put(ConfirmIdentityController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
      children: [
        Text(
          MyTexts.idProof,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: MySizes.spaceBtwItems),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                return SquareButton(
                  text: 'Front ID',
                  icon: Iconsax.camera,
                  onPressed: controller.pickFrontImage,
                  image: controller.frontImagePath.value.isNotEmpty
                      ? controller.frontImagePath.value
                      : null, // Pass an empty string if no image is selected
                );
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() {
                return SquareButton(
                  text: 'Back ID',
                  icon: Iconsax.camera,
                  onPressed: controller.pickBackImage,
                  image: controller.backImagePath.value.isNotEmpty
                      ? controller.backImagePath.value
                      : null, // Pass an empty string if no image is selected
                );
              }),
            ),
          ],
        ),
        SizedBox(height: MySizes.spaceBtwItems),
      ],
    );
  }
}
