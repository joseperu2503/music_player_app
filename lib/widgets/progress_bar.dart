import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double percent; // 0 a 100
  final ValueChanged<double> onChangePercent;

  const ProgressBar({
    super.key,
    required this.percent,
    required this.onChangePercent,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 4,
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
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 3;
    final double trackWidth = parentBox.size.width; // usar todo el ancho
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
