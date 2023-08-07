import 'package:flutter/material.dart';
import 'package:sales_management_app/sales_management/sales_management_page.dart';

import 'inventories_page/inventory_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.title});
  final String title;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentIndex = 0;
  final _pageWidgets = [
    const InventoryPage(),
    const SalesManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidgets.elementAt(_currentIndex),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_mall_outlined),
      //       label: '在庫管理',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.list_alt_outlined),
      //       label: '売上管理',
      //     ),
      //   ],
      //   currentIndex: _currentIndex,
      //   onTap: _onItemTapped,
      //   type: BottomNavigationBarType.fixed,
      // ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
