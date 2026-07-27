import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_guard/data/constant.dart';
import 'package:air_guard/data/notifiers.dart';
import 'package:air_guard/view/widget_tree.dart';
import 'package:air_guard/data/storage_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool is24hr = await StorageManager.getTimeFormat();
  String language = await StorageManager.getLanguage();
  int refeshRate = await StorageManager.getRefreshRate();
  ThemeMode savedTheme = await StorageManager.getThemeMode();
  bool isGraphAverage = await StorageManager.getGraphAverage();
  themeModeNotifier.value = savedTheme;
  isTimeFormat24hNotifier.value = is24hr;
  selectedLanguageNotifier.value = language;
  selectedRefreashRateNotifier.value = refeshRate;
  isGraphTypeAverageNotifier.value = isGraphAverage;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SensorNotifierMQTT>(
          create: (_) => SensorNotifierMQTT(),
        ),
        ChangeNotifierProvider<SensorNotifier>(
          create: (_) => SensorNotifier(),
        ),
      ],
    child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeModeNotifier,
      builder: (context, mode, child) {
        final currentTheme = mode == ThemeMode.dark ? darkScheme : lightScheme;
        return AnimatedTheme(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOutExpo,
          data: currentTheme,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Air Guard',
            theme: lightScheme,
            darkTheme: darkScheme,
            themeMode: mode,
            home: WidgetTree(),
          ),
        );
      }
    );
  }
}

