import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xFF050506),
      ),
      home: const TerminalHome(),
    );
  }
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

  late final AnimationController _bgController;
  late final AnimationController _pulseController;

  Timer? _typingTimer;
  int _step = 0;
  bool _isFa = false;

  static const List<String> _scriptEn = [
    r'[boot] cybercore init .......... ok',
    r'[boot] thermal profile ......... stable',
    r'[boot] neural ui ............... online',
    r'',
    r'identity:: Amir Talebi',
    r'alias::: amirzx / cyberslayer',
    r'role:::: Linux | Networking | DevOps | Coding',
    r'mood:::: dark sci-fi / metal / rave',
    r'',
    r'-- SYSTEM MAP --',
    r'os ........... CachyOS x86_64',
    r'host ......... ThinkPad E15 Gen 2',
    r'kernel ....... 6.18.8-1-cachyos',
    r'cpu .......... AMD Ryzen 5 4500U',
    r'gpu .......... Radeon Vega iGPU',
    r'ram .......... 14.35 GiB',
    r'desktop ...... KDE Plasma 6.5.5 | KWin Wayland',
    r'displays ..... 24" external + 16" built-in',
    r'',
    r'-- SPECIALIZATION --',
    r'> Linux optimization + troubleshooting',
    r'> Container networking + service routing',
    r'> DNS, reverse proxy, infra hardening',
    r'> CI/CD automation + deployment flows',
    r'> Bash, Python, Rust workflows',
    r'',
    r'-- ACTIVE PROJECT --',
    r'project ...... waydroid-image-sw',
    r'status ....... reborn/public',
    r'effect ....... zero-friction A13/TV switching',
    r'',
    r'quote> Black core. Red edge. Sharp tools.',
    r'contact> github.com/amir0zx',
    r'location> Iran',
    r'',
    r'root@cyberpad:~$ _',
  ];

  static const List<String> _scriptFa = [
    r'[boot] راه‌اندازی هسته .......... اوکی',
    r'[boot] پروفایل حرارتی .......... پایدار',
    r'[boot] رابط عصبی ............... فعال',
    r'',
    r'هویت:: امیر طالبی',
    r'نام::: amirzx / cyberslayer',
    r'نقش::: لینوکس | شبکه | دواپس | کدنویسی',
    r'حال::: سای‌فای تاریک / متال / ریو',
    r'',
    r'-- نقشه سیستم --',
    r'سیستم‌عامل .... CachyOS x86_64',
    r'دستگاه ........ ThinkPad E15 Gen 2',
    r'کرنل .......... 6.18.8-1-cachyos',
    r'پردازنده ...... AMD Ryzen 5 4500U',
    r'گرافیک ........ Radeon Vega iGPU',
    r'رم ............ 14.35 گیگابایت',
    r'میزکار ........ KDE Plasma 6.5.5 | KWin Wayland',
    r'نمایشگر ....... 24 اینچ خارجی + 16 اینچ داخلی',
    r'',
    r'-- تخصص --',
    r'> بهینه‌سازی و عیب‌یابی لینوکس',
    r'> شبکه کانتینر و روتینگ سرویس‌ها',
    r'> DNS، ریورس پراکسی و سخت‌سازی زیرساخت',
    r'> اتوماسیون CI/CD و استقرار',
    r'> جریان کاری Bash، Python، Rust',
    r'',
    r'-- پروژه فعال --',
    r'پروژه ......... waydroid-image-sw',
    r'وضعیت ......... reborn/public',
    r'اثر ........... سوییچ سریع بین A13 و TV',
    r'',
    r'نقل‌قول> هسته مشکی. لبه قرمز. ابزار دقیق.',
    r'ارتباط> github.com/amir0zx',
    r'مکان> ایران',
    r'',
    r'root@cyberpad:~$ _',
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
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _restartTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _bgController.dispose();
    _pulseController.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _restartTyping() {
    _typingTimer?.cancel();
    _lines.clear();
    _step = 0;
    _typingTimer = Timer.periodic(const Duration(milliseconds: 70), (_) {
      final List<String> script = _isFa ? _scriptFa : _scriptEn;
      if (_step >= script.length) {
        _typingTimer?.cancel();
        return;
      }
      setState(() {
        _lines.add(script[_step]);
        _step += 1;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool compact = size.width < 980;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + _bgController.value * 0.5, -1),
                end: Alignment(1, 1 - _bgController.value * 0.4),
                colors: const [
                  Color(0xFF030304),
                  Color(0xFF13080B),
                  Color(0xFF080809),
                ],
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
                      compact ? 12 : 24, compact ? 16 : 26, compact ? 12 : 24, 16),
                  child: Column(
                    children: [
                      _TopBar(isFa: _isFa, compact: compact),
                      const SizedBox(height: 14),
                      Expanded(
                        child: compact
                            ? _TerminalPanel(
                                lines: _lines,
                                scroll: _scroll,
                                isFa: _isFa,
                                pulse: _pulseController,
                                onToggleLanguage: () {
                                  setState(() => _isFa = !_isFa);
                                  _restartTyping();
                                },
                              )
                            : Row(
                                children: [
                                  SizedBox(
                                    width: 320,
                                    child: _SideHud(
                                      isFa: _isFa,
                                      pulse: _pulseController,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: _TerminalPanel(
                                      lines: _lines,
                                      scroll: _scroll,
                                      isFa: _isFa,
                                      pulse: _pulseController,
                                      onToggleLanguage: () {
                                        setState(() => _isFa = !_isFa);
                                        _restartTyping();
                                      },
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xF0101012),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF7C0019), width: 1.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'AMIRZX // CYBERSLAYER',
              style: TextStyle(
                fontFamily: 'Orbitron',
                color: const Color(0xFFFF4A4A),
                fontSize: compact ? 14 : 18,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            isFa ? 'پرتفولیو ترمینالی' : 'terminal portfolio',
            style: TextStyle(
              fontFamily: isFa ? 'Vazirmatn' : 'JetBrains Mono',
              color: const Color(0xFFB4B4B4),
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
  final AnimationController pulse;

  const _SideHud({required this.isFa, required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xEE09090A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A000A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 120,
            child: CustomPaint(
              painter: _HudEmblemPainter(),
              size: const Size(double.infinity, 120),
            ),
          ),
          const SizedBox(height: 10),
          _HudTitle(text: isFa ? 'وضعیت شبکه' : 'network status'),
          const SizedBox(height: 8),
          _PulseBar(label: isFa ? 'latency' : 'latency', value: 0.35, pulse: pulse),
          _PulseBar(label: isFa ? 'throughput' : 'throughput', value: 0.82, pulse: pulse),
          _PulseBar(label: isFa ? 'uptime' : 'uptime', value: 0.94, pulse: pulse),
          const SizedBox(height: 12),
          _HudTitle(text: isFa ? 'حالت‌ها' : 'modes'),
          const SizedBox(height: 8),
          _Tag(text: isFa ? 'linux-first' : 'linux-first'),
          _Tag(text: isFa ? 'infra-ops' : 'infra-ops'),
          _Tag(text: isFa ? 'automation' : 'automation'),
          _Tag(text: isFa ? 'red-team-aesthetic' : 'red-team-aesthetic'),
          const Spacer(),
          Text(
            isFa ? 'build: neo-night // active' : 'build: neo-night // active',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF9D9D9D),
              fontFamily: isFa ? 'Vazirmatn' : 'JetBrains Mono',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _HudTitle extends StatelessWidget {
  final String text;
  const _HudTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFFF6262),
        fontFamily: 'JetBrains Mono',
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _PulseBar extends StatelessWidget {
  final String label;
  final double value;
  final Animation<double> pulse;

  const _PulseBar({required this.label, required this.value, required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, _) {
          final double amp = (value * (0.8 + pulse.value * 0.2)).clamp(0.0, 1.0);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFB6B6B6),
                  fontSize: 10,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  minHeight: 7,
                  value: amp,
                  backgroundColor: const Color(0xFF1A1A1C),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFF4040)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF140B0D),
        border: Border.all(color: const Color(0xFF4B1A22)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFF7A7A),
          fontFamily: 'JetBrains Mono',
          fontSize: 10.5,
        ),
      ),
    );
  }
}

class _TerminalPanel extends StatelessWidget {
  final List<String> lines;
  final ScrollController scroll;
  final bool isFa;
  final AnimationController pulse;
  final VoidCallback onToggleLanguage;

  const _TerminalPanel({
    required this.lines,
    required this.scroll,
    required this.isFa,
    required this.pulse,
    required this.onToggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isFa ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xEF070708),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2A0008)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const _Led(color: Color(0xFFFF3A3A)),
                const _Led(color: Color(0xFFFFA300)),
                const _Led(color: Color(0xFF44D36A)),
                const SizedBox(width: 10),
                Text(
                  isFa ? 'shell://fa.cyberpad' : 'shell://en.cyberpad',
                  style: const TextStyle(
                    color: Color(0xFFFF3A3A),
                    fontFamily: 'JetBrains Mono',
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onToggleLanguage,
                  child: Text(
                    isFa ? 'EN / فارسی' : 'فارسی / EN',
                    style: TextStyle(
                      color: const Color(0xFFFF6464),
                      fontFamily: isFa ? 'Vazirmatn' : 'JetBrains Mono',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF1A1A1A), height: 14),
            Expanded(
              child: ListView.builder(
                controller: scroll,
                itemCount: lines.length,
                itemBuilder: (context, index) => Text(
                  lines[index],
                  textAlign: isFa ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    color: const Color(0xFFFF5B5B),
                    fontFamily: isFa ? 'Vazirmatn' : 'JetBrains Mono',
                    fontSize: isFa ? 17 : 16.5,
                    height: 1.45,
                    shadows: const [
                      Shadow(color: Color(0x55FF0000), blurRadius: 7),
                    ],
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: pulse,
              builder: (context, _) {
                final double opacity = 0.4 + pulse.value * 0.6;
                return Align(
                  alignment: isFa ? Alignment.centerRight : Alignment.centerLeft,
                  child: Opacity(
                    opacity: opacity,
                    child: const Text(
                      '▋',
                      style: TextStyle(
                        color: Color(0xFFFF4040),
                        fontSize: 18,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
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
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withOpacity(0.45), blurRadius: 5)],
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
    final Paint red = Paint()..color = const Color(0x55FF3030);
    final Paint faint = Paint()..color = const Color(0x30FFFFFF);

    for (int i = 0; i < 90; i++) {
      final double x = ((i * 97.0) + t * 400.0) % size.width;
      final double y = ((i * 59.0) + t * 120.0) % size.height;
      final double r = 0.6 + (i % 4) * 0.28;
      canvas.drawCircle(Offset(x, y), r, i % 3 == 0 ? red : faint);
    }

    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = const Color(0x44FF2A2A);

    final Offset center = Offset(size.width * 0.78, size.height * 0.18);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 64),
      t * math.pi * 2,
      math.pi * 1.35,
      false,
      ring,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 92),
      -t * math.pi * 2,
      math.pi * 0.9,
      false,
      ring,
    );
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

class _HudEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    final Paint frame = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xCCFF4040);
    final Paint thin = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0x99FF6060);

    canvas.drawRRect(
      RRect.fromRectAndRadius(bounds, const Radius.circular(12)),
      frame,
    );
    canvas.drawLine(
      Offset(16, size.height * 0.5),
      Offset(size.width - 16, size.height * 0.5),
      thin,
    );

    final Offset c = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(c, 20, frame);
    canvas.drawCircle(c, 36, thin);
    canvas.drawLine(Offset(c.dx - 42, c.dy), Offset(c.dx + 42, c.dy), thin);
    canvas.drawLine(Offset(c.dx, c.dy - 42), Offset(c.dx, c.dy + 42), thin);

    final text = TextPainter(
      text: const TextSpan(
        text: 'CYBERSLAYER // CORE',
        style: TextStyle(
          color: Color(0xFFFF6A6A),
          fontSize: 12,
          fontFamily: 'JetBrains Mono',
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width - 24);
    text.paint(canvas, const Offset(12, 12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Scanlines extends StatelessWidget {
  const _Scanlines();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.08,
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
    final Paint paint = Paint()..color = Colors.white;
    for (double y = 0; y < size.height; y += 3.4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
