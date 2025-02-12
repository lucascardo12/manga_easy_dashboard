import 'package:dashboard_manga_easy/core/config/app_theme.dart';
import 'package:dashboard_manga_easy/core/libraries/templates/default_page_template.dart';
import 'package:dashboard_manga_easy/modules/dashboard/presenter/ui/atoms/button_padrao_atom.dart';
import 'package:dashboard_manga_easy/modules/dashboard/presenter/ui/atoms/campo_padrao_atom.dart';
import 'package:dashboard_manga_easy/modules/host/presenter/controllers/host_details_controller.dart';
import 'package:dashboard_manga_easy/modules/host/presenter/ui/organism/select_host_lang.dart';
import 'package:flutter/material.dart';
import 'package:page_manager/manager_page.dart';

class HostDetailsPage extends StatefulWidget {
  const HostDetailsPage({super.key});
  @override
  State<HostDetailsPage> createState() => _HostDetailsPageState();
}

class _HostDetailsPageState
    extends ManagerPage<HostDetailsController, HostDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final tipo = ct.id == null ? 'Criar' : 'Alterar';
    return DefaultPageTemplate(
      state: ct.state,
      appBar: Text('$tipo Host'),
      error: ct.error,
      pageDone: () => ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                CampoPadraoAtom(
                  hintText: 'Nome do host',
                  initialValue: ct.dto.name,
                  onChange: (v) => ct.dto.name = v,
                ),
                const SizedBox(height: AppTheme.defaultPadding * 2),
                CampoPadraoAtom(
                  hintText: 'Url',
                  initialValue: ct.dto.urlApi,
                  onChange: (v) => ct.dto.urlApi = v,
                ),
                const SizedBox(height: AppTheme.defaultPadding * 2),
                CampoPadraoAtom(
                  hintText: 'Ordem',
                  initialValue: ct.dto.order.toString(),
                  onChange: (v) => ct.dto.order = int.tryParse(v) ?? 0,
                ),
                const SizedBox(height: AppTheme.defaultPadding * 2),
                CampoPadraoAtom(
                  hintText: 'Idhost',
                  initialValue: ct.dto.hostId.toString(),
                  onChange: (v) => ct.dto.hostId = int.tryParse(v) ?? 0,
                ),
                const SizedBox(height: AppTheme.defaultPadding * 2),
                LanguageSelector(
                  options: const ['EN', 'ES', 'PT_BR'],
                  selectedOptions: ct.dto.languages
                      .split('<>')
                      .where((item) => item.isNotEmpty)
                      .toList(),
                  onChanged: (selected) {
                    ct.dto.languages = selected.join('<>');
                  },
                ),
                const SizedBox(height: AppTheme.defaultPadding * 2),
                ButtonPadraoAtom(
                  title: '$tipo Host',
                  icone: Icons.create,
                  onPress: () => ct.saveHost(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
