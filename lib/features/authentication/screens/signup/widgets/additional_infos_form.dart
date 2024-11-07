import 'package:fitnest/features/authentication/screens/signup/widgets/date_of_birth_gender.dart';
import 'package:fitnest/features/authentication/screens/signup/widgets/interests.dart';
import 'package:fitnest/features/authentication/screens/signup/widgets/looking_for_form.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/constants/sizes.dart';

class AdditionalInfosForm extends StatefulWidget {
  @override
  _AdditionalInfosFormState createState() => _AdditionalInfosFormState();
}

class _AdditionalInfosFormState extends State<AdditionalInfosForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySizes.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Date of Birth and Gender
          DateOfBirthGenderForm(),
          const SizedBox(height: MySizes.spaceBtwItems),
          // Section 2: Interests
          InterestsForm(),
          const SizedBox(height: MySizes.spaceBtwItems),
          // Section 3: Goals
          LookingForForm(),
        ],
      ),
    );
  }
}
