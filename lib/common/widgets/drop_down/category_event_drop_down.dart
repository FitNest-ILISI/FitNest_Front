import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/events/controllers/category_provider.dart';
import '../../../features/events/models/category.dart';


class CategoryDropdown extends StatelessWidget {
  final Function(Category) onCategorySelected;

  CategoryDropdown({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return DropdownButton<Category>(
          hint: Text('Select a category'),
          items: provider.categories.map((Category category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Row(
                children: [
                  if (category.iconPath != null)
                    Image.asset(
                      category.iconPath,
                      width: 20,
                      height: 20,
                    ),
                  SizedBox(width: 8),
                  Text(category.name),
                ],
              ),
            );
          }).toList(),
          onChanged: (Category? selectedCategory) {
            if (selectedCategory != null) {
              onCategorySelected(selectedCategory);
            }
          },
        );
      },
    );
  }
}
