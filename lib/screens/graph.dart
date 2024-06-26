import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../objectbox.g.dart';
import 'dart:math';
//import '../main.dart';
import '../memberData.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  Store? store;
  Box<Member>? memberBox;
  List<Member> members = [];

  //initState の中では async/await を使うことができないので、
  //新しくメソッドを用意して、storeとboxを作成する
  Future<void> initialize() async {
    store = await openStore();
    memberBox = store?.box<Member>();
    fetchMembers();
  }

  /// Box から LifeEvent 一覧を取得します
  void fetchMembers() {
    members = memberBox?.getAll() ?? [];
    setState(() {});
  }

  //StatefulWidgetで使用されるウィジェットの初期化時に呼び出されるメソッド
  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    store?.close(); // アプリ終了時にStoreを閉じる
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> memberCounts = {};
    for (var member in members) {
      memberCounts[member.name] =
          (memberCounts[member.name] ?? 0) + member.count;
    }
    List<PieChartSectionData> sections = memberCounts.entries
        .map((entry) => PieChartSectionData(
              title: entry.key,
              value: entry.value.toDouble(),
              color: _getRandomColor(),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'グラフ画面',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: PieChart(
          PieChartData(
            sections: sections,
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            borderData: FlBorderData(show: false),
            //pieTouchData:
            //const PieChartSectionStyle(borderSide: BorderSide(width: 2)),
          ),
        ),
      ),
    );
  }

  Color _getRandomColor() {
    return Color((0xff000000 + Random().nextInt(0xffffff)).toInt())
        .withOpacity(1.0);
  }
}
