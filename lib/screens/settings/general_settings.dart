import 'package:flutter/material.dart';
// import removed: flutter_colorpicker
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frosty/l10n/app_localizations.dart';
import 'package:frosty/screens/settings/stores/settings_store.dart';
import 'package:frosty/screens/settings/widgets/settings_list_select.dart';
import 'package:frosty/screens/settings/widgets/settings_list_switch.dart';
import 'package:frosty/widgets/accent_color_setting.dart';
import 'package:frosty/widgets/external_browser_setting.dart';
// import removed: frosty/widgets/dialog.dart
import 'package:frosty/widgets/section_header.dart';
import 'package:frosty/widgets/settings_page_layout.dart';
import 'package:frosty/widgets/theme_selection_setting.dart';

class GeneralSettings extends StatelessWidget {
  final SettingsStore settingsStore;

  const GeneralSettings({super.key, required this.settingsStore});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Observer(
      builder: (context) => SettingsPageLayout(
        children: [
          SectionHeader(t('Theme'), isFirst: true),
          SettingsListSelect(
            title: t('Language'),
            selectedOption: settingsStore.localeCode == 'zh'
                ? t('Chinese (Simplified)')
                : t('English'),
            options: [t('Chinese (Simplified)'), t('English')],
            onChanged: (value) => settingsStore.setLocale(
              value == t('Chinese (Simplified)') ? 'zh' : 'en',
            ),
          ),
          ThemeSelectionSetting(settingsStore: settingsStore),
          AccentColorSetting(settingsStore: settingsStore),
          SectionHeader(t('Stream card')),
          SettingsListSwitch(
            title: t('Large stream cards'),
            value: settingsStore.largeStreamCard,
            onChanged: (newValue) => settingsStore.largeStreamCard = newValue,
          ),
          SettingsListSwitch(
            title: t('Show thumbnails'),
            value: settingsStore.showThumbnails,
            onChanged: (newValue) => settingsStore.showThumbnails = newValue,
          ),
          SectionHeader(t('Links')),
          ExternalBrowserSetting(settingsStore: settingsStore),
        ],
      ),
    );
  }
}
