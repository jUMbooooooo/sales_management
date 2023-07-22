import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/custom_widget/drawer.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesManagementPage extends ConsumerWidget {
  const SalesManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      initialIndex: 0,
      length: 6, // Tabの数を6に設定
      child: Scaffold(
        appBar: AppBar(
          title: const Text("売上管理"),
          backgroundColor: const Color(0xFF222831),
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: '2023年01月'),
              Tab(text: '2023年02月'),
              Tab(text: '2023年03月'),
              Tab(text: '2023年04月'),
              Tab(text: '2023年05月'),
              Tab(text: '2023年06月'),
            ],
          ),
        ),
        drawer: const MyDrawer(),
        body: const TabBarView(
          children: [
            SingleChildScrollView(
              child: Row(
                children: [
                  Column(),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Column(),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Column(),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Column(),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Column(),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Column(),
                ],
              ),
            ),
            // 残りのタブのコンテンツもここに追加する必要があります
          ],
        ),
      ),
    );
  }
}
