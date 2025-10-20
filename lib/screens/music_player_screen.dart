import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/constants/app_icons.dart';
import 'package:music_player_app/providers/audio_player_provider.dart';
import 'package:music_player_app/widgets/progress_bar.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = ref.watch(audioPlayerProvider);

    final current = audioPlayer.currentPosition;
    final duration = audioPlayer.totalDuration;
    final isPlaying = audioPlayer.isPlaying;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            audioPlayer.currentSong.cover,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
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
              style: IconButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              icon: SvgPicture.asset(
                AppIcons.arrowBack,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFDDDDDD),
                  BlendMode.srcIn,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  AppIcons.moreVert,
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFDDDDDD),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 16),
              SongCoverSwiper(
                covers: audioPlayer.sequence.map((song) => song.cover).toList(),
                index: audioPlayer.realIndex,
                onIndexChanged: (i) {
                  ref.read(audioPlayerProvider.notifier).changeSong(i);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Título y artista
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                audioPlayer.currentSong.title,
                                style: const TextStyle(
                                  color: Color(0xffDFDFDF),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                audioPlayer.currentSong.artist,
                                style: const TextStyle(
                                  color: Color(0xffBABABA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            AppIcons.heart,
                            width: 24,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF6C6C6C),
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Barra de progreso
                    Column(
                      children: [
                        ProgressBar(
                          percent: audioPlayer.progress,
                          onChangePercent: ref
                              .read(audioPlayerProvider.notifier)
                              .changeProgress,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(current),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
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
                          onPressed: () {
                            ref
                                .read(audioPlayerProvider.notifier)
                                .toggleRepeat();
                          },
                          icon: SvgPicture.asset(
                            audioPlayer.repeat == LoopMode.one
                                ? AppIcons.repeatOne
                                : AppIcons.repeat,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              audioPlayer.repeat == LoopMode.all ||
                                      audioPlayer.repeat == LoopMode.one
                                  ? const Color(0xffDFDFDF)
                                  : const Color(0xFF6D6D6D),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(audioPlayerProvider.notifier)
                                .previousSong();
                          },
                          icon: SvgPicture.asset(
                            AppIcons.previous,
                            width: 26,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFDFDFDF),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {
                            if (isPlaying) {
                              ref.read(audioPlayerProvider.notifier).pause();
                            } else {
                              ref.read(audioPlayerProvider.notifier).play();
                            }
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            minimumSize: const Size(72, 72),
                          ),
                          icon: SvgPicture.asset(
                            isPlaying ? AppIcons.pause : AppIcons.play,
                            width: 32,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF1C1B1B),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {
                            ref.read(audioPlayerProvider.notifier).nextSong();
                          },
                          icon: SvgPicture.asset(
                            AppIcons.next,
                            width: 26,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFDFDFDF),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(audioPlayerProvider.notifier)
                                .toggleShuffle();
                          },
                          icon: SvgPicture.asset(
                            AppIcons.shuffle,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              audioPlayer.shuffled
                                  ? const Color(0xffDFDFDF)
                                  : const Color(0xFF6D6D6D),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

class SongCoverSwiper extends StatefulWidget {
  final List<String> covers;
  final int index;
  final ValueChanged<int>? onIndexChanged;

  const SongCoverSwiper({
    super.key,
    required this.covers,
    this.index = 0,
    this.onIndexChanged,
  });

  @override
  State<SongCoverSwiper> createState() => _SongCoverSwiperState();
}

class _SongCoverSwiperState extends State<SongCoverSwiper> {
  final SwiperController controller = SwiperController();

  @override
  void didUpdateWidget(covariant SongCoverSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si el índice inicial cambió externamente, movemos el swiper
    if (widget.index != oldWidget.index) {
      controller.move(widget.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Swiper(
        controller: controller,
        itemCount: widget.covers.length,
        onIndexChanged: widget.onIndexChanged,
        viewportFraction: (MediaQuery.of(context).size.width - 40) /
            (MediaQuery.of(context).size.width),
        scale: 0.8,
        loop: false,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              widget.covers[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
