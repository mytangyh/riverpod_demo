// lib/features/demo_md_to_txt/md_to_txt_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'md_to_txt_provider.dart';

class MdToTxtScreen extends ConsumerWidget {
  const MdToTxtScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markdownInput = ref.watch(markdownInputProvider);
    final plainTextOutput = ref.watch(plainTextProvider);
    final textController = TextEditingController(text: markdownInput);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('Markdown to Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Markdown Input Area
            Expanded(
              child: TextField(
                controller: textController,
                onChanged: (value) {
                  ref.read(markdownInputProvider.notifier).state = value;
                },
                maxLines: null, // Allows the text field to expand
                expands: true,
                decoration: const InputDecoration(
                  labelText: 'Enter Markdown',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Converted Text Output Area
            const Text(
              'Converted Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: SingleChildScrollView(
                  child: Text(plainTextOutput),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
