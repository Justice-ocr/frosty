import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frosty/l10n/app_localizations.dart';
import 'package:frosty/cache_manager.dart';
import 'package:frosty/screens/settings/stores/settings_store.dart';
import 'package:frosty/screens/settings/widgets/release_notes.dart';
import 'package:frosty/screens/settings/widgets/settings_list_switch.dart';
import 'package:frosty/widgets/alert_message.dart';
import 'package:frosty/widgets/frosty_dialog.dart';

class OtherSettings extends StatefulWidget {
  final SettingsStore settingsStore;

  const OtherSettings({super.key, required this.settingsStore});

  @override
  State<OtherSettings> createState() => _OtherSettingsState();
}

class _OtherSettingsState extends State<OtherSettings> {
  Future<void> _showConfirmDialog(BuildContext context) {
    final t = context.l10n;
    return showDialog(
      context: context,
      builder: (context) => FrostyDialog(
        title: t('Reset all settings'),
        message: t('Reset all settings') + '?',
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(t('Cancel')),
          ),
          FilledButton(
            onPressed: () {
              HapticFeedback.heavyImpact();

              widget.settingsStore.resetAllSettings();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: AlertMessage(
                    message: t('All settings reset'),
                    centered: false,
                  ),
                ),
              );
            },
            child: Text(t('Reset')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.notes_rounded),
          title: Text(t('Release notes')),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(
            settings: const RouteSettings(name: ReleaseNotes.routeName),
            builder: (context) => const ReleaseNotes(),
          )),
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline_rounded),
          title: Text(t('Clear image cache')),
          onTap: () async {
            HapticFeedback.lightImpact();

            await CustomCacheManager.instance.emptyCache();
            await CustomCacheManager.removeOrphanedCacheFiles();

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AlertMessage(
                  message: t('Image cache cleared'),
                  centered: false,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.restore_rounded),
          title: Text(t('Reset settings')),
          onTap: () => _showConfirmDialog(context),
        ),
        Observer(
          builder: (_) => SettingsListSwitch(
            title: t('Share crash logs and analytics'),
            subtitle: Text(
              'Help improve Frosty by sending anonymous crash logs and analytics through Firebase.',
            ),
            value: widget.settingsStore.shareCrashLogsAndAnalytics,
            onChanged: (newValue) {
              widget.settingsStore.shareCrashLogsAndAnalytics = newValue;

              FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
                newValue,
              );
              FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
                newValue,
              );
              FirebasePerformance.instance.setPerformanceCollectionEnabled(
                newValue,
              );
            },
          ),
        ),
      ],
    );
  }
}
