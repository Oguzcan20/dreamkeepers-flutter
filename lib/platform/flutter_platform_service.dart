import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'platform_service.dart';

/// Real haptics + composed battle audio for the Flutter/Android build —
/// the counterpart to iOS's `iOSPlatformService`.
///
/// Extends [NoopPlatformService] so the local-notification methods stay
/// harmless no-ops (a real scheduler needs `flutter_local_notifications`,
/// a separate piece of work); this class only fills in the two seams the
/// game actually leans on for feel — `playHaptic` and `playSound`.
///
/// The battle cues (`skill`, `ultimate`, `bossEncounter`, `bossVictory`)
/// are the real composed WAVs in `assets/audio/`, mirrored from the iOS
/// build. Every other `SoundEffect` is intentionally silent here (iOS
/// renders those via tiny system sounds that have no Android equivalent).
class FlutterPlatformService extends NoopPlatformService {
  FlutterPlatformService() {
    // SFX should mix under the player's own music, not seize audio focus.
    AudioPlayer.global.setAudioContext(
      AudioContextConfig(
        focus: AudioContextConfigFocus.mixWithOthers,
        route: AudioContextConfigRoute.system,
      ).build(),
    );
  }

  static const Map<SoundEffect, String> _asset = {
    SoundEffect.bossEncounter: 'audio/boss_encounter.wav',
    SoundEffect.bossVictory: 'audio/boss_victory.wav',
    SoundEffect.ultimate: 'audio/ultimate.wav',
    SoundEffect.skill: 'audio/skill.wav',
  };

  static double _volume(SoundEffect e) {
    switch (e) {
      case SoundEffect.bossEncounter:
        return 1.0;
      case SoundEffect.bossVictory:
        return 0.85;
      case SoundEffect.ultimate:
        return 0.9;
      case SoundEffect.skill:
        return 0.55;
      default:
        return 0.8;
    }
  }

  /// Small round-robin pool so back-to-back cues (two Ultimates) overlap
  /// instead of cutting each other off, without leaking a player per play.
  final List<AudioPlayer> _pool =
      List.generate(4, (i) => AudioPlayer()..setReleaseMode(ReleaseMode.stop));
  int _next = 0;

  @override
  void playHaptic(HapticStyle style) {
    switch (style) {
      case HapticStyle.light:
        HapticFeedback.lightImpact();
      case HapticStyle.success:
        HapticFeedback.mediumImpact();
      case HapticStyle.warning:
        HapticFeedback.heavyImpact();
      case HapticStyle.levelUp:
        HapticFeedback.heavyImpact();
    }
  }

  @override
  void playSound(SoundEffect effect) {
    final path = _asset[effect];
    if (path == null) return;
    final player = _pool[_next];
    _next = (_next + 1) % _pool.length;
    // Fire-and-forget; errors here must never break gameplay.
    player.stop().then((_) {
      player.play(AssetSource(path), volume: _volume(effect));
    }).catchError((_) {});
  }
}
