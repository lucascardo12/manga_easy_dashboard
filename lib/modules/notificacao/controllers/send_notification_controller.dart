import 'package:dashboard_manga_easy/core/config/app_helpes.dart';
import 'package:dashboard_manga_easy/modules/notificacao/dominio/models/notificacao.dart';
import 'package:dashboard_manga_easy/modules/notificacao/dominio/repositories/notificacao_repository.dart';
import 'package:dashboard_manga_easy/modules/users/domain/entities/user.dart';
import 'package:dashboard_manga_easy/modules/users/domain/repositories/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:page_manager/entities/state_manager.dart';
import 'package:page_manager/manager_store.dart';

class SendNotificationController extends ManagerStore {
  final NotificacaoRepository _notificacaoRepository;
  final UsersRepository _usersRepository;

  SendNotificationController(
    this._notificacaoRepository,
    this._usersRepository,
  );
  User? test;
  Notificacao? nova;

  @override
  void init(Map<String, dynamic> arguments) {
    nova = Notificacao.empty();
    state = StateManager.done;
  }

  void enviaNotificacao(context) => handleTry(
        call: () async {
          await _notificacaoRepository.createDocument(objeto: nova!);
          Navigator.pop(context);
          AppHelps.confirmaDialog(
            title: 'Sucesso',
            content: 'Mensagem enviada com sucesso',
            context: context,
          );
        },
      );

  Future<void> enviaNotificacaoTest(context) => handleTry(
        call: () {
          if (test == null) {
            throw Exception('Escolha um usuario para testar a notificação');
          }
          throw UnimplementedError();

          // if (ret.isSend) {
          //   AppHelps.confirmaDialog(
          //     title: 'Sucesso',
          //     content: 'Mensagem enviada com sucesso',
          //     context: context,
          //   );
          // } else {
          //   AppHelps.confirmaDialog(
          //     title: 'Erro',
          //     content: 'Mensagem não foi enviada',
          //     context: context,
          //   );
          // }
        },
      );

  Future<List<User>> pesquisaUser(String search) async {
    return _usersRepository.listDocument(
      search: search.isEmpty ? null : search,
    );
  }
}
