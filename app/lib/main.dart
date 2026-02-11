// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const AmirZXApp());
}

class AmirZXApp extends StatelessWidget {
  const AmirZXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'amirzx / cyberslayer',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050405),
      ),
      home: const TerminalHome(),
    );
  }
}

class _Crimson {
  static const Color bg = Color(0xFF050405);
  static const Color bg2 = Color(0xFF0B0709);
  static const Color panel = Color(0xEE0A0809);
  static const Color edge = Color(0xFF2B0D15);
  static const Color crimson = Color(0xFF6F0018);
  static const Color blood = Color(0xFF8C1128);
  static const Color glow = Color(0xFFC22B45);
  static const Color text = Color(0xFFECCED4);
  static const Color dim = Color(0xFFA58A91);
}

class ServiceLink {
  final String name;
  final String key;
  final String url;

  const ServiceLink({
    required this.name,
    required this.key,
    required this.url,
  });
}

class TerminalHome extends StatefulWidget {
  const TerminalHome({super.key});

  @override
  State<TerminalHome> createState() => _TerminalHomeState();
}

class _TerminalHomeState extends State<TerminalHome>
    with TickerProviderStateMixin {
  final List<String> _lines = <String>[];
  final ScrollController _scroll = ScrollController();
  final TextEditingController _cmdController = TextEditingController();

  late final AnimationController _bgController;
  late final AnimationController _pulseController;
  late final AnimationController _radarController;

  Timer? _typingTimer;
  int _step = 0;
  bool _isFa = false;
  int _hudMode = 0;
  bool _awaitingSudoUser = false;
  bool _awaitingSudoPass = false;
  bool _awaitingServiceName = false;
  bool _awaitingServiceUrl = false;
  bool _sudoUnlocked = false;
  String _sudoUserInput = '';
  String _pendingServiceName = '';

  final List<ServiceLink> _services = <ServiceLink>[
    const ServiceLink(
      name: 'Proxmox',
      key: 'proxmox',
      url: 'https://proxmox.local',
    ),
    const ServiceLink(
      name: 'Portainer',
      key: 'portainer',
      url: 'https://portainer.local',
    ),
  ];

  static const int _userHash = 0xC6948D76;
  static const int _passHash = 0xEF10104C;

  static const List<String> _bootEn = [
    r'[boot] dark-neural-core .......... online',
    r'[boot] crimson-theme ............. loaded',
    r'[boot] hud matrix ................ synced',
    r'',
    r'identity:: Amir Talebi',
    r'alias::: amirzx / cyberslayer',
    r'role:::: Linux | Networking | DevOps | Software',
    r'vibe:::: dark sci-fi | metalhead | rave',
    r'',
    r'-- OPERATIONS FRAME --',
    r'os ........... CachyOS x86_64',
    r'kernel ....... 6.18.8-1-cachyos',
    r'cpu .......... AMD Ryzen 5 4500U',
    r'ram .......... 14.35 GiB',
    r'desktop ...... KDE Plasma 6.5.5 / KWin Wayland',
    r'',
    r'type: help',
  ];

  static const List<String> _bootFa = [
    r'[boot] هسته نئوتاریک ............ فعال',
    r'[boot] تم خون‌سرخ ............... بارگذاری شد',
    r'[boot] ماتریس HUD ............... سینک شد',
    r'',
    r'هویت:: Amir Talebi',
    r'نام::: amirzx / cyberslayer',
    r'نقش::: لینوکس | شبکه | دواپس | توسعه نرم‌افزار',
    r'حال::: سای‌فای تاریک | متالهد | ریو',
    r'',
    r'-- چارچوب عملیات --',
    r'سیستم‌عامل .... CachyOS x86_64',
    r'کرنل .......... 6.18.8-1-cachyos',
    r'پردازنده ...... AMD Ryzen 5 4500U',
    r'رم ............ 14.35 گیگابایت',
    r'میزکار ........ KDE Plasma 6.5.5 / KWin Wayland',
    r'',
    r'بنویس: help',
  ];

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _startBootTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _bgController.dispose();
    _pulseController.dispose();
    _radarController.dispose();
    _scroll.dispose();
    _cmdController.dispose();
    super.dispose();
  }

  void _startBootTyping() {
    _typingTimer?.cancel();
    _lines.clear();
    _step = 0;
    _typingTimer = Timer.periodic(const Duration(milliseconds: 65), (_) {
      final script = _isFa ? _bootFa : _bootEn;
      if (_step >= script.length) {
        _typingTimer?.cancel();
        _appendPrompt();
        return;
      }
      setState(() {
        _lines.add(script[_step]);
        _step += 1;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  String _prompt() => _isFa ? 'root@cyberpad:~/fa\$' : 'root@cyberpad:~\$';

  void _appendPrompt() {
    setState(() => _lines.add('${_prompt()} _'));
    _scrollToBottom();
  }

  void _writeBlock(List<String> block) {
    setState(() {
      _lines.removeWhere((line) => line.trim() == '${_prompt()} _');
      _lines.addAll(block);
      _lines.add('${_prompt()} _');
    });
    _scrollToBottom();
  }

  int _fnv1aHash(String value) {
    int hash = 0x811C9DC5;
    for (final byte in utf8.encode(value)) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  String _serviceKey(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

  void _openUrl(String url) {
    if (kIsWeb) {
      html.window.open(url, '_blank');
    }
  }

  void _executeCommand(String raw) {
    final cmd = raw.trim();
    if (cmd.isEmpty) return;

    _typingTimer?.cancel();
    final normalized = cmd.toLowerCase();

    if (_awaitingSudoUser) {
      _awaitingSudoUser = false;
      _awaitingSudoPass = true;
      _sudoUserInput = cmd;
      _writeBlock([
        '${_prompt()} sudo',
        _isFa ? 'username received.' : 'username received.',
        _isFa ? 'password:' : 'password:',
      ]);
      return;
    }

    if (_awaitingSudoPass) {
      _awaitingSudoPass = false;
      final bool ok = _fnv1aHash(_sudoUserInput) == _userHash &&
          _fnv1aHash(cmd) == _passHash;
      if (ok) {
        _sudoUnlocked = true;
        _writeBlock([
          '${_prompt()} sudo ********',
          _isFa ? 'sudo unlocked. dashboard available.' : 'sudo unlocked. dashboard available.',
          _isFa
              ? 'commands: service add | service list | open <service>'
              : 'commands: service add | service list | open <service>',
        ]);
      } else {
        _sudoUnlocked = false;
        _writeBlock([
          '${_prompt()} sudo ********',
          _isFa ? 'authentication failed.' : 'authentication failed.',
        ]);
      }
      return;
    }

    if (_awaitingServiceName) {
      _pendingServiceName = cmd;
      _awaitingServiceName = false;
      _awaitingServiceUrl = true;
      _writeBlock([
        '${_prompt()} service add',
        _isFa ? 'service name set: $_pendingServiceName' : 'service name set: $_pendingServiceName',
        _isFa ? 'enter service URL:' : 'enter service URL:',
      ]);
      return;
    }

    if (_awaitingServiceUrl) {
      _awaitingServiceUrl = false;
      final String url = cmd;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        _writeBlock([
          '${_prompt()} service add $_pendingServiceName $url',
          _isFa ? 'invalid URL. use http:// or https://' : 'invalid URL. use http:// or https://',
        ]);
        return;
      }
      final service = ServiceLink(
        name: _pendingServiceName,
        key: _serviceKey(_pendingServiceName),
        url: url,
      );
      setState(() {
        _services.removeWhere((s) => s.key == service.key);
        _services.add(service);
      });
      _writeBlock([
        '${_prompt()} service add ${service.name} ${service.url}',
        _isFa ? 'service saved.' : 'service saved.',
      ]);
      return;
    }

    final out = <String>['${_prompt()} $cmd'];

    switch (normalized) {
      case 'help':
        out.addAll(_isFa
            ? [
                'commands: help | whoami | skills | projects | contact | clear | lang | sudo',
                'نکته: از دکمه‌های سریع هم می‌تونی استفاده کنی.',
              ]
            : [
                'commands: help | whoami | skills | projects | contact | clear | lang | sudo',
                'tip: quick-action buttons are interactive too.',
              ]);
        break;
      case 'sudo':
        _awaitingSudoUser = true;
        _writeBlock([
          '${_prompt()} sudo',
          _isFa ? 'username:' : 'username:',
        ]);
        return;
      case 'whoami':
        out.addAll(_isFa
            ? [
                'amir talebi aka amirzx / cyberslayer',
                'linux/networking/devops expert with automation-first mindset.',
              ]
            : [
                'amir talebi aka amirzx / cyberslayer',
                'linux/networking/devops expert with automation-first mindset.',
              ]);
        break;
      case 'skills':
        out.addAll(_isFa
            ? [
                'stack:',
                ' - linux optimization and troubleshooting',
                ' - container networking, routing, dns',
                ' - ci/cd pipelines and infra automation',
                ' - bash, python, rust engineering flows',
              ]
            : [
                'stack:',
                ' - linux optimization and troubleshooting',
                ' - container networking, routing, dns',
                ' - ci/cd pipelines and infra automation',
                ' - bash, python, rust engineering flows',
              ]);
        break;
      case 'projects':
        out.addAll([
          'featured:',
          ' - waydroid-image-sw (reborn/public)',
          ' - terminal-driven tooling and deployment helpers',
        ]);
        break;
      case 'contact':
        out.addAll([
          'github: https://github.com/amir0zx',
          'identity: amirzx / cyberslayer',
        ]);
        break;
      case 'lang':
        setState(() => _isFa = !_isFa);
        _startBootTyping();
        return;
      case 'clear':
        setState(() => _lines.clear());
        _appendPrompt();
        return;
      default:
        if (normalized == 'service list') {
          if (!_sudoUnlocked) {
            out.add(_isFa ? 'access denied. run sudo first.' : 'access denied. run sudo first.');
          } else if (_services.isEmpty) {
            out.add(_isFa ? 'no services registered.' : 'no services registered.');
          } else {
            out.add(_isFa ? 'services:' : 'services:');
            for (final s in _services) {
              out.add(' - ${s.name} => ${s.url}');
            }
          }
        } else if (normalized.startsWith('service add')) {
          if (!_sudoUnlocked) {
            out.add(_isFa ? 'access denied. run sudo first.' : 'access denied. run sudo first.');
          } else {
            final parts = cmd.split(RegExp(r'\\s+'));
            if (parts.length >= 4) {
              final url = parts.last;
              final name = parts.sublist(2, parts.length - 1).join(' ');
              if (!url.startsWith('http://') && !url.startsWith('https://')) {
                out.add(_isFa
                    ? 'invalid URL. use http:// or https://'
                    : 'invalid URL. use http:// or https://');
              } else {
                final service = ServiceLink(
                  name: name,
                  key: _serviceKey(name),
                  url: url,
                );
                setState(() {
                  _services.removeWhere((s) => s.key == service.key);
                  _services.add(service);
                });
                out.add(_isFa ? 'service saved.' : 'service saved.');
              }
            } else {
              _awaitingServiceName = true;
              _writeBlock([
                '${_prompt()} service add',
                _isFa ? 'enter service name:' : 'enter service name:',
              ]);
              return;
            }
          }
        } else if (normalized.startsWith('open ')) {
          if (!_sudoUnlocked) {
            out.add(_isFa ? 'access denied. run sudo first.' : 'access denied. run sudo first.');
          } else {
            final key = _serviceKey(cmd.substring(5));
            ServiceLink? service;
            for (final item in _services) {
              if (item.key == key) {
                service = item;
                break;
              }
            }
            if (service == null) {
              out.add(_isFa ? 'service not found.' : 'service not found.');
            } else {
              _openUrl(service.url);
              out.add(_isFa
                  ? 'opening ${service.name} -> ${service.url}'
                  : 'opening ${service.name} -> ${service.url}');
            }
          }
        } else {
          out.add(_isFa ? 'command not found: $cmd' : 'command not found: $cmd');
        }
    }

    _writeBlock(out);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final compact = size.width < 980;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + _bgController.value * 0.45, -1),
                end: Alignment(1, 1 - _bgController.value * 0.35),
                colors: const [_Crimson.bg, _Crimson.bg2, Color(0xFF10080B)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _ParticleField(progress: _bgController.value),
                ),
                const Positioned.fill(child: _Scanlines()),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    compact ? 12 : 22,
                    compact ? 14 : 22,
                    compact ? 12 : 22,
                    14,
                  ),
                  child: Column(
                    children: [
                      _TopBar(isFa: _isFa, compact: compact),
                      const SizedBox(height: 12),
                      Expanded(
                        child: compact
                            ? _TerminalPanel(
                                lines: _lines,
                                scroll: _scroll,
                                isFa: _isFa,
                                pulse: _pulseController,
                                sudoUnlocked: _sudoUnlocked,
                                services: _services,
                                commandController: _cmdController,
                                onToggleLanguage: () {
                                  setState(() => _isFa = !_isFa);
                                  _startBootTyping();
                                },
                                onOpenService: (service) {
                                  _openUrl(service.url);
                                  _writeBlock([
                                    '${_prompt()} open ${service.key}',
                                    'opening ${service.name} -> ${service.url}',
                                  ]);
                                },
                                onRunCommand: _executeCommand,
                              )
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 330,
                                    child: _SideHud(
                                      isFa: _isFa,
                                      pulse: _pulseController,
                                      radar: _radarController,
                                      mode: _hudMode,
                                      onModeChanged: (v) {
                                        setState(() => _hudMode = v);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _TerminalPanel(
                                      lines: _lines,
                                      scroll: _scroll,
                                      isFa: _isFa,
                                      pulse: _pulseController,
                                      sudoUnlocked: _sudoUnlocked,
                                      services: _services,
                                      commandController: _cmdController,
                                      onToggleLanguage: () {
                                        setState(() => _isFa = !_isFa);
                                        _startBootTyping();
                                      },
                                      onOpenService: (service) {
                                        _openUrl(service.url);
                                        _writeBlock([
                                          '${_prompt()} open ${service.key}',
                                          'opening ${service.name} -> ${service.url}',
                                        ]);
                                      },
                                      onRunCommand: _executeCommand,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool isFa;
  final bool compact;
  const _TopBar({required this.isFa, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xEE0C090A),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _Crimson.edge),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'AMIRZX // CYBERSLAYER',
              style: TextStyle(
                color: _Crimson.glow,
                fontFamily: 'Orbitron',
                fontSize: compact ? 14 : 18,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            isFa ? 'ترمینال نئوتاریک' : 'neo-dark terminal',
            style: TextStyle(
              color: _Crimson.dim,
              fontFamily: isFa ? 'Vazirmatn' : 'JetBrains Mono',
              fontSize: compact ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SideHud extends StatelessWidget {
  final bool isFa;
  final Animation<double> pulse;
  final Animation<double> radar;
  final int mode;
  final ValueChanged<int> onModeChanged;

  const _SideHud({
    required this.isFa,
    required this.pulse,
    required this.radar,
    required this.mode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = isFa ? ['NET', 'SYS', 'ANIME'] : ['NET', 'SYS', 'ANIME'];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _Crimson.panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _Crimson.edge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 134,
            child: AnimatedBuilder(
              animation: radar,
              builder: (context, _) => CustomPaint(
                painter: _RadarPainter(radar.value),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: List.generate(labels.length, (i) {
              final active = i == mode;
              return ChoiceChip(
                label: Text(labels[i]),
                selected: active,
                onSelected: (_) => onModeChanged(i),
                selectedColor: _Crimson.crimson,
                backgroundColor: const Color(0xFF130C0F),
                labelStyle: TextStyle(
                  color: active ? const Color(0xFFF9DCE2) : _Crimson.dim,
                  fontFamily: 'JetBrains Mono',
                  fontSize: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: _Crimson.edge),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          if (mode == 0) ...[
            _HudBar(label: 'latency', value: 0.36, pulse: pulse),
            _HudBar(label: 'throughput', value: 0.81, pulse: pulse),
            _HudBar(label: 'stability', value: 0.92, pulse: pulse),
          ],
          if (mode == 1) ...[
            _HudLine('stack', 'linux / infra / automation'),
            _HudLine('langs', 'bash python rust'),
            _HudLine('runtime', 'wayland + plasma'),
            _HudLine('focus', 'network reliability'),
          ],
          if (mode == 2) ...[
            _HudLine('aesthetic', 'blood-crimson matrix'),
            _HudLine('theme', 'dark sci-fi anime'),
            _HudLine('signal', 'metal + rave energy'),
            _HudLine('state', 'hacker zen mode'),
          ],
          const Spacer(),
          Text(
            isFa ? 'core online // crimson protocol' : 'core online // crimson protocol',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _Crimson.dim,
              fontFamily: 'JetBrains Mono',
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HudLine extends StatelessWidget {
  final String k;
  final String v;
  const _HudLine(this.k, this.v);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            '$k:',
            style: const TextStyle(
              color: _Crimson.dim,
              fontFamily: 'JetBrains Mono',
              fontSize: 10.5,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              v,
              style: const TextStyle(
                color: _Crimson.text,
                fontFamily: 'JetBrains Mono',
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HudBar extends StatelessWidget {
  final String label;
  final double value;
  final Animation<double> pulse;
  const _HudBar({required this.label, required this.value, required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, _) {
          final amp = (value * (0.82 + pulse.value * 0.18)).clamp(0.0, 1.0);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _Crimson.dim,
                  fontFamily: 'JetBrains Mono',
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: amp,
                  minHeight: 7,
                  backgroundColor: const Color(0xFF1A1416),
                  valueColor: const AlwaysStoppedAnimation(_Crimson.blood),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TerminalPanel extends StatelessWidget {
  final List<String> lines;
  final ScrollController scroll;
  final bool isFa;
  final Animation<double> pulse;
  final bool sudoUnlocked;
  final List<ServiceLink> services;
  final TextEditingController commandController;
  final VoidCallback onToggleLanguage;
  final ValueChanged<ServiceLink> onOpenService;
  final ValueChanged<String> onRunCommand;

  const _TerminalPanel({
    required this.lines,
    required this.scroll,
    required this.isFa,
    required this.pulse,
    required this.sudoUnlocked,
    required this.services,
    required this.commandController,
    required this.onToggleLanguage,
    required this.onOpenService,
    required this.onRunCommand,
  });

  @override
  Widget build(BuildContext context) {
    final font = isFa ? 'Vazirmatn' : 'JetBrains Mono';

    return Directionality(
      textDirection: isFa ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _Crimson.panel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _Crimson.edge),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const _Led(color: Color(0xFF8B1027)),
                const _Led(color: Color(0xFF6A0D20)),
                const _Led(color: Color(0xFF4F0B18)),
                const SizedBox(width: 8),
                const Text(
                  'shell://crimson.core',
                  style: TextStyle(
                    color: _Crimson.glow,
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onToggleLanguage,
                  child: Text(
                    isFa ? 'EN / فارسی' : 'فارسی / EN',
                    style: TextStyle(
                      color: _Crimson.glow,
                      fontFamily: font,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF171114), height: 14),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                _CmdChip(label: isFa ? 'whoami' : 'whoami', onTap: () => onRunCommand('whoami')),
                _CmdChip(label: isFa ? 'skills' : 'skills', onTap: () => onRunCommand('skills')),
                _CmdChip(label: isFa ? 'projects' : 'projects', onTap: () => onRunCommand('projects')),
                _CmdChip(label: isFa ? 'contact' : 'contact', onTap: () => onRunCommand('contact')),
                _CmdChip(label: isFa ? 'clear' : 'clear', onTap: () => onRunCommand('clear')),
              ],
            ),
            if (sudoUnlocked && services.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: isFa ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  isFa ? 'quick services (sudo):' : 'quick services (sudo):',
                  style: TextStyle(
                    color: _Crimson.glow,
                    fontFamily: font,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: services
                    .map(
                      (service) => InkWell(
                        onTap: () => onOpenService(service),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: const Color(0x551A0B10),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _Crimson.blood, width: 1),
                          ),
                          child: Text(
                            service.name,
                            style: TextStyle(
                              color: _Crimson.text,
                              fontFamily: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: scroll,
                itemCount: lines.length,
                itemBuilder: (context, i) => Text(
                  lines[i],
                  textAlign: isFa ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    color: _Crimson.text,
                    fontFamily: font,
                    fontSize: isFa ? 16.5 : 16,
                    height: 1.45,
                    shadows: const [
                      Shadow(color: Color(0x441D0000), blurRadius: 6),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  '> ',
                  style: TextStyle(
                    color: _Crimson.glow,
                    fontFamily: 'JetBrains Mono',
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: commandController,
                    onSubmitted: (v) {
                      onRunCommand(v);
                      commandController.clear();
                    },
                    style: TextStyle(
                      color: _Crimson.text,
                      fontFamily: font,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: isFa ? 'command بنویس...' : 'type a command...',
                      hintStyle: const TextStyle(
                        color: _Crimson.dim,
                        fontSize: 12,
                        fontFamily: 'JetBrains Mono',
                      ),
                      filled: true,
                      fillColor: const Color(0xFF110D0F),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: _Crimson.edge),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: _Crimson.edge),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: _Crimson.blood),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: pulse,
                  builder: (context, _) {
                    return Opacity(
                      opacity: 0.45 + pulse.value * 0.55,
                      child: const Text(
                        '▋',
                        style: TextStyle(
                          color: _Crimson.glow,
                          fontFamily: 'JetBrains Mono',
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CmdChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _CmdChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF150E11),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _Crimson.edge),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: _Crimson.text,
            fontSize: 11.5,
            fontFamily: 'JetBrains Mono',
          ),
        ),
      ),
    );
  }
}

class _Led extends StatelessWidget {
  final Color color;
  const _Led({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.42), blurRadius: 5)],
      ),
    );
  }
}

class _ParticleField extends StatelessWidget {
  final double progress;
  const _ParticleField({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ParticlePainter(progress));
  }
}

class _ParticlePainter extends CustomPainter {
  final double t;
  _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()..color = const Color(0x4D8A1A2F);
    final faint = Paint()..color = const Color(0x24FFFFFF);

    for (int i = 0; i < 100; i++) {
      final x = ((i * 97.0) + t * 420.0) % size.width;
      final y = ((i * 59.0) + t * 170.0) % size.height;
      canvas.drawCircle(Offset(x, y), 0.8 + (i % 3) * 0.35, i % 2 == 0 ? red : faint);
    }

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0x337F2033);

    final c = Offset(size.width * 0.8, size.height * 0.2);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: 62),
      t * math.pi * 2,
      math.pi,
      false,
      ring,
    );
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

class _RadarPainter extends CustomPainter {
  final double t;
  _RadarPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) * 0.42;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x668C1A2F);
    final sweep = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0x99C22B45);

    canvas.drawCircle(center, r, ring);
    canvas.drawCircle(center, r * 0.66, ring);
    canvas.drawCircle(center, r * 0.33, ring);
    canvas.drawLine(Offset(center.dx - r, center.dy), Offset(center.dx + r, center.dy), ring);
    canvas.drawLine(Offset(center.dx, center.dy - r), Offset(center.dx, center.dy + r), ring);

    final a = t * math.pi * 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      a - 0.3,
      0.6,
      false,
      sweep,
    );

    final dotPaint = Paint()..color = const Color(0x99D84B63);
    for (int i = 0; i < 7; i++) {
      final da = i * 0.9 + t * 1.2;
      final rr = r * (0.2 + (i % 5) * 0.14);
      canvas.drawCircle(
        Offset(center.dx + math.cos(da) * rr, center.dy + math.sin(da) * rr),
        2,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}

class _Scanlines extends StatelessWidget {
  const _Scanlines();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.07,
        child: CustomPaint(
          painter: _ScanlinePainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white;
    for (double y = 0; y < size.height; y += 3.4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
