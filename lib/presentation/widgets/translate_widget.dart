import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';
import 'package:translator/translator.dart';

class TranslateWidget extends StatefulWidget {
  const TranslateWidget({super.key});

  @override
  State<TranslateWidget> createState() => _TranslateWidgetState();
}

class _TranslateWidgetState extends State<TranslateWidget> {
  final ValueNotifier<bool> _hasSourceText = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasTranslatedText = ValueNotifier<bool>(false);
  final TextEditingController _sourceTextController = TextEditingController();
  final TextEditingController _translatedTextController =
      TextEditingController();

  String _selectedLanguage1 = 'Bahasa Indonesia';
  String _selectedLanguage2 = 'English';

  final translator = GoogleTranslator();

  final Map<String, String> _languageCodes = {
    'Bahasa Indonesia': 'id',
    'English': 'en',
    'Arabic': 'ar',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Chinese': 'zh-cn',
    'Russian': 'ru',
    'Turkish': 'tr',
    'Malay': 'ms',
    'Thai': 'th',
    'Javanese': 'jv',
    'Sundanese': 'su',
  };

  final List<String> _languages = [
    'Bahasa Indonesia',
    'English',
    'Arabic',
    'Japanese',
    'Korean',
    'Chinese',
    'Russian',
    'Turkish',
    'Malay',
    'Thai',
    'Javanese',
    'Sundanese',
  ];

  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    _sourceTextController.addListener(_onSourceTextChanged);
  }

  @override
  void dispose() {
    _sourceTextController.removeListener(_onSourceTextChanged);
    _sourceTextController.dispose();
    _translatedTextController.dispose();
    super.dispose();
  }

  void _onSourceTextChanged() {
    _hasSourceText.value = _sourceTextController.text.isNotEmpty;
    _translateText();
  }

  void _swapLanguages() {
    setState(() {
      final tempLang = _selectedLanguage1;
      _selectedLanguage1 = _selectedLanguage2;
      _selectedLanguage2 = tempLang;

      final tempText = _sourceTextController.text;
      _sourceTextController.text = _translatedTextController.text;
      _translatedTextController.text = tempText;

      _hasSourceText.value = _sourceTextController.text.isNotEmpty;
      _hasTranslatedText.value = _translatedTextController.text.isNotEmpty;
    });
  }

  void _updateLanguageSelection(bool isFirstLanguage, String newValue) {
    setState(() {
      if (isFirstLanguage) {
        if (newValue == _selectedLanguage2) {
          // Jika bahasa yang dipilih sama dengan bahasa kedua, tukar bahasanya
          _selectedLanguage2 = _selectedLanguage1;
        }
        _selectedLanguage1 = newValue;

        // Jika bahasa pertama adalah Bahasa Indonesia, set bahasa kedua ke English
        if (newValue == 'Bahasa Indonesia' && _selectedLanguage2 != 'English') {
          _selectedLanguage2 = 'English';
        }
      } else {
        if (newValue == _selectedLanguage1) {
          // Jika bahasa yang dipilih sama dengan bahasa pertama, tukar bahasanya
          _selectedLanguage1 = _selectedLanguage2;
        }
        _selectedLanguage2 = newValue;
      }
      _translateText();
    });
  }

  Future<void> _translateText() async {
    if (_isTranslating || _sourceTextController.text.isEmpty) return;

    setState(() => _isTranslating = true);

    final from = _languageCodes[_selectedLanguage1] ?? 'auto';
    final to = _languageCodes[_selectedLanguage2] ?? 'en';

    try {
      final translation = await translator.translate(
        _sourceTextController.text,
        from: from,
        to: to,
      );
      setState(() {
        _translatedTextController.text = translation.text;
        _hasTranslatedText.value = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Translation error: $e');
      }
      _showErrorSnackBar('Translation failed. Please try again.');
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  Widget _buildConstrainedDropdown(String value, Function(String?) onChanged) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0xFF274688), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Color(0x4C274688),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF274688)),
            style: GoogleFonts.lato(
              fontSize: 15,
              color: Color(0xFF274688),
              fontWeight: FontWeight.bold,
            ),
            borderRadius: BorderRadius.circular(25),
            dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
            menuMaxHeight: MediaQuery.of(context).size.height * 0.6,
            itemHeight: 50,
            items: _languages.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  constraints: BoxConstraints(minWidth: 120),
                  child: Text(
                    value,
                    style: GoogleFonts.lato(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required ValueNotifier<bool> hasText,
    required VoidCallback onCopy,
    bool readOnly = false,
    VoidCallback? onClear,
  }) {
    return TextField(
      controller: controller,
      maxLines: 5,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 14),
        contentPadding: EdgeInsets.all(20),
        filled: true,
        fillColor: Theme.of(context).colorScheme.inverseSurface,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context)
                  .inputDecorationTheme
                  .border!
                  .borderSide
                  .color,
              width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context)
                  .inputDecorationTheme
                  .border!
                  .borderSide
                  .color,
              width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        suffixIcon: ValueListenableBuilder<bool>(
          valueListenable: hasText,
          builder: (context, hasText, child) {
            return hasText
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          CustomIcon.clipboard,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        onPressed: onCopy,
                      ),
                      if (onClear != null)
                        IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 20,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          onPressed: onClear,
                        ),
                    ],
                  )
                : SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _clearSourceText() {
    setState(() {
      _sourceTextController.clear();
      _translatedTextController.clear();
      _hasSourceText.value = false;
      _hasTranslatedText.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Translate', style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildConstrainedDropdown(
                _selectedLanguage1,
                (String? newValue) => _updateLanguageSelection(true, newValue!),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              flex: 0,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: IconButton(
                    onPressed: _swapLanguages,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    style: ButtonStyle(
                      alignment: Alignment.center,
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      fixedSize: WidgetStateProperty.all(Size(40, 40)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).primaryIconTheme.color),
                      iconColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.tertiary),
                    ),
                    icon: Icon(
                      Icons.swap_horiz_rounded,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: _buildConstrainedDropdown(
                _selectedLanguage2,
                (String? newValue) =>
                    _updateLanguageSelection(false, newValue!),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        _buildTextField(
          controller: _sourceTextController,
          hintText: "Enter text to translate...",
          hasText: _hasSourceText,
          onCopy: () => _copyToClipboard(_sourceTextController),
          onClear: _clearSourceText,
        ),
        SizedBox(height: 15),
        _buildTextField(
          controller: _translatedTextController,
          hintText: "Translation result...",
          hasText: _hasTranslatedText,
          onCopy: () => _copyToClipboard(_translatedTextController),
          readOnly: true,
        ),
      ],
    );
  }

  void _copyToClipboard(TextEditingController controller) {
    if (controller.text.isEmpty) return;

    Clipboard.setData(ClipboardData(text: controller.text));
    _showSuccessSnackBar('Copied to clipboard');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        duration: Duration(seconds: 1),
      ),
    );
  }
}
