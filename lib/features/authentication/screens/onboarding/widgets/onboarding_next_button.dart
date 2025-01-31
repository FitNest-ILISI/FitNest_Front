import 'package:flutter/material.dart';
import 'package:fitnest/utils/constants/colors.dart';
import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Positioned(
      right: MySizes.defaultSpace,
      bottom: MyDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: dark ? MyColors.softGrey : Colors.blue),
        child: Icon(Iconsax.arrow_right_3,
            color: dark ? Colors.blue : MyColors.softGrey),
      ),
    );
  }
}
