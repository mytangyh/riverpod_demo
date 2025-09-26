// lib/features/demo_md_to_txt/md_to_txt_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

// 1. Provider to hold the raw Markdown input text
final markdownInputProvider = StateProvider<String>((ref) {
  // Default Markdown text to demonstrate the feature
  return '## Hello Riverpod!\n\n' +
      'This is a simple demo of converting **Markdown** to plain text.\n\n' +
      '* List item 1\n' +
      '* List item 2\n\n' +
      '```dart\n' +
      'void main() {\n' +
      '  print("Hello, World!");\n' +
      '}\n' +
      '```';
});

// 2. Provider that converts the Markdown text to plain text
final plainTextProvider = Provider<String>((ref) {
  // Watch the input provider
  final markdownText = ref.watch(markdownInputProvider);
  // Convert Markdown to HTML
  final html = md.markdownToHtml(markdownText);
  // A simple regex to strip HTML tags to get plain text
  final plainText = html.replaceAll(RegExp(r'<[^>]*>'), '');
  return plainText;
});

