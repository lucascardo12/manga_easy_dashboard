import 'package:dashboard_manga_easy/core/config/app_helpes.dart';
import 'package:dashboard_manga_easy/core/config/app_theme.dart';
import 'package:dashboard_manga_easy/main.dart';
import 'package:dashboard_manga_easy/modules/dashboard/presenter/ui/atoms/button_padrao_atom.dart';
import 'package:dashboard_manga_easy/modules/dashboard/presenter/ui/atoms/campo_padrao_atom.dart';
import 'package:dashboard_manga_easy/modules/dashboard/presenter/ui/templates/default_page_template.dart';
import 'package:dashboard_manga_easy/modules/temporadas/presenter/controllers/edit_temporada_controller.dart';
import 'package:flutter/material.dart';

class EditTemporadasPage extends StatefulWidget {
  static const route = '/EditTemporadas';
  const EditTemporadasPage({super.key});
  @override
  State<EditTemporadasPage> createState() => _EditTemporadasPageState();
}

class _EditTemporadasPageState extends State<EditTemporadasPage> {
  final ct = di.get<EditTemporadasController>();

  @override
  void initState() {
    ct.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => ct.init(context));
    ct.onMessage(listernerMessage);
    super.initState();
  }

  @override
  void dispose() {
    ct.dispose();
    super.dispose();
  }

  void listernerMessage(String? message) {
    if (message != null && mounted) {
      AppHelps.confirmaDialog(
        title: 'Error ⚠️😥',
        content: message,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPageTemplate(
      state: ct.state,
      done: Scaffold(
        appBar: AppBar(
          title: const Text('Criar Temporada'),
        ),
        body: Container(
          margin: const EdgeInsets.all(AppTheme.defaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: AppTheme.defaultPadding),
            children: [
              CampoPadraoAtom(
                hintText: 'Titulo da temporada',
                initialValue: ct.temporada?.nome,
                onChange: (x) => ct.temporada = ct.temporada?.copyWith(nome: x),
              ),
              const SizedBox(height: AppTheme.defaultPadding),
              ButtonPadraoAtom(
                title: 'Salvar Temporada',
                icone: Icons.create,
                onPress: () => ct.salvarEditaDados(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
