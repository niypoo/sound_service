import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

import 'package:get/get.dart';

class SoundService extends GetxService {
  // define
  static SoundService get to => Get.find();

  // loaded sounds
  final Map<String, int> soundsLibrary = {};

  //play sound pool
  Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);

  // initializer
  Future<SoundService> init({List<String>? sounds}) async {
    // load all sounds
    await _load(sounds);

    return this;
  }

  // dispose sound
  dispose() {
    pool.dispose();
  }

  Future<void> _load(List<String>? files) async {
    // skip
    if (files == null || files.isEmpty) return;

    for (var file in files) {
      //load file
      ByteData soundData = await rootBundle.load(file);

      // get sound id
      int soundId = await pool.load(soundData);

      // inject sound in library with id
      soundsLibrary.addAll({file: soundId});
    }
  }

  // get sound from library
  int? _getFromLibrary(String path) {
    if (soundsLibrary.isEmpty) return null;
    if (!soundsLibrary.containsKey(path)) return null;

    // return int of sound
    return soundsLibrary[path];
  }

  // play from library
  Future<void> playFormLibrary(String path) async {
    // get sound id if it's loaded
    final int? soundId = _getFromLibrary(path);

    //play sound
    if (soundId != null) await pool.play(soundId);
  }

  Future<void> loadAndPlay(String file) async {
    //play sound pool
    Soundpool pool = Soundpool.fromOptions(options: SoundpoolOptions.kDefault);

    //load file
    ByteData soundData = await rootBundle.load(file);

    // get sound id
    int soundId = await pool.load(soundData);

    //play sound
    await pool.play(soundId);
  }
}
