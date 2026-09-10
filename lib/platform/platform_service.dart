/// Mirrors GameCore/../Platform/PlatformService.swift's `HapticStyle` exactly.
enum HapticStyle { light, success, warning, levelUp }

/// UI/gameplay sound cues (spec: Button Click, Level Up, Loot, Summon, Skill,
/// Ultimate, Boss, Reward). Mirrors PlatformService.swift's `SoundEffect`
/// exactly. The battle cues (`skill`, `ultimate`, `bossEncounter`,
/// `bossVictory`) are backed by real composed audio files in `assets/audio/`
/// when a `FlutterPlatformService` is wired in — see that class.
enum SoundEffect { buttonTap, levelUp, loot, summon, skill, ultimate, bossEncounter, bossVictory, reward }

/// Lets `GameState.playHaptic` fire a matching sound automatically at every
/// existing haptic call site, instead of doubling up every call site by
/// hand. `.warning` (battle defeat) stays silent on purpose — a defeat
/// doesn't need a chime.
extension HapticStylePairedSound on HapticStyle {
  SoundEffect? get pairedSoundEffect {
    switch (this) {
      case HapticStyle.light:
        return SoundEffect.buttonTap;
      case HapticStyle.success:
        return SoundEffect.reward;
      case HapticStyle.warning:
        return null;
      case HapticStyle.levelUp:
        return SoundEffect.levelUp;
    }
  }
}

/// Everything game/UI code needs from the host OS, behind one seam — same
/// role as Swift's `PlatformService` protocol. No concrete Android (or
/// cross-platform) haptics/sound/local-notification plugin is wired in yet
/// (see the port plan's "Platform integration" phase); `NoopPlatformService`
/// below is the only implementation today, so every call is inert but
/// `GameState` is already written against this seam and fully testable.
/// Swapping in a real implementation later is a one-line change at the
/// `GameState.create` call site, nothing more.
abstract class PlatformService {
  void playHaptic(HapticStyle style);
  void playSound(SoundEffect effect);

  /// Asks the OS for local-notification permission if the player hasn't
  /// been asked before; resolves `false` without prompting if already
  /// denied.
  Future<bool> requestNotificationAuthorization();

  /// Schedules (replacing any pending request with the same `id`) a
  /// one-shot local notification for `fireDate`. Does nothing if `fireDate`
  /// is already in the past.
  void scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime fireDate,
  });

  /// Schedules a local notification that repeats every day at
  /// `hour:minute` in the device's current calendar/time zone.
  void scheduleDailyNotification({
    required String id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  });

  void cancelNotification(String id);
  void cancelAllNotifications();
}

/// Placeholder used until a real haptics/sound/notifications plugin is
/// wired in. Every call is a harmless no-op.
class NoopPlatformService implements PlatformService {
  @override
  void playHaptic(HapticStyle style) {}

  @override
  void playSound(SoundEffect effect) {}

  @override
  Future<bool> requestNotificationAuthorization() async => false;

  @override
  void scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime fireDate,
  }) {}

  @override
  void scheduleDailyNotification({
    required String id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) {}

  @override
  void cancelNotification(String id) {}

  @override
  void cancelAllNotifications() {}
}
