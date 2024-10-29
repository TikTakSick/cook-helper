import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// providers
import 'providers/my_app_router_provider.dart';
import 'providers/shared_recipe_url_provider.dart';

// firebase settings
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ShareExtension settings
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

// MyApp
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  String? sharedRecipeUrl;

  // private methods

  bool _isValuePresent({required SharedFile? sharedFile}) {
    return sharedFile?.value != null;
  }

  String? _findUrlInValueOfSharedFile({required SharedFile? sharedFile}) {
    final String? value = sharedFile!.value;
    final RegExp urlRegex = RegExp(r"(https?://[^\s]+)");
    final match = urlRegex.firstMatch(value!);
    return match?.group(0) ?? '';
  }

  // set sharedWebRecipeUrl if an element of sharedFileList is a URL
  void _setSharedWebRecipeUrl({required List<SharedFile>? sharedFileList}) {
    setState(() {
      if (sharedFileList == null || sharedFileList.isEmpty) {
        return;
      } else if (_isValuePresent(sharedFile: sharedFileList.last)) {
        final sharedFile = sharedFileList.last;
        sharedRecipeUrl = _findUrlInValueOfSharedFile(sharedFile: sharedFile);
        debugPrint("setSharedWebRecipeUrl $sharedRecipeUrl");
        // update sharedRecipeUrlProvider
        ref.read(sharedRecipeUrlProvider.notifier).set(value: sharedRecipeUrl!);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // For sharing data coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile>? sharedFileList) {
      debugPrint("getIntentDataStream: $sharedFileList");
      _setSharedWebRecipeUrl(sharedFileList: sharedFileList);
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // For sharing data coming from outside the app while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then(
        (List<SharedFile>? sharedFileList) {
      _setSharedWebRecipeUrl(sharedFileList: sharedFileList);
    }, onError: (err) {
      debugPrint("getInitialSharing error: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    final myAppRouter = ref.watch(myAppRouterProvider);
    final sharedRecipeUrlFromNotifier = ref.watch(sharedRecipeUrlProvider);
    debugPrint("sharedRecipeUrl from this widget state: $sharedRecipeUrl");
    debugPrint(
        "sharedRecipeUrl from NotifierProvider: $sharedRecipeUrlFromNotifier");
    return MaterialApp.router(
      title: 'Cook Helper',
      routerConfig: myAppRouter,
    );
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}
