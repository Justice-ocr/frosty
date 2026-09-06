import 'package:flutter/material.dart';
import 'package:frosty/l10n/app_localizations.dart';
import 'package:frosty/screens/channel/channel.dart';
import 'package:frosty/screens/settings/account/blocked_users.dart';
import 'package:frosty/screens/settings/stores/auth_store.dart';
import 'package:frosty/screens/settings/widgets/settings_tile_route.dart';
import 'package:frosty/widgets/frosty_dialog.dart';
import 'package:frosty/widgets/frosty_scrollbar.dart';

class AccountOptions extends StatelessWidget {
  final AuthStore authStore;

  const AccountOptions({super.key, required this.authStore});

  Future<void> _showLogoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => FrostyDialog(
        title: context.l10n('Log out'),
        message: 'Are you sure you want to log out?',
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(context.l10n('Cancel')),
          ),
          FilledButton(
            onPressed: () {
              authStore.logout();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(context.l10n('Log out')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FrostyScrollbar(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: [
          SettingsTileRoute(
            leading: const Icon(Icons.person_rounded),
            title: context.l10n('My channel'),
            useScaffold: false,
            child: VideoChat(
              userId: authStore.user.details!.id,
              userName: authStore.user.details!.displayName,
              userLogin: authStore.user.details!.login,
            ),
          ),
          SettingsTileRoute(
            leading: const Icon(Icons.block_rounded),
            title: context.l10n('Blocked users'),
            child: BlockedUsers(authStore: authStore),
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(context.l10n('Log out')),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
