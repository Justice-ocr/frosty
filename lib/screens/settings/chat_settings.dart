import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frosty/constants.dart';
import 'package:frosty/l10n/app_localizations.dart';
import 'package:frosty/screens/settings/stores/settings_store.dart';
import 'package:frosty/screens/settings/widgets/settings_list_select.dart';
import 'package:frosty/screens/settings/widgets/settings_list_slider.dart';
import 'package:frosty/screens/settings/widgets/settings_list_switch.dart';
import 'package:frosty/screens/settings/widgets/settings_muted_words.dart';
import 'package:frosty/utils/context_extensions.dart';
import 'package:frosty/widgets/frosty_cached_network_image.dart';
import 'package:frosty/widgets/section_header.dart';
import 'package:frosty/widgets/settings_page_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatSettings extends StatelessWidget {
  final SettingsStore settingsStore;

  const ChatSettings({super.key, required this.settingsStore});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    return Observer(
      builder: (context) => SettingsPageLayout(
        children: [
          SectionHeader(t('General'), isFirst: true),
          SettingsListSwitch(
            title: t('Keep screen on'),
            subtitle: Text(t(
                'Prevents the screen from sleeping while a channel is open.')),
            value: settingsStore.keepScreenAwake,
            onChanged: (newValue) => settingsStore.keepScreenAwake = newValue,
          ),
          SettingsListSwitch(
            title: t('Autocomplete'),
            subtitle:
                Text(t('Shows matching emotes and mentions while typing.')),
            value: settingsStore.autocomplete,
            onChanged: (newValue) => settingsStore.autocomplete = newValue,
          ),
          SettingsListSwitch(
            title: t('Load recent messages'),
            subtitle: Text.rich(
              TextSpan(
                text:
                    'Loads historical recent messages in chat through a third-party API service at ',
                children: [
                  TextSpan(
                    text: 'https://recent-messages.robotty.de/',
                    style: TextStyle(
                      color: context.colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: context.colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrl(
                            Uri.parse(
                              'https://recent-messages.robotty.de/',
                            ),
                            mode: settingsStore.launchUrlExternal
                                ? LaunchMode.externalApplication
                                : LaunchMode.inAppBrowserView,
                          ),
                  ),
                ],
              ),
            ),
            value: settingsStore.showRecentMessages,
            onChanged: (newValue) =>
                settingsStore.showRecentMessages = newValue,
          ),
          SectionHeader(t('Message sizing')),
          ExpansionTile(
            title: Text(t('Preview')),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle(
                  style: DefaultTextStyle.of(
                    context,
                  ).style.copyWith(fontSize: settingsStore.fontSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: FrostyCachedNetworkImage(
                                imageUrl:
                                    'https://static-cdn.jtvnw.net/badges/v1/bbbe0db0-a598-423e-86d0-f9fb98ca1933/3',
                                height:
                                    defaultBadgeSize * settingsStore.badgeScale,
                                width:
                                    defaultBadgeSize * settingsStore.badgeScale,
                              ),
                            ),
                            const TextSpan(
                              text: ' Badge and emote preview. ',
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: FrostyCachedNetworkImage(
                                imageUrl:
                                    'https://static-cdn.jtvnw.net/emoticons/v2/425618/default/dark/3.0',
                                height:
                                    defaultEmoteSize * settingsStore.emoteScale,
                                width:
                                    defaultEmoteSize * settingsStore.emoteScale,
                              ),
                            ),
                          ],
                        ),
                        textScaler: settingsStore.messageScale.textScaler,
                      ),
                      SizedBox(height: settingsStore.messageSpacing),
                      Text(
                        'Hello! Here\'s a text preview.',
                        textScaler: settingsStore.messageScale.textScaler,
                      ),
                      SizedBox(height: settingsStore.messageSpacing),
                      Text(
                        'And another for spacing without an emote!',
                        textScaler: settingsStore.messageScale.textScaler,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SettingsListSlider(
            title: t('Badge scale'),
            trailing: '${settingsStore.badgeScale.toStringAsFixed(2)}x',
            value: settingsStore.badgeScale,
            min: 0.25,
            max: 3.0,
            divisions: 11,
            onChanged: (newValue) => settingsStore.badgeScale = newValue,
          ),
          SettingsListSlider(
            title: t('Emote scale'),
            trailing: '${settingsStore.emoteScale.toStringAsFixed(2)}x',
            value: settingsStore.emoteScale,
            min: 0.25,
            max: 3.0,
            divisions: 11,
            onChanged: (newValue) => settingsStore.emoteScale = newValue,
          ),
          SettingsListSlider(
            title: t('Message scale'),
            trailing: '${settingsStore.messageScale.toStringAsFixed(2)}x',
            value: settingsStore.messageScale,
            min: 0.5,
            max: 2.0,
            divisions: 6,
            onChanged: (newValue) => settingsStore.messageScale = newValue,
          ),
          SettingsListSlider(
            title: t('Message spacing'),
            trailing: '${settingsStore.messageSpacing.toStringAsFixed(0)}px',
            value: settingsStore.messageSpacing,
            max: 30.0,
            divisions: 15,
            onChanged: (newValue) => settingsStore.messageSpacing = newValue,
          ),
          SettingsListSlider(
            title: t('Font size'),
            trailing: settingsStore.fontSize.toInt().toString(),
            value: settingsStore.fontSize,
            min: 5,
            max: 20,
            divisions: 15,
            onChanged: (newValue) => settingsStore.fontSize = newValue,
          ),
          SectionHeader(t('Message appearance')),
          SettingsListSwitch(
            title: t('Show deleted messages'),
            subtitle:
                Text(t('Restores the original message of deleted messages.')),
            value: settingsStore.showDeletedMessages,
            onChanged: (newValue) =>
                settingsStore.showDeletedMessages = newValue,
          ),
          SettingsListSwitch(
            title: t('Show message dividers'),
            value: settingsStore.showChatMessageDividers,
            onChanged: (newValue) =>
                settingsStore.showChatMessageDividers = newValue,
          ),
          SettingsListSelect(
            title: t('Timestamps'),
            selectedOption: timestampNames[settingsStore.timestampType.index],
            options: timestampNames,
            onChanged: (newValue) => settingsStore.timestampType =
                TimestampType.values[timestampNames.indexOf(newValue)],
          ),
          SettingsListSwitch(
            title: t('Show timestamps on historical messages'),
            subtitle: const Text(
              'Always show timestamps on messages loaded from chat history, '
              'even when timestamps are disabled above.',
            ),
            value: settingsStore.showHistoricalTimestamps,
            onChanged: (newValue) =>
                settingsStore.showHistoricalTimestamps = newValue,
          ),
          SettingsListSwitch(
            title: t('Focus current channel'),
            subtitle: const Text(
              'Fades messages from other channels in merged chat, '
              'so the current channel stands out.',
            ),
            value: settingsStore.focusCurrentChannel,
            onChanged: (newValue) =>
                settingsStore.focusCurrentChannel = newValue,
          ),
          SectionHeader(t('Delay')),
          SettingsListSwitch(
            title: t('Auto-sync chat delay'),
            value: settingsStore.autoSyncChatDelay,
            onChanged: (newValue) => settingsStore.autoSyncChatDelay = newValue,
          ),
          if (!settingsStore.autoSyncChatDelay)
            SettingsListSlider(
              title: t('Chat delay'),
              trailing: '${settingsStore.chatDelay.toInt()} seconds',
              subtitle:
                  'Adds a delay before each message is rendered in chat. ${Platform.isIOS ? '15 seconds is recommended for iOS.' : ''}',
              value: settingsStore.chatDelay,
              max: 30.0,
              divisions: 30,
              onChanged: (newValue) => settingsStore.chatDelay = newValue,
            ),
          SectionHeader(t('Alerts')),
          SettingsListSwitch(
            title: t('Highlight first-time chatters'),
            value: settingsStore.highlightFirstTimeChatter,
            onChanged: (newValue) =>
                settingsStore.highlightFirstTimeChatter = newValue,
          ),
          SettingsListSwitch(
            title: t('Show notices'),
            subtitle: Text(
                t('Shows notices such as subs, announcements, and raids.')),
            value: settingsStore.showUserNotices,
            onChanged: (newValue) => settingsStore.showUserNotices = newValue,
          ),
          SectionHeader(t('Layout')),
          SettingsListSwitch(
            title: t('Emote menu on left'),
            subtitle: Text(t('Places the emote menu button on the left side.')),
            value: settingsStore.emoteMenuButtonOnLeft,
            onChanged: (newValue) =>
                settingsStore.emoteMenuButtonOnLeft = newValue,
          ),
          SettingsListSwitch(
            title: t('Remember chat tabs'),
            subtitle: Text(
                t('Secondary chat tabs are kept when switching channels.')),
            value: settingsStore.persistChatTabs,
            onChanged: (newValue) {
              settingsStore.persistChatTabs = newValue;
              if (!newValue) {
                settingsStore.secondaryTabs = [];
              }
            },
          ),
          SectionHeader(t('Landscape')),
          SettingsListSwitch(
            title: t('Chat on left side'),
            value: settingsStore.landscapeChatLeftSide,
            onChanged: (newValue) =>
                settingsStore.landscapeChatLeftSide = newValue,
          ),
          SettingsListSwitch(
            title: t('Force vertical chat'),
            subtitle: Text(t('Intended for tablets and larger displays.')),
            value: settingsStore.landscapeForceVerticalChat,
            onChanged: (newValue) =>
                settingsStore.landscapeForceVerticalChat = newValue,
          ),
          SettingsListSelect(
            title: t('Notch fill'),
            subtitle: 'Fills the display cutout area on the selected side.',
            selectedOption:
                landscapeCutoutNames[settingsStore.landscapeCutout.index],
            options: landscapeCutoutNames,
            onChanged: (newValue) => settingsStore.landscapeCutout =
                LandscapeCutoutType.values[landscapeCutoutNames.indexOf(
              newValue,
            )],
          ),
          SettingsListSlider(
            title: t('Overlay chat opacity'),
            trailing:
                '${(settingsStore.fullScreenChatOverlayOpacity * 100).toStringAsFixed(0)}%',
            subtitle: 'Opacity of the chat overlay in fullscreen mode.',
            value: settingsStore.fullScreenChatOverlayOpacity,
            divisions: 10,
            onChanged: (newValue) =>
                settingsStore.fullScreenChatOverlayOpacity = newValue,
          ),
          SectionHeader(t('Filtering')),
          SettingsMutedWords(settingsStore: settingsStore),
          SettingsListSwitch(
            title: t('Match whole words'),
            subtitle:
                Text(t('Only matches whole words instead of partial matches.')),
            value: settingsStore.matchWholeWord,
            onChanged: (newValue) => settingsStore.matchWholeWord = newValue,
          ),
          SectionHeader(t('Emotes and badges')),
          SettingsListSwitch(
            title: t('Twitch emotes'),
            value: settingsStore.showTwitchEmotes,
            onChanged: (newValue) => settingsStore.showTwitchEmotes = newValue,
          ),
          SettingsListSwitch(
            title: t('Twitch badges'),
            value: settingsStore.showTwitchBadges,
            onChanged: (newValue) => settingsStore.showTwitchBadges = newValue,
          ),
          SettingsListSwitch(
            title: t('7TV emotes'),
            value: settingsStore.show7TVEmotes,
            onChanged: (newValue) => settingsStore.show7TVEmotes = newValue,
          ),
          SettingsListSwitch(
            title: t('BTTV emotes'),
            value: settingsStore.showBTTVEmotes,
            onChanged: (newValue) => settingsStore.showBTTVEmotes = newValue,
          ),
          SettingsListSwitch(
            title: t('BTTV badges'),
            value: settingsStore.showBTTVBadges,
            onChanged: (newValue) => settingsStore.showBTTVBadges = newValue,
          ),
          SettingsListSwitch(
            title: t('FFZ emotes'),
            value: settingsStore.showFFZEmotes,
            onChanged: (newValue) => settingsStore.showFFZEmotes = newValue,
          ),
          SettingsListSwitch(
            title: t('FFZ badges'),
            value: settingsStore.showFFZBadges,
            onChanged: (newValue) => settingsStore.showFFZBadges = newValue,
          ),
        ],
      ),
    );
  }
}
