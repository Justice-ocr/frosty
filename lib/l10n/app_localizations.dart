import 'package:flutter/widgets.dart';

/// Lightweight localizations used by Frosty's custom UI strings.
/// English remains available while Simplified Chinese is the default.
class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = [Locale('zh'), Locale('en')];

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations) ??
      const AppLocalizations(Locale('zh'));

  String get(String key) {
    final language = locale.languageCode == 'en' ? 'en' : 'zh';
    return _strings[language]?[key] ?? _strings['en']?[key] ?? key;
  }

  String call(String key) => get(key);

  static const _strings = <String, Map<String, String>>{
    'en': {
      'Settings': 'Settings',
      'Following': 'Following',
      'Top': 'Top',
      'Search': 'Search',
      'Account': 'Account',
      'Customize': 'Customize',
      'General': 'General',
      'Video': 'Video',
      'Chat': 'Chat',
      'Other': 'Other',
      'Theme': 'Theme',
      'Message sizing': 'Message sizing',
      'Stream card': 'Stream card',
      'Links': 'Links',
      'Player': 'Player',
      'Overlay': 'Overlay',
      'Large stream cards': 'Large stream cards',
      'Show thumbnails': 'Show thumbnails',
      'Open links in external browser': 'Open links in external browser',
      'Accent color': 'Accent color',
      'Random': 'Random',
      'Cancel': 'Cancel',
      'Done': 'Done',
      'Show video player': 'Show video player',
      'Native player': 'Native player',
      'Default to highest quality': 'Default to highest quality',
      'Use fast video rendering': 'Use fast video rendering',
      'Use custom video overlay': 'Use custom video overlay',
      'Toggle overlay on long-press': 'Toggle overlay on long-press',
      'Show latency': 'Show latency',
      'Keep screen on': 'Keep screen on',
      'Autocomplete': 'Autocomplete',
      'Load recent messages': 'Load recent messages',
      'Preview': 'Preview',
      'Badge scale': 'Badge scale',
      'Emote scale': 'Emote scale',
      'Message scale': 'Message scale',
      'Message spacing': 'Message spacing',
      'Font size': 'Font size',
      'Message appearance': 'Message appearance',
      'Show deleted messages': 'Show deleted messages',
      'Show message dividers': 'Show message dividers',
      'Timestamps': 'Timestamps',
      'Show timestamps on historical messages':
          'Show timestamps on historical messages',
      'Focus current channel': 'Focus current channel',
      'Delay': 'Delay',
      'Auto-sync chat delay': 'Auto-sync chat delay',
      'Chat delay': 'Chat delay',
      'Alerts': 'Alerts',
      'Highlight first-time chatters': 'Highlight first-time chatters',
      'Show notices': 'Show notices',
      'Layout': 'Layout',
      'Emote menu on left': 'Emote menu on left',
      'Remember chat tabs': 'Remember chat tabs',
      'Landscape': 'Landscape',
      'Chat on left side': 'Chat on left side',
      'Force vertical chat': 'Force vertical chat',
      'Notch fill': 'Notch fill',
      'Overlay chat opacity': 'Overlay chat opacity',
      'Filtering': 'Filtering',
      'Match whole words': 'Match whole words',
      'Emotes and badges': 'Emotes and badges',
      'Twitch emotes': 'Twitch emotes',
      'Twitch badges': 'Twitch badges',
      '7TV emotes': '7TV emotes',
      'BTTV emotes': 'BTTV emotes',
      'BTTV badges': 'BTTV badges',
      'FFZ emotes': 'FFZ emotes',
      'FFZ badges': 'FFZ badges',
      'Release notes': 'Release notes',
      'Clear image cache': 'Clear image cache',
      'Reset settings': 'Reset settings',
      'Reset all settings': 'Reset all settings',
      'Reset': 'Reset',
      'All settings reset': 'All settings reset',
      'Image cache cleared': 'Image cache cleared',
      'Share crash logs and analytics': 'Share crash logs and analytics',
      'Language': 'Language',
      'Chinese (Simplified)': 'Chinese (Simplified)',
      'English': 'English',
      'Next': 'Next',
      'Skip': 'Skip',
      'Setup': 'Setup',
      'Welcome!': 'Welcome!',
      'Let\'s go!': 'Let\'s go!',
      'Search channels or categories': 'Search channels or categories',
      'Clear': 'Clear',
      'Streams': 'Streams',
      'Categories': 'Categories',
      'Back': 'Back',
      'More': 'More',
      'Reply': 'Reply',
      'Disconnect': 'Disconnect',
      'Merge chats': 'Merge chats',
      'Show channel': 'Show channel',
      'Hide channel': 'Hide channel',
      'Chat options': 'Chat options',
      'Maximum 10 chats open': 'Maximum 10 chats open',
      'Channel already open, switched to it':
          'Channel already open, switched to it',
      'Copy message': 'Copy message',
      'Copy message and paste': 'Copy message and paste',
      'Reply to message': 'Reply to message',
      'Refresh emotes and badges': 'Refresh emotes and badges',
      'Reconnect': 'Reconnect',
      'Username color': 'Username color',
      'Chatters': 'Chatters',
      'Add chat': 'Add chat',
      'Filter chatters': 'Filter chatters',
      'Search for a channel': 'Search for a channel',
      'Muted keywords': 'Muted keywords',
      'Enter keywords to mute': 'Enter keywords to mute',
      'Unable to connect to Twitch': 'Unable to connect to Twitch',
      'Anonymous': 'Anonymous',
      'Log in': 'Log in',
      'Log out': 'Log out',
      'My channel': 'My channel',
      'Blocked users': 'Blocked users',
      'Unblock': 'Unblock',
      'Support Frosty': 'Support Frosty',
      'View source on GitHub': 'View source on GitHub',
      'Dismiss': 'Dismiss',
      'Enter a message': 'Enter a message',
      'Subscribers only': 'Subscribers only',
      'Language changed': 'Language changed',
      'Prevents the screen from sleeping while a channel is open.':
          'Prevents the screen from sleeping while a channel is open.',
      'Shows matching emotes and mentions while typing.':
          'Shows matching emotes and mentions while typing.',
      'Restores the original message of deleted messages.':
          'Restores the original message of deleted messages.',
      'Shows notices such as subs, announcements, and raids.':
          'Shows notices such as subs, announcements, and raids.',
      'Places the emote menu button on the left side.':
          'Places the emote menu button on the left side.',
      'Secondary chat tabs are kept when switching channels.':
          'Secondary chat tabs are kept when switching channels.',
      'Intended for tablets and larger displays.':
          'Intended for tablets and larger displays.',
      'Only matches whole words instead of partial matches.':
          'Only matches whole words instead of partial matches.',
      'Displays the stream latency in the video overlay.':
          'Displays the stream latency in the video overlay.',
      'Picture-in-Picture, quality selection, and lower latency. Turn off to use the legacy WebView player.':
          'Picture-in-Picture, quality selection, and lower latency. Turn off to use the legacy WebView player.',
      'Uses a faster WebView rendering method. Disable if you experience crashes while watching streams.':
          'Uses a faster WebView rendering method. Disable if you experience crashes while watching streams.',
      'Replaces Twitch\'s default web overlay with a mobile-friendly version.':
          'Replaces Twitch\'s default web overlay with a mobile-friendly version.',
      'Switch between Twitch\'s overlay and the custom overlay.':
          'Switch between Twitch\'s overlay and the custom overlay.',
    },
    'zh': {
      'Settings': '设置',
      'Following': '关注',
      'Top': '热门',
      'Search': '搜索',
      'Account': '账户',
      'Customize': '自定义',
      'General': '通用',
      'Video': '视频',
      'Chat': '聊天',
      'Other': '其他',
      'Theme': '主题',
      'Message sizing': '消息大小',
      'Stream card': '直播卡片',
      'Links': '链接',
      'Player': '播放器',
      'Overlay': '叠加层',
      'Large stream cards': '大尺寸直播卡片',
      'Show thumbnails': '显示缩略图',
      'Open links in external browser': '在外部浏览器打开链接',
      'Accent color': '强调色',
      'Random': '随机',
      'Cancel': '取消',
      'Done': '完成',
      'Show video player': '显示视频播放器',
      'Native player': '原生播放器',
      'Default to highest quality': '默认选择最高画质',
      'Use fast video rendering': '使用快速视频渲染',
      'Use custom video overlay': '使用自定义视频叠加层',
      'Toggle overlay on long-press': '长按切换叠加层',
      'Show latency': '显示延迟',
      'Keep screen on': '保持屏幕常亮',
      'Autocomplete': '自动补全',
      'Load recent messages': '加载最近消息',
      'Preview': '预览',
      'Badge scale': '徽章大小',
      'Emote scale': '表情大小',
      'Message scale': '消息缩放',
      'Message spacing': '消息间距',
      'Font size': '字体大小',
      'Message appearance': '消息外观',
      'Show deleted messages': '显示已删除消息',
      'Show message dividers': '显示消息分隔线',
      'Timestamps': '时间戳',
      'Show timestamps on historical messages': '为历史消息显示时间戳',
      'Focus current channel': '突出当前频道',
      'Delay': '延迟',
      'Auto-sync chat delay': '自动同步聊天延迟',
      'Chat delay': '聊天延迟',
      'Alerts': '提醒',
      'Highlight first-time chatters': '高亮首次发言用户',
      'Show notices': '显示通知',
      'Layout': '布局',
      'Emote menu on left': '将表情菜单放在左侧',
      'Remember chat tabs': '记住聊天标签页',
      'Landscape': '横屏',
      'Chat on left side': '将聊天放在左侧',
      'Force vertical chat': '强制竖向聊天',
      'Notch fill': '填充刘海区域',
      'Overlay chat opacity': '聊天叠加层不透明度',
      'Filtering': '过滤',
      'Match whole words': '匹配完整单词',
      'Emotes and badges': '表情与徽章',
      'Twitch emotes': 'Twitch 表情',
      'Twitch badges': 'Twitch 徽章',
      '7TV emotes': '7TV 表情',
      'BTTV emotes': 'BTTV 表情',
      'BTTV badges': 'BTTV 徽章',
      'FFZ emotes': 'FFZ 表情',
      'FFZ badges': 'FFZ 徽章',
      'Release notes': '版本说明',
      'Clear image cache': '清除图片缓存',
      'Reset settings': '重置设置',
      'Reset all settings': '重置所有设置',
      'Reset': '重置',
      'All settings reset': '所有设置已重置',
      'Image cache cleared': '图片缓存已清除',
      'Share crash logs and analytics': '分享崩溃日志和分析数据',
      'Language': '语言',
      'Chinese (Simplified)': '简体中文',
      'English': 'English',
      'Next': '下一步',
      'Skip': '跳过',
      'Setup': '设置',
      'Welcome!': '欢迎！',
      'Let\'s go!': '开始使用',
      'Search channels or categories': '搜索频道或分类',
      'Clear': '清除',
      'Streams': '直播',
      'Categories': '分类',
      'Back': '返回',
      'More': '更多',
      'Reply': '回复',
      'Disconnect': '断开连接',
      'Merge chats': '合并聊天',
      'Show channel': '显示频道',
      'Hide channel': '隐藏频道',
      'Chat options': '聊天选项',
      'Maximum 10 chats open': '最多同时打开 10 个聊天',
      'Channel already open, switched to it': '频道已打开，已切换到该频道',
      'Copy message': '复制消息',
      'Copy message and paste': '复制消息并粘贴',
      'Reply to message': '回复消息',
      'Refresh emotes and badges': '刷新表情和徽章',
      'Reconnect': '重新连接',
      'Username color': '用户名颜色',
      'Chatters': '聊天用户',
      'Add chat': '添加聊天',
      'Filter chatters': '筛选聊天用户',
      'Search for a channel': '搜索频道',
      'Muted keywords': '屏蔽关键词',
      'Enter keywords to mute': '输入要屏蔽的关键词',
      'Unable to connect to Twitch': '无法连接到 Twitch',
      'Anonymous': '匿名用户',
      'Log in': '登录',
      'Log out': '退出登录',
      'My channel': '我的频道',
      'Blocked users': '已屏蔽用户',
      'Unblock': '取消屏蔽',
      'Support Frosty': '支持 Frosty',
      'View source on GitHub': '在 GitHub 查看源码',
      'Dismiss': '关闭',
      'Enter a message': '输入消息',
      'Subscribers only': '仅限订阅者',
      'Language changed': '语言已切换',
      'Prevents the screen from sleeping while a channel is open.':
          '频道打开时保持屏幕常亮。',
      'Shows matching emotes and mentions while typing.': '输入时显示匹配的表情和提及。',
      'Restores the original message of deleted messages.': '恢复已删除消息的原始内容。',
      'Shows notices such as subs, announcements, and raids.': '显示订阅、公告和突袭等通知。',
      'Places the emote menu button on the left side.': '将表情菜单按钮放在左侧。',
      'Secondary chat tabs are kept when switching channels.':
          '切换频道时保留其他聊天标签页。',
      'Intended for tablets and larger displays.': '适用于平板和更大屏幕。',
      'Only matches whole words instead of partial matches.':
          '仅匹配完整单词，不匹配部分文本。',
      'Displays the stream latency in the video overlay.': '在视频叠加层中显示直播延迟。',
      'Picture-in-Picture, quality selection, and lower latency. Turn off to use the legacy WebView player.':
          '支持画中画、画质选择和更低延迟。关闭后将使用旧版 WebView 播放器。',
      'Uses a faster WebView rendering method. Disable if you experience crashes while watching streams.':
          '使用更快的 WebView 渲染方式。如观看直播时崩溃，请关闭此选项。',
      'Replaces Twitch\'s default web overlay with a mobile-friendly version.':
          '用适合移动设备的版本替换 Twitch 默认网页叠加层。',
      'Switch between Twitch\'s overlay and the custom overlay.':
          '在 Twitch 叠加层和自定义叠加层之间切换。',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
