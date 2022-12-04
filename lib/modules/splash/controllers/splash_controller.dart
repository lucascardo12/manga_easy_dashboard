import 'package:dashboard_manga_easy/core/config/app_helpes.dart';
import 'package:dashboard_manga_easy/core/core_module.dart';
import 'package:dashboard_manga_easy/core/interfaces/controller.dart';
import 'package:dashboard_manga_easy/modules/auth/views/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:sdk_manga_easy/sdk_manga_easy.dart';

class SplashController extends IController {
  SplashController();

  @override
  void init(BuildContext context) {
    loadingServices(context);
  }

  void loadingServices(context) async {
    try {
      await CoreModule().start();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthPage.route,
        (route) => true,
      );
    } catch (e) {
      Helps.log(e);
      AppHelps.confirmaDialog(
        title: 'Erro',
        content: e.toString(),
        context: context,
      );
    }
  }
}
