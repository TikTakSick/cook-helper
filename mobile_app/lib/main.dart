import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';

// views
import 'views/pages/my_page.dart';
import 'views/pages/login_page.dart';

// providers
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

// MyApp
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  String? sharedWebRecipeUrl;

  bool _isUrlSharedMediaType({required SharedFile? sharedFile}) {
    return sharedFile?.type == SharedMediaType.URL;
  }

  bool _isUrlValuePresent({required SharedFile? sharedFile}) {
    return sharedFile?.value != null;
  }

  bool _isUrlValid({required SharedFile? sharedFile}) {
    return _isUrlSharedMediaType(sharedFile: sharedFile) &&
        _isUrlValuePresent(sharedFile: sharedFile);
  }

  void _setSharedWebRecipeUrl({required List<SharedFile> sharedFileList}) {
    setState(() {
      if (_isUrlValid(sharedFile: sharedFileList[0])) {
        sharedWebRecipeUrl = sharedFileList[0].value;
        debugPrint("Shared: setSharedWebRecipeUrl $sharedWebRecipeUrl");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // For sharing data coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> sharedFileList) {
      // set sharedWebRecipeUrl if an element of sharedFileList is a URL
      _setSharedWebRecipeUrl(sharedFileList: sharedFileList);
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // For sharing data coming from outside the app while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then(
        (List<SharedFile> sharedFileList) {
      // set sharedWebRecipeUrl if an element of sharedFileList is a URL
      _setSharedWebRecipeUrl(sharedFileList: sharedFileList);
    }, onError: (err) {
      debugPrint("getInitialSharing error: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(
        sharedWebRecipeUrl: sharedWebRecipeUrl,
      ),
    );
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }
}

// Home
class Home extends ConsumerWidget {
  final String? sharedWebRecipeUrl;

  const Home({
    super.key,
    this.sharedWebRecipeUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 認証状態に応じて画面遷移する．
    final authState = ref.watch(authUserChangesProvider);
    return authState.when(
      data: (user) => (user != null && user.emailVerified)
          ? MyPage(sharedWebRecipeUrl: sharedWebRecipeUrl)
          : const LoginPage(),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text("Error: $err"),
    );
  }
}
