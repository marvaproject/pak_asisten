// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterPopup extends StatefulWidget {
  final List<String> selectedFilters;
  final Function(List<String>) onFiltersChanged;

  FilterPopup({required this.selectedFilters, required this.onFiltersChanged});

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  List<String> _selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _selectedFilters = List.from(widget.selectedFilters);
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
    widget.onFiltersChanged(_selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double popupWidth = screenSize.width * 0.7;
    final double popupHeight = screenSize.height * 0.6;

    return Container(
      width: popupWidth,
      height: popupHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 1)
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 6),
            child: Text('Filter',
                style: GoogleFonts.lato(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: filterCategories
                      .map((category) => _buildCategorySection(category))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(FilterCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.name,
            style: GoogleFonts.lato(
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: category.options
              .map(
                (option) => FilterChip(
                  label: Text(option),
                  selected: _selectedFilters.contains(option),
                  onSelected: (_) => _toggleFilter(option),
                  padding: EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                  checkmarkColor: Color(0xFF01796f),
                  side: BorderSide(width: 0.6),
                  labelPadding: EdgeInsets.symmetric(horizontal: 5),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class FilterCategory {
  final String name;
  final List<String> options;

  FilterCategory(this.name, this.options);
}

final List<FilterCategory> filterCategories = [
  FilterCategory('Dimensionality',
      ['2d', '3d', '2.5d', 'isometric', 'flat design', 'faux 3d']),
  FilterCategory('Art Styles', [
    'abstract',
    'anime',
    'art deco',
    'art nouveau',
    'cartoon',
    'comic',
    'cyberpunk',
    'gothic',
    'graffiti',
    'industrial',
    'kawaii',
    'line art',
    'manga',
    'minimalist',
    'modern',
    'pixel art',
    'pop art',
    'realistic',
    'vintage'
  ]),
  FilterCategory('Aesthetics', [
    'cyberpunk',
    'dreamlike',
    'fantasy',
    'futuristic',
    'grunge',
    'horror',
    'noir',
    'nft',
    'psychedelic',
    'retro',
    'romantic',
    'steampunk',
    'surreal'
  ]),
  FilterCategory('Rendering', [
    'realistic',
    'stylized',
    'sketch',
    'painting',
    'illustration',
    'photorealistic',
    'low poly',
    'high poly',
    'pixel art',
    'voxel'
  ]),
  FilterCategory('Lighting', [
    'soft lighting',
    'hard lighting',
    'ambient lighting',
    'natural lighting',
    'studio lighting',
    'neon lighting',
    'dramatic lighting',
    'chiaroscuro',
    'rim lighting',
    'backlighting'
  ]),
  FilterCategory('Color', [
    'colorful',
    'monochrome',
    'black and white',
    'sepia',
    'neon',
    'pastel',
    'vibrant',
    'muted'
  ]),
  FilterCategory('Mood', [
    'cheerful',
    'dark',
    'dramatic',
    'gloomy',
    'happy',
    'melancholy',
    'mysterious',
    'peaceful',
    'romantic',
    'sad',
  ]),
  FilterCategory('Themes', [
    'abstract',
    'architecture',
    'avatars',
    'cityscape',
    'crypto art',
    'fashion',
    'food',
    'landscape',
    'nature',
    'portrait',
    'still life',
    'technology',
  ]),
  FilterCategory('Specific Mediums', [
    'photography',
    'oil painting',
    'watercolor',
    'charcoal drawing',
    'digital art',
    '3d render',
    'pixel art',
    'vector art',
    'collage'
  ]),
  FilterCategory('Background', [
    'white background',
    'black background',
    'transparent background',
    'gradient background',
    'blurred background',
    'abstract background',
    'bokeh background'
  ]),
  FilterCategory(
      'Resolution', ['high detailed', '1080p', 'hd', 'fhd', '2k', '4k']),
];
