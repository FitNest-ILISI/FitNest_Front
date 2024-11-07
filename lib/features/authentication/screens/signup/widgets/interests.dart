import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../controllers/signup/interests_controller.dart';

class InterestsForm extends StatelessWidget {
  final InterestsController controller = Get.put(InterestsController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          MyTexts.interests,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: MySizes.spaceBtwItems),
        Obx(
          () => Wrap(
            spacing: MySizes.sm,
            runSpacing: MySizes.xs / 2,
            children: List.generate(controller.interests.length, (index) {
              final interest = controller.interests[index];
              final isSelected = controller.selectedInterests[interest]!;
              return GestureDetector(
                onTap: () => controller.toggleInterest(interest),
                child: Container(
                  padding: const EdgeInsets.all(MySizes.lg / 2),
                  margin: const EdgeInsets.symmetric(vertical: MySizes.xs),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF90CAF9) // Couleur de fond sélectionné
                        : Colors.grey[50], // Couleur de fond non sélectionné
                    border: Border.all(
                      color: isSelected
                          ? MyColors.primaryBackground // Bordure sélectionnée
                          : MyColors.borderPrimary, // Bordure non sélectionnée
                    ),
                    borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.interestIcons[index],
                        color: isSelected
                            ? MyColors.primaryBackground // Icône sélectionnée
                            : MyColors.borderPrimary, // Icône non sélectionnée
                      ),
                      const SizedBox(width: MySizes.xs),
                      Text(
                        interest,
                        style: TextStyle(
                          fontSize: MySizes.fontSizeSm,
                          color: isSelected
                              ? MyColors.primaryBackground // Texte sélectionné
                              : Colors.black54, // Texte non sélectionné
                        ),
                      ),
                      const SizedBox(width: MySizes.xs),
                      Icon(
                        isSelected ? Icons.remove : Icons.add,
                        color: isSelected
                            ? MyColors
                                .primaryBackground // Icône de vérification sélectionnée
                            : MyColors
                                .borderPrimary, // Icône de vérification non sélectionnée
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
