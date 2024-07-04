import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/repo/cart_repository.dart';
import 'package:nike_flutter_application/ui/cart/cart.dart';
import 'package:nike_flutter_application/ui/home/home.dart';
import 'package:nike_flutter_application/ui/profile/profile.dart';
import 'package:nike_flutter_application/ui/widgete/badge.dart';

const int homeIndex = 0, cartIndex = 1, profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedTabScreen = homeIndex;

  final List<int> _history = [];
  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final mapState = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey,
  };
  bool didPobState = false;

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              bottom: 65,
              right: 0,
              left: 0,
              child: IndexedStack(
                index: selectedTabScreen,
                children: [
                  _navigator(_homeKey, homeIndex, const HomeScreen()),
                  _navigator(_cartKey, cartIndex, const CartScreen()),
                  _navigator(
                    _profileKey,
                    profileIndex,
                    // Center(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       ElevatedButton(
                    //           onPressed: () {
                    //             authRepository.signOut();
                    //           },
                    //           child: const Text('Sign Out'))
                    //     ],
                    //   ),
                    // ),
                    const ProfileScreen(),
                  ),
                ],
              )),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: BottomNavigationBar(
                  currentIndex: selectedTabScreen,
                  onTap: (selectedIndex) {
                    setState(() {
                      _history.remove(selectedTabScreen);
                      _history.add(selectedTabScreen);
                      selectedTabScreen = selectedIndex;
                    });
                  },
                  items: [
                    const BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.home), label: 'خانه'),
                    BottomNavigationBarItem(
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(CupertinoIcons.cart),
                            Positioned(
                                right: -15,
                                child: ValueListenableBuilder<int>(
                                    valueListenable:
                                        CartRepository.cartItemCountNotifire,
                                    builder: (context, value, child) =>
                                        BadgeCart(count: value)))
                          ],
                        ),
                        label: 'سبد خرید'),
                    const BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.person), label: 'پروفایل'),
                  ]))
        ],
      ),
    ));
  }

  Widget _navigator(GlobalKey key, int indexTab, Widget screen) {
    return key.currentState == null && selectedTabScreen != indexTab
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                    offstage: selectedTabScreen != indexTab, child: screen)));
  }
}
