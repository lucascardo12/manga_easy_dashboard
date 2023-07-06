import 'package:dashboard_manga_easy/modules/emblemas/domain/models/emblema_user_params.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

abstract interface class EmblemaUserRepository {
  Future<void> creatDocument({required EmblemaUser objeto});

  Future<void> deletDocument({required String id});

  Future<EmblemaUser?> getDocument({required String id});

  Future<void> updateDocument({required EmblemaUser objeto});

  Future<List<EmblemaUser>> listDocument({EmblemaUserParams? where});
}
