class Song {
  final String title;
  final String artist;
  final String cover;
  final String audio;

  Song({
    required this.title,
    required this.artist,
    required this.cover,
    required this.audio,
  });
}

final songs = [
  Song(
    title: "City Reflections Through My Window",
    artist: "Dreamer's Loft",
    cover: "assets/covers/cover1.png",
    audio: "assets/audios/audio1.mp3",
  ),
  Song(
    title: "Neon Lights and Solitary Nights",
    artist: "Rhythm & Rain",
    cover: "assets/covers/cover2.png",
    audio: "assets/audios/audio2.mp3",
  ),
  Song(
    title: "Lakeside Dawn Serenade",
    artist: "Echoes of the Mist",
    cover: "assets/covers/cover3.png",
    audio: "assets/audios/audio3.mp3",
  ),
];
