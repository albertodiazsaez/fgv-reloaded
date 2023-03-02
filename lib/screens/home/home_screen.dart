import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/screens/stations/stations_screen.dart';
import 'package:metrovalencia_reloaded/screens/timetable/timetable_screen.dart';
import 'package:metrovalencia_reloaded/screens/transport-cards/check_transport_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Text appBarTitleText;
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
    appBarTitleText = Text(tr('appTitle'));
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  static const List<Widget> _pages = <Widget>[
    Text(
      'Index 0: Inicio',
    ),
    StationsScreen(),
    TimetableScreen(),
    CheckTransportCards(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: appBarTitleText),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: tr('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.store),
              label: tr('stations.title'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.schedule),
              label: tr('timetable.title'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.credit_card),
              label: tr('transportCards.title'),
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _changeTab,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Colors.white,
        ));
  }

  _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
      String text = '';
      switch (index) {
        case 0:
          text = tr('home');
          break;
        case 1:
          text = tr('stations.title');
          break;
        case 2:
          text = tr('timetable.title');
          break;
        case 3:
          text = tr('transportCards.title');
          break;
        default:
      }
      appBarTitleText = Text(text);
    });
  }
}
