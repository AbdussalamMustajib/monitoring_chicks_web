import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_chicks/theme/space_theme.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/model_dht22.dart';
import 'theme/adaptive_text.dart';
import 'theme/text_style_theme.dart';

void main() {
  runApp(SidebarXExampleApp());
}

String urlAPI = "http://localhost";

class SidebarXExampleApp extends StatelessWidget {
  SidebarXExampleApp({Key? key}) : super(key: key);

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SidebarX Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return Scaffold(
            key: _key,
            appBar: isSmallScreen
                ? AppBar(
                    backgroundColor: canvasColor,
                    title: Text(_getTitleByIndex(_controller.selectedIndex)),
                    leading: IconButton(
                      onPressed: () {
                        // if (!Platform.isAndroid && !Platform.isIOS) {
                        //   _controller.setExtended(true);
                        // }
                        _key.currentState?.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  )
                : null,
            drawer: MonitoringChicks(controller: _controller),
            body: Row(
              children: [
                if (!isSmallScreen) MonitoringChicks(controller: _controller),
                Expanded(
                  child: Center(
                    child: Screens(
                      controller: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MonitoringChicks extends StatelessWidget {
  const MonitoringChicks({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  final SidebarXController _controller;

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withOpacity(0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return SizedBox(
          height: width * 0.2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/chicks.png'),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home_rounded,
          label: 'Home',
          onTap: () {
            debugPrint('Home');
          },
        ),
        const SidebarXItem(
          icon: Icons.history_rounded,
          label: 'History',
        ),
        SidebarXItem(
          icon: Icons.camera_alt_rounded,
          label: 'Favorites',
          onTap: () => _launchUrl("http://192.168.173.63/mjpeg/1"),
        ),
      ],
    );
  }

  void _showDisabledAlert(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Item disabled for selecting',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class Screens extends StatefulWidget {
  const Screens({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  _ScreensState createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  ModelDht22? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ModelDht22.fetchData().then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final pageTitle = _getTitleByIndex(widget.controller.selectedIndex);
        switch (widget.controller.selectedIndex) {
          case 0:
            return const MonitoringScreen();
          case 1:
            return data == null
                ? const CircularProgressIndicator()
                : const History();
          default:
            return Text(
              pageTitle,
              style: theme.textTheme.headlineSmall,
            );
        }
      },
    );
  }
}

String _getTitleByIndex(int index) {
  switch (index) {
    case 0:
      return 'Home';
    case 1:
      return 'History';
    case 2:
      return 'Camera';
    default:
      return 'Not found page';
  }
}

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  _MonitoringScreenState createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  ModelDht22? dht22;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 10), (timer) {
      getData();
    });
  }

  getData() {
    ModelDht22.fetchData().then((value) {
      setState(() {
        dht22 = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    SideTitles _bottomTitles() {
      return SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          String date = value.toInt() < dht22!.data!.length
              ? "${DateTime.parse(dht22!.data![value.toInt()].waktu).hour}:${DateTime.parse(dht22!.data![value.toInt()].waktu).minute}"
              : "";
          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Column(
              children: [
                value.toInt() % 2 == 1
                    ? Container(
                        height: height * 0.02,
                      )
                    : SizedBox(),
                Text(
                  date,
                  style: pWhiteTextStyle.copyWith(
                      fontSize: width > height
                          ? const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 10)
                          : const AdaptiveTextSize()
                              .getadaptiveTextSize(context, 12)),
                ),
              ],
            ),
          );
        },
      );
    }

    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: width > height ? width * 0.1 : height * 0.1,
                          width: width * 0.25,
                          color: Colors.red,
                          child: Center(
                            child: Text("Suhu",
                                style: pBoldWhiteTextStyle.copyWith(
                                    fontSize: const AdaptiveTextSize()
                                        .getadaptiveTextSize(context, 24))),
                          ),
                        ),
                        Container(
                          height: width > height ? width * 0.1 : height * 0.1,
                          width: width * 0.25,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          child: Center(
                              child: dht22 == null
                                  ? CircularProgressIndicator()
                                  : Text("${dht22!.data![0].suhu}°C",
                                      style: pWhiteTextStyle.copyWith(
                                          fontSize: const AdaptiveTextSize()
                                              .getadaptiveTextSize(
                                                  context, 16)))),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: width > height ? width * 0.1 : height * 0.1,
                          width: width * 0.25,
                          color: Colors.green,
                          child: Center(
                            child: Text(
                              "Kelembapan",
                              style: pBoldWhiteTextStyle.copyWith(
                                  fontSize: const AdaptiveTextSize()
                                      .getadaptiveTextSize(context, 24)),
                            ),
                          ),
                        ),
                        Container(
                          height: width > height ? width * 0.1 : height * 0.1,
                          width: width * 0.25,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                          ),
                          child: Center(
                            child: dht22 == null
                                ? CircularProgressIndicator()
                                : Text(
                                    "${dht22!.data![0].kelembapan} %",
                                    style: pWhiteTextStyle.copyWith(
                                        fontSize: const AdaptiveTextSize()
                                            .getadaptiveTextSize(context, 16)),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pSpaceMedium(context),
                dht22 == null
                    ? const CircularProgressIndicator()
                    : Container(
                        height: width > height ? width * 0.3 : height * 0.6,
                        width: width > height ? width * 0.7 : width * 1,
                        padding: const EdgeInsets.all(16.0),
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                                show: true,
                                topTitles: AxisTitles(),
                                rightTitles: AxisTitles(),
                                leftTitles: AxisTitles(),
                                bottomTitles:
                                    AxisTitles(sideTitles: _bottomTitles())),
                            borderData: FlBorderData(
                              show: false,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            minX: 0,
                            maxX: 20,
                            minY: 0,
                            maxY: 100,
                            lineBarsData: [
                              LineChartBarData(
                                spots: dht22!.data!
                                    .asMap()
                                    .entries
                                    .map((entry) => FlSpot(entry.key.toDouble(),
                                        double.parse(entry.value.kelembapan!)))
                                    .toList(),
                                isCurved: false,
                                color: Colors.blue,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.blue.withAlpha(100),
                                ),
                              ),
                              LineChartBarData(
                                spots: dht22!.data!
                                    .asMap()
                                    .entries
                                    .map((entry) => FlSpot(entry.key.toDouble(),
                                        double.parse(entry.value.suhu!)))
                                    .toList(),
                                isCurved: false,
                                color: Colors.red,
                                dotData: FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.red.withAlpha(100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  ModelDht22? data;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 10), (timer) {
      getData();
    });
  }

  getData() {
    ModelDht22.fetchAllData().then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? CircularProgressIndicator()
        : SingleChildScrollView(
            child: Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.grey[300],
                        child: Text(
                          'Suhu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.grey[300],
                        child: Text(
                          'Kelembapan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.grey[300],
                        child: Text(
                          'Waktu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                ...data!.data!
                    .map(
                      (item) => TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                item.suhu!,
                                style: pWhiteTextStyle,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                item.kelembapan!,
                                style: pWhiteTextStyle,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                item.waktu!,
                                style: pWhiteTextStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
          );
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
final divider = Divider(color: white.withOpacity(0.3), height: 1);
