import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

import '../../../core/constants/legal_constants.dart';

class LegalViewerScreen extends StatelessWidget {
  final LegalType type;

  const LegalViewerScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Markdown(
        data: type.content,
        styleSheet: MarkdownStyleSheet(
          h1: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
          h2: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
          p: GoogleFonts.outfit(fontSize: 16, height: 1.5, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87),
          strong: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

