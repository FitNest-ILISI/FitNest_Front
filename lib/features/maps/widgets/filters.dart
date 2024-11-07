import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/widgets/buttons/filter_button.dart';
import '../../../../common/widgets/buttons/icon_button.dart';
import '../../../../utils/constants/colors.dart';
import '../../events/controllers/category_provider.dart';
import '../../events/models/category.dart';

// Le modèle de filtre
class EventFilters {
  final String? date;
  final String? time;
  final String? distance;
  final String? category;

  EventFilters({this.date, this.time, this.distance, this.category});
}

class Filters extends StatefulWidget {
  final ValueChanged<String?> onCategorySelected;
  final ValueChanged<EventFilters> onFiltersApplied;

  const Filters({
    super.key,
    required this.onCategorySelected,
    required this.onFiltersApplied,
  });

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  String? _selectedDate = 'Any day';
  String? _selectedTime = 'Any Time';
  String? _selectedDistance = 'Any Distance';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8), // Adjusted padding for spacing
        children: [
          IconButtonW(
            iconColor: MyColors.darkerGrey,
            icon: Icons.filter_list,
            onPressed: () {
              _showFilterSheet(context); // Affiche tous les filtres
            },
          ),
          SizedBox(width: 10), // Added spacing between buttons
          FilterButton(
            icon: Icons.calendar_today,
            label: 'By Date',
            onPressed: () {
              _showDateFilter(context);
            },
          ),
          SizedBox(width: 10), // Added spacing between buttons
          FilterButton(
            icon: Icons.access_time,
            label: 'Time of Day',
            onPressed: () {
              _showTimeFilter(context);
            },
          ),
          SizedBox(width: 10), // Added spacing between buttons
          FilterButton(
            icon: Icons.location_on,
            label: 'By Distance',
            onPressed: () {
              _showDistanceFilter(context);
            },
          ),
          SizedBox(width: 10), // Added spacing between buttons
          FilterButton(
            icon: Icons.category,
            label: 'By Category',
            onPressed: () {
              _showCategoryFilter(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRadioSection({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...options.map((option) {
          return ListTile(
            title: Text(option),
            leading: Radio<String>(
              value: option,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
          );
        }).toList(),
        SizedBox(height: 20),
      ],
    );
  }

  // Fonction de filtre de distance
  Widget _buildDistanceSection() {
    return _buildRadioSection(
      title: 'By Distance',
      options: ['Any Distance', '1km', '2km', '5km', '10km', '20km'],
      selectedValue: _selectedDistance,
      onChanged: (value) {
        setState(() {
          _selectedDistance = value;
        });
        widget.onFiltersApplied(
          EventFilters(
            date: _selectedDate,
            time: _selectedTime,
            distance: _selectedDistance,
            category: _selectedCategory,
          ),
        );
      },
    );
  }

  // Fonction de filtre de date
  Widget _buildDateSection() {
    return _buildRadioSection(
      title: 'By Date',
      options: ['Any day','Today', 'Tomorrow', 'This Week', 'After This Week'],
      selectedValue: _selectedDate,
      onChanged: (value) {
        setState(() {
          _selectedDate = value;
        });
        widget.onFiltersApplied(
          EventFilters(
            date: _selectedDate,
            time: _selectedTime,
            distance: _selectedDistance,
            category: _selectedCategory,
          ),
        );
      },
    );
  }

  // Fonction de filtre de moment de la journée
  Widget _buildTimeSection() {
    return _buildRadioSection(
      title: 'Time of Day',
      options: ['Any Time of the Day', 'Morning', 'Afternoon', 'Evening', 'Night'],
      selectedValue: _selectedTime,
      onChanged: (value) {
        setState(() {
          _selectedTime = value;
        });
        widget.onFiltersApplied(
          EventFilters(
            date: _selectedDate,
            time: _selectedTime,
            distance: _selectedDistance,
            category: _selectedCategory,
          ),
        );
      },
    );
  }

  // Affiche tous les filtres dans une feuille modale
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                controller: scrollController,
                children: [
                  _buildDateSection(),
                  _buildTimeSection(),
                  _buildDistanceSection(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onFiltersApplied(
                        EventFilters(
                          date: _selectedDate,
                          time: _selectedTime,
                          distance: _selectedDistance,
                          category: _selectedCategory,
                        ),
                      );
                    },
                    child: Text('Apply'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Affiche uniquement le filtre de date
  void _showDateFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildDateSection(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Affiche uniquement le filtre de moment de la journée
  void _showTimeFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildTimeSection(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Affiche uniquement le filtre de distance
  void _showDistanceFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildDistanceSection(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Affiche uniquement le filtre de catégorie
  void _showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildCategorySection(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Wrap(
          spacing: 16.0, // Espace horizontal entre les chips
          runSpacing: 8.0, // Espace vertical entre les lignes de chips
          children: categoryProvider.categories.map<Widget>((Category category) {
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    category.iconPath,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 8), // Espace entre l'icône et le texte
                  Text(category.name),
                ],
              ),
              selected: _selectedCategory == category.name,
              onSelected: (bool selected) {
                setState(() {
                  _selectedCategory = selected ? category.name : null;
                });
                widget.onCategorySelected(_selectedCategory);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
