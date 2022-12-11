import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dashboard_manga_easy/core/interfaces/external_repositories_interface.dart';
import 'package:dashboard_manga_easy/modules/temporadas/domain/models/temporadas_params.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class TemporadasRepository
    extends IRepoExternal<TemporadaModel, TemporadasParams> {
  @override
  String get table => TemporadaModel.collectionId;

  TemporadasRepository(super.db);

  @override
  Future<void> creatDocument({required TemporadaModel objeto}) async {
    await db.database.createDocument(
      collectionId: table,
      documentId: 'unique()',
      data: objeto.toJson(),
      read: ['role:all'],
      write: ['role:all'],
    );
  }

  @override
  Future<void> deletDocument({required String id}) async {
    await db.database.deleteDocument(
      collectionId: table,
      documentId: id,
    );
  }

  @override
  Future<TemporadaModel?> getDocument({required String id}) async {
    try {
      var ret = await db.database.getDocument(
        collectionId: table,
        documentId: id,
      );
      return TemporadaModel.fromJson(ret.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateDocument({required TemporadaModel objeto}) async {
    await db.database.updateDocument(
      collectionId: table,
      documentId: objeto.id!,
      data: objeto.toJson(),
    );
  }

  @override
  Future<DataRepoExternal<TemporadaModel>> listDocument(
      {TemporadasParams? where}) async {
    var filtro = [];
    if (where != null) {
      if (where.userId != null) {
        filtro.add(Query.equal('userId', where.userId));
      }
    }
    var ret = await db.database.listDocuments(
      collectionId: table,
      queries: filtro,
    );
    var data =
        ret.documents.map((e) => TemporadaModel.fromJson(e.data)).toList();
    return DataRepoExternal(
      data: data,
      total: ret.total,
    );
  }
}
