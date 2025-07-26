// lib/features/demo_counter/counter_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider.autoDispose<int>((ref) => 0);
