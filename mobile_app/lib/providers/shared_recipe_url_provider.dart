import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedRecipeUrlProvider =
    NotifierProvider<SharedRecipeUrlNotifier, String?>(
  () => SharedRecipeUrlNotifier(),
);

class SharedRecipeUrlNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set({required String value}) {
    state = value;
  }

  void clear() {
    state = null;
  }
}
