import 'package:appwrite/models.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dashboard_manga_easy/core/config/app_helpes.dart';
import 'package:dashboard_manga_easy/core/interfaces/controller.dart';
import 'package:dashboard_manga_easy/core/services/appwrite_client.dart';
import 'package:dashboard_manga_easy/core/services/service_route.dart';
import 'package:dashboard_manga_easy/modules/auth/domain/models/credencial_model.dart';
import 'package:dashboard_manga_easy/modules/auth/domain/models/erros_auth.dart';
import 'package:dashboard_manga_easy/modules/auth/domain/repo/credencial_repo.dart';
import 'package:dashboard_manga_easy/modules/dashboard/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:sdk_manga_easy/sdk_manga_easy.dart' as sdk;

class AuthController extends IController {
  final CredencialRepo credencialRepo;
  //final Global gb;
  final ServiceRoute serviceRoute;
  final AppwriteClient app;
  CredencialModel? credencialModel;
  sdk.Permissions? permissions;
  var email = TextEditingController();
  var password = TextEditingController();

  AuthController({
    required this.serviceRoute,
    required this.app,
    required this.credencialRepo,
  });

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  void init(BuildContext context) {
    loginAutomatico(context);
    carregaCredencial();
  }

  void logar(context) async {
    try {
      await checkUsuario();
      var dataUser = await app.account.get();
      await validacaoPermissao(dataUser);
      serviceRoute.user = sdk.User.fromJson(dataUser.toMap());
      serviceRoute.permissions = permissions;
      salvaCredencial();
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainPage.route,
        (route) => false,
      );
    } catch (e) {
      sdk.Helps.log(e);
      AppHelps.confirmaDialog(
        title: ErrosAuth.erroLogin,
        content: e.toString(),
        context: context,
      );
    }
  }

  Future<Session> checkUsuario() async {
    return await app.account.createEmailSession(
      email: email.text,
      password: password.text,
    );
  }

  Future<void> validacaoPermissao(User response) async {
    DocumentList result = await app.database.listDocuments(
      collectionId: sdk.Permissions.collectionId,
      queries: [
        Query.equal(
          'userId',
          response.$id,
        )
      ],
    );
    if (result.total <= 0) {
      throw Exception(ErrosAuth.isNotAdmin);
    }
    var data = result.documents.first.data;
    permissions = sdk.Permissions.fromJson(data);
  }

  void carregaCredencial() {
    var ret = credencialRepo.list();
    if (ret.isNotEmpty) {
      credencialModel = ret.first;
      email.text = credencialModel!.email;
    }
  }

  Future<void> salvaCredencial() async {
    var cred = CredencialModel(
      datetime: DateTime.now(),
      email: email.text,
    );
    await credencialRepo.put(objeto: cred);
  }

  Future<void> loginAutomatico(context) async {
    try {
      var dataUser = await app.account.get();
      await validacaoPermissao(dataUser);
      serviceRoute.user = sdk.User.fromJson(dataUser.toMap());
      serviceRoute.permissions = permissions;
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainPage.route,
        (route) => false,
      );
    } catch (e) {
      sdk.Helps.log(e);
    }
  }
}
