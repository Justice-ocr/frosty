import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frosty/l10n/app_localizations.dart';
import 'package:frosty/screens/onboarding/login_webview.dart';
import 'package:frosty/screens/settings/account/account_options.dart';
import 'package:frosty/screens/settings/stores/auth_store.dart';
import 'package:frosty/utils/modal_bottom_sheet.dart';
import 'package:frosty/widgets/frosty_dialog.dart';
import 'package:frosty/widgets/profile_picture.dart';

class ProfileCard extends StatelessWidget {
  final AuthStore authStore;

  const ProfileCard({super.key, required this.authStore});

  Future<void> _showAccountOptionsModalBottomSheet(BuildContext context) {
    return showModalBottomSheetWithProperFocus(
      context: context,
      builder: (context) {
        return AccountOptions(authStore: authStore);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (authStore.error != null) {
          return ListTile(
            leading: Icon(
              Icons.error_outline_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(context.l10n('Unable to connect to Twitch')),
            trailing: FilledButton.tonal(
              onPressed: authStore.init,
              child: Text(context.l10n('Reconnect')),
            ),
          );
        }
        if (authStore.isLoggedIn && authStore.user.details != null) {
          final hasToken = authStore.gqlToken != null;
          return ListTile(
            leading: ProfilePicture(
              userLogin: authStore.user.details!.login,
              radius: 12,
            ),
            title: Text.rich(
              TextSpan(
                text: authStore.user.details!.displayName,
                children: [
                  const WidgetSpan(child: SizedBox(width: 6)),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        final navigator = Navigator.of(context);
                        showDialog(
                          context: context,
                          builder: (dialogContext) => FrostyDialog(
                            title: context.l10n('Web session'),
                            message: hasToken
                                ? context.l10n('Web session linked')
                                : context.l10n('Web session not linked'),
                            actions: hasToken
                                ? [
                                    TextButton(
                                      onPressed: Navigator.of(
                                        dialogContext,
                                      ).pop,
                                      child: Text(context.l10n('OK')),
                                    ),
                                  ]
                                : [
                                    TextButton(
                                      onPressed: Navigator.of(
                                        dialogContext,
                                      ).pop,
                                      child: Text(context.l10n('Cancel')),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        navigator.push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoginWebView(),
                                          ),
                                        );
                                      },
                                      child: Text(context.l10n('Log in')),
                                    ),
                                  ],
                          ),
                        );
                      },
                      // Padding enlarges the hit target without stealing taps
                      // on the display name / surrounding ListTile.
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          hasToken
                              ? Icons.check_circle_outline_rounded
                              : Icons.info_outline_rounded,
                          size: 16,
                          color: hasToken ? Colors.green : Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showAccountOptionsModalBottomSheet(context),
          );
        }
        return ListTile(
          leading: const Icon(Icons.no_accounts_rounded),
          title: Text(context.l10n('Anonymous')),
          subtitle: Text(
            context.l10n('Log in to chat, view followed streams, and more.'),
          ),
          trailing: const SizedBox(
            height: double.infinity,
            child: Icon(Icons.chevron_right_rounded),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginWebView()),
          ),
          onLongPress: () async {
            final clipboardText = (await Clipboard.getData(
              Clipboard.kTextPlain,
            ))?.text;

            if (clipboardText == null) return;

            authStore.login(token: clipboardText);
          },
        );
      },
    );
  }
}
