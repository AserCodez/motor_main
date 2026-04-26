import 'package:flutter/material.dart';
import 'package:motor_main/widgets/liquid_circular_progress.dart';
import 'package:motor_main/widgets/status_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text('Liquid Circular Progress')),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: LiquidCircularProgress(
                  currentLiters: 950,
                  capacity: 1000,
                ),
              ),
              const SizedBox(height: 32),
              StatusCard(
                title: "PUMP",
                subtitle: "STATUS",
                status: "NO WATER FLOW",
                icon: Icons.waves,
              ),
              const SizedBox(height: 32),
              StatusCard(
                title: "TANK",
                subtitle: "LEVEL",
                status: "LOW",
                icon: Icons.opacity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
