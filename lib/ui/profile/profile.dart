import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/data_moudel/auth_data.dart';
import 'package:nike_flutter_application/data/repo/auth_repository.dart';
import 'package:nike_flutter_application/ui/auth/auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text(
        'پروفایل',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .apply(fontSizeDelta: 5, fontWeightDelta: 2),
      ))),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.valueNotifierAutInfo,
        builder: (context, authInfo, child) {
          final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
          return Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 64, bottom: 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 1, color: Colors.grey.withOpacity(0.4))),
                  child: Image.asset(
                    'assets/img/nike_logo.png',
                    height: 64,
                    width: 64,
                  ),
                ),
              ),
              Text(
                isLogin ? 'Jamil.gharibi69@gmail.com' : 'میهمان',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .apply(color: Colors.black, fontSizeDelta: -0.5),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.8),
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.heart),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'لیست علاقه مندی ها',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Divider(
                    color: Colors.grey.withOpacity(0.8),
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.cart),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'سوابق سفارش',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Divider(
                    color: Colors.grey.withOpacity(0.8),
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      if (isLogin) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: Text(
                                    'خروج از حساب کاربری',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .apply(
                                            color: Colors.black,
                                            fontWeightDelta: 700),
                                  ),
                                  content: const Text(
                                      'آیا می خواهید از حساب کاربری خود خارج شوید؟'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          AuthRepository.valueNotifierAutInfo
                                              .value = null;
                                          authRepository.signOut();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('بله')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('خیر')),
                                  ],
                                ),
                              );
                            });
                      } else {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.exit_to_app),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            isLogin
                                ? 'خروج از حساب کاربری'
                                : 'ورود به حساب کاربری',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.withOpacity(0.7),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
