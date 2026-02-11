import 'dart:async';
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
        scaffoldBackgroundColor: const Color(0xFF0B0B0B),
        fontFamily: 'monospace',
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
    with SingleTickerProviderStateMixin {
  final List<String> _lines = [];
  final ScrollController _scroll = ScrollController();
  late Timer _timer;
  int _step = 0;
  bool _isFa = false;

  final List<String> _scriptEn = const [
    r'login: amirzx / cyberslayer',
    r'role: Linux · Networking · DevOps · Automation',
    r'vibe: red/black | metalhead | rave',
    r'--',
    r'system',
    r'  os: CachyOS x86_64',
    r'  host: ThinkPad E15 Gen 2 (20T80005US)',
    r'  kernel: 6.18.8-1-cachyos',
    r'  cpu: AMD Ryzen 5 4500U (6)',
    r'  gpu: AMD Radeon Vega (iGPU)',
    r'  ram: 14.35 GiB',
    r'  de: KDE Plasma 6.5.5 / KWin (Wayland)',
    r'  displays: 24" 1080p + 16" 1080p @1.5x',
    r'--',
    r'focus',
    r'  - container networking',
    r'  - DNS / reverse proxy',
    r'  - automation & CI/CD',
    r'  - Rust / Bash / Python',
    r'--',
    r'project: waydroid-image-sw',
    r'  status: public / reborn',
    r'  purpose: switch Waydroid images fast',
    r'--',
    r'quote: Black core. Red edge. Sharp tools.',
    r'location: Iran',
    r'contact: github.com/amir0zx',
  ];

  final List<String> _scriptFa = const [
    r'ورود: amirzx / cyberslayer',
    r'نقش: لینوکس · شبکه · دواپس · اتوماسیون',
    r'حال‌وهوا: قرمز/مشکی | متالهد | ریو',
    r'--',
    r'سیستم',
    r'  سیستم‌عامل: CachyOS x86_64',
    r'  لپ‌تاپ: ThinkPad E15 Gen 2 (20T80005US)',
    r'  کرنل: 6.18.8-1-cachyos',
    r'  پردازنده: AMD Ryzen 5 4500U (6)',
    r'  گرافیک: AMD Radeon Vega (iGPU)',
    r'  رم: 14.35 گیگ',
    r'  میزکار: KDE Plasma 6.5.5 / KWin (Wayland)',
    r'  نمایشگرها: 24" 1080p + 16" 1080p @1.5x',
    r'--',
    r'تمرکز',
    r'  - شبکه کانتینرها',
    r'  - DNS / ریورس‌پراکسی',
    r'  - اتوماسیون و CI/CD',
    r'  - Rust / Bash / Python',
    r'--',
    r'پروژه: waydroid-image-sw',
    r'  وضعیت: عمومی / تولد دوباره',
    r'  هدف: سوییچ سریع ایمیج‌های Waydroid',
    r'--',
    r'جمله: هستهٔ مشکی. لبهٔ قرمز. ابزارِ تیز.',
    r'مکان: ایران',
    r'ارتباط: github.com/amir0zx',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) => _tick());
  }

  @override
  void dispose() {
    _timer.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _tick() {
    final active = _isFa ? _scriptFa : _scriptEn;
    if (_step >= active.length) {
      return;
    }
    setState(() {
      _lines.add(active[_step]);
      _step++;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF070707), Color(0xFF0F0F0F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _Noise()),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: _Header(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
              child: _Terminal(
                lines: _lines,
                controller: _scroll,
                onToggleLanguage: () {
                  setState(() {
                    _isFa = !_isFa;
                    _lines.clear();
                    _step = 0;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB00020), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'amirzx / cyberslayer',
            style: TextStyle(
              color: Color(0xFFFF2A2A),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            'terminal_portfolio',
            style: TextStyle(
              color: Color(0xFF9A9A9A),
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Terminal extends StatelessWidget {
  final List<String> lines;
  final ScrollController controller;
  final VoidCallback onToggleLanguage;

  const _Terminal({
    required this.lines,
    required this.controller,
    required this.onToggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A0000), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Dot(color: const Color(0xFFFF2A2A)),
              _Dot(color: const Color(0xFFFFA800)),
              _Dot(color: const Color(0xFF00C853)),
              const SizedBox(width: 12),
              const Text(
                'root@cyberpad:~#',
                style: TextStyle(color: Color(0xFFFF2A2A)),
              ),
              const Spacer(),
              TextButton(
                onPressed: onToggleLanguage,
                child: const Text(
                  'فارسی / EN',
                  style: TextStyle(color: Color(0xFFB00020)),
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFF1F1F1F)),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: lines.length + 1,
              itemBuilder: (context, i) {
                if (i == lines.length) {
                  return const Text(
                    '_',
                    style: TextStyle(color: Color(0xFFB00020)),
                  );
                }
                return Text(
                  lines[i],
                  style: const TextStyle(
                    color: Color(0xFFE6E6E6),
                    fontSize: 14,
                    height: 1.4,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Noise extends StatefulWidget {
  @override
  State<_Noise> createState() => _NoiseState();
}

class _NoiseState extends State<_Noise> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Opacity(
          opacity: 0.06,
          child: CustomPaint(
            painter: _NoisePainter(_controller.value),
          ),
        );
      },
    );
  }
}

class _NoisePainter extends CustomPainter {
  final double seed;
  _NoisePainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFFFFFF);
    final count = (size.width * size.height / 3500).round();
    for (int i = 0; i < count; i++) {
      final dx = (seed * 997 + i * 37) % 1.0;
      final dy = (seed * 613 + i * 91) % 1.0;
      canvas.drawRect(
        Rect.fromLTWH(dx * size.width, dy * size.height, 1, 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) => true;
}
