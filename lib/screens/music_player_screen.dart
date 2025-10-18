import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.3; // Progreso simulado

  // Simula avance del progreso
  void _simulateProgress() {
    if (!isPlaying) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && isPlaying && progress < 1.0) {
        setState(() {
          progress += 0.02;
        });
        _simulateProgress();
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) _simulateProgress();
  }

  changeProgress(double value) {
    setState(() {
      progress = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = const Duration(minutes: 3, seconds: 45);
    final current = Duration(seconds: (duration.inSeconds * progress).round());

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1B),
      appBar: AppBar(
        title: const Text(
          "Now Playing",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDDDDDD),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          color: Colors.white,
          highlightColor: Colors.red,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.04),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFFDDDDDD),
            size: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen del álbum
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                "assets/cover.webp",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // Título y artista
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Blinding Lights",
                      style: TextStyle(
                        color: Color(0xffDFDFDF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "The Weeknd",
                      style: TextStyle(
                        color: Color(0xffBABABA),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_outline_rounded,
                    color: Color(0xFF6C6C6C),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            // Barra de progreso
            Column(
              children: [
                PercentSlider(
                  percent: progress,
                  onChangePercent: changeProgress,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(current),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      _formatDuration(duration),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Controles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.repeat_rounded,
                    color: Color(0xFF6D6D6D),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Color(0xffDFDFDF),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _togglePlayPause,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF42C83C),
                    shape: const CircleBorder(),
                    minimumSize: const Size(72, 72),
                  ),
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.skip_next,
                    color: Color(0xffDFDFDF),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shuffle_rounded,
                    color: Color(0xFF6D6D6D),
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

class PercentSlider extends StatelessWidget {
  final double percent; // 0 a 100
  final ValueChanged<double> onChangePercent;

  const PercentSlider({
    super.key,
    required this.percent,
    required this.onChangePercent,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
        trackShape: FullWidthTrackShape(),
      ),
      child: Slider(
        value: percent.clamp(0, 100),
        min: 0,
        max: 100,
        divisions: 100,
        onChanged: (value) {
          onChangePercent(value);
        },
        activeColor: const Color(0xffB7B7B7),
        inactiveColor: const Color(0xff888888).withOpacity(0.33),
      ),
    );
  }
}

class FullWidthTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 2;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width; // usar todo el ancho
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
