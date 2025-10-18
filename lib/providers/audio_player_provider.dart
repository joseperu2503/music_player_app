import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/data/songs.dart';

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(AudioPlayerState()) {
    init();
  }

  final AudioPlayer player = AudioPlayer();

  void init() async {
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,

      // Specify the playlist items
      children: songs.map((song) => AudioSource.asset(song.audio)).toList(),
    );

    await player.setAudioSource(
      playlist,
      initialIndex: state.currentIndex,
      initialPosition: Duration.zero,
    );

    // Escuchar cambios de playerState (play/pause/stop)
    player.playerStateStream.listen((playerState) {
      // Llamar a state = state para que Riverpod reconstruya
      state = state.copyWith(isPlaying: playerState.playing);
    });

    // Escuchar posición y progreso
    player.positionStream.listen((position) {
      state = state.copyWith(currentPosition: position);
    });

    // Escuchar cambios de duración (por si cambia el asset)
    player.durationStream.listen((duration) {
      state = state.copyWith(totalDuration: duration);
    });

    player.currentIndexStream.listen((index) {
      if (index != null) {
        state = state.copyWith(currentIndex: index);
      }
    });

    player.shuffleModeEnabledStream.listen((shuffled) {
      state = state.copyWith(shuffled: shuffled);
    });

    player.loopModeStream.listen((repeat) {
      state = state.copyWith(repeat: repeat);
    });

    player.shuffleIndicesStream.listen((shuffleIndices) {
      state = state.copyWith(shuffleIndices: shuffleIndices);
    });
  }

  nextSong() {
    player.seekToNext();
  }

  previousSong() {
    player.seekToPrevious();
  }

  Future<void> play() => player.play();
  Future<void> pause() => player.pause();

  toggleShuffle() {
    final bool shuffled = !state.shuffled;
    player.setShuffleModeEnabled(shuffled);
  }

  void toggleRepeat() {
    final LoopMode nextMode;

    if (state.repeat == LoopMode.off) {
      nextMode = LoopMode.one;
    } else if (state.repeat == LoopMode.one) {
      nextMode = LoopMode.all;
    } else {
      nextMode = LoopMode.off;
    }

    player.setLoopMode(nextMode);
  }

  changeProgress(double value) {
    player.seek(
      Duration(
        milliseconds:
            (value * state.totalDuration.inMilliseconds / 100).round(),
      ),
    );
  }

  changeSong(int index) {
    player.seek(Duration.zero, index: state.orderedIndices[index]);
  }
}

class AudioPlayerState {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final bool shuffled;
  final LoopMode repeat;
  final int currentIndex;
  final List<int> shuffleIndices;

  AudioPlayerState({
    this.isPlaying = false,
    this.currentPosition = const Duration(),
    this.totalDuration = const Duration(),
    this.shuffled = false,
    this.repeat = LoopMode.off,
    this.currentIndex = 0,
    this.shuffleIndices = const [],
  });

  double get progress {
    if (totalDuration.inMilliseconds == 0) return 0;
    return 100 * currentPosition.inMilliseconds / totalDuration.inMilliseconds;
  }

  List<Song> get sequence {
    // Si no está en shuffle o no hay índices, devolvemos la lista original (inmutable)
    if (!shuffled) return List.unmodifiable(songs);

    final List<Song> ordered = [];

    for (final idx in shuffleIndices) {
      if (idx >= 0 && idx < songs.length) {
        ordered.add(songs[idx]);
      }
    }

    return ordered;
  }

  int get realIndex {
    return orderedIndices.indexOf(currentIndex);
  }

  List<int> get orderedIndices {
    if (!shuffled) {
      return List.generate(sequence.length, (i) => i);
    }

    return shuffleIndices;
  }

  get currentSong => songs[currentIndex];

  AudioPlayerState copyWith({
    bool? isPlaying,
    Duration? currentPosition,
    Duration? totalDuration,
    bool? shuffled,
    LoopMode? repeat,
    int? currentIndex,
    List<int>? shuffleIndices,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      shuffled: shuffled ?? this.shuffled,
      repeat: repeat ?? this.repeat,
      currentIndex: currentIndex ?? this.currentIndex,
      shuffleIndices: shuffleIndices ?? this.shuffleIndices,
    );
  }
}
