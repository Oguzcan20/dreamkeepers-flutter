import 'package:flutter/material.dart';

import '../../platform/game_services_service.dart';
import '../../platform/google_sign_in_service.dart';
import '../../platform/platform_service.dart';
import '../../state/account_state.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

/// Settings screen: account (Google Sign-In) + Play Games cards,
/// audio/haptics/notification toggles, language switch, data-privacy note,
/// and a destructive reset-progress action. Mirrors UI/Settings/SettingsView.swift
/// — `gameCenterCard` is now `_gameServicesCard()` below, its one deliberate
/// difference being no friend count (the `games_services` package exposes
/// no equivalent API; see `GameServicesService`'s doc comment).
class SettingsView extends StatefulWidget {
  final GameState gameState;
  final AccountState accountState;
  final GameServicesService gameServicesService;
  final GoogleSignInService googleSignInService;
  final ValueChanged<AppRoute> onNavigate;

  const SettingsView({
    super.key,
    required this.gameState,
    required this.accountState,
    required this.gameServicesService,
    required this.googleSignInService,
    required this.onNavigate,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Mirrors `pubspec.yaml`'s `version: 1.0.0+1` — Flutter has no
  // `package_info_plus` dependency in this project yet (Swift's version
  // read `Bundle.main.infoDictionary` directly with no extra package), so
  // this is a small manually-kept literal rather than adding a whole
  // package for one label. Bump this alongside `pubspec.yaml`'s `version:`.
  static const _appVersion = '1.0.0 (1)';

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          title: const Text('Reset all progress?'),
          content: const Text("This deletes your Dreamkeepers, gold, gems, and campaign progress. This can't be undone."),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Reset Progress', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      widget.gameState.resetProgress();
      widget.onNavigate(const DreamHavenRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const dk_theme.AmbientBackground(topTint: dk_theme.Theme.softBlue, bottomTint: dk_theme.Theme.violet),
        SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: AnimatedBuilder(
                    animation: widget.gameState,
                    builder: (context, _) => Column(
                      children: [
                        _accountCard(),
                        const SizedBox(height: 14),
                        _gameServicesCard(),
                        const SizedBox(height: 14),
                        _toggleCard(
                          icon: 'speaker.wave.2.fill',
                          label: 'Sound Effects',
                          value: widget.gameState.soundEnabled,
                          onChanged: widget.gameState.setSoundEnabled,
                        ),
                        const SizedBox(height: 14),
                        _toggleCard(
                          icon: 'hand.tap.fill',
                          label: 'Haptics',
                          value: widget.gameState.hapticsEnabled,
                          onChanged: widget.gameState.setHapticsEnabled,
                        ),
                        const SizedBox(height: 14),
                        _notificationsCard(),
                        const SizedBox(height: 14),
                        _languageCard(),
                        const SizedBox(height: 14),
                        _dataCard(),
                        const SizedBox(height: 14),
                        _resetButton(),
                        const SizedBox(height: 10),
                        Text(
                          'Dreamkeepers · v$_appVersion',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Semantics(
            label: 'Back',
            button: true,
            child: GestureDetector(
              onTap: () => widget.onNavigate(const DreamHavenRoute()),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: const Icon(Icons.chevron_left, color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
          const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          const SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }

  Widget _accountCard() {
    return dk_theme.GlassCard(
      child: AnimatedBuilder(
        animation: widget.accountState,
        builder: (context, _) {
          if (widget.accountState.isSignedIn) {
            return Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: dk_theme.Theme.violet.withValues(alpha: 0.3), shape: BoxShape.circle),
                    ),
                    Icon(sfSymbol('person.crop.circle.fill'), color: Colors.white, size: 22),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.accountState.displayName ?? 'Dreamkeeper',
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text('Signed in', style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => widget.googleSignInService.signOut(widget.accountState),
                  child: Text('Sign Out', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                ),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(sfSymbol('person.crop.circle'), color: Colors.white, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Account', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to keep your progress recognizable across devices.',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => widget.googleSignInService.signIn(widget.accountState),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Sign in with Google', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Android counterpart to `SettingsView.swift`'s `gameCenterCard` —
  /// friend count is omitted (see this class's doc comment) but the
  /// signed-in/leaderboard structure otherwise matches exactly.
  Widget _gameServicesCard() {
    return dk_theme.GlassCard(
      child: AnimatedBuilder(
        animation: widget.gameServicesService,
        builder: (context, _) {
          final services = widget.gameServicesService;
          return Row(
            children: [
              Icon(sfSymbol('person.3.fill'), color: Colors.white, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Play Games', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      services.isAuthenticated ? (services.displayName ?? 'Signed in') : 'Not signed in',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (services.isAuthenticated)
                TextButton(
                  onPressed: () => services.showLeaderboard(GameLeaderboardService.campaignProgressID),
                  child: Text('Leaderboard', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 12, fontWeight: FontWeight.w600)),
                )
              else
                TextButton(
                  onPressed: services.authenticate,
                  child: Text('Sign In', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _toggleCard({
    required String icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return dk_theme.GlassCard(
      child: Row(
        children: [
          Icon(sfSymbol(icon), color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14))),
          Switch(value: value, onChanged: onChanged, activeColor: dk_theme.Theme.violet),
        ],
      ),
    );
  }

  Widget _notificationsCard() {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(sfSymbol('bell.fill'), color: Colors.white, size: 18),
              const SizedBox(width: 10),
              const Expanded(child: Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 14))),
              Switch(
                value: widget.gameState.notificationsEnabled,
                // The switch shows the tapped value immediately via
                // `setState`, then reflects whatever `notificationsEnabled`
                // ends up as once the permission request resolves — it
                // snaps back on its own if the player declines, same as
                // the Swift original's Binding.
                onChanged: (enabled) async {
                  setState(() {});
                  await widget.gameState.setNotificationsEnabled(enabled);
                  if (mounted) setState(() {});
                },
                activeColor: dk_theme.Theme.violet,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Get notified when the Gold Fountain or Training Garden is full, about daily missions, and when your Login Bonus is ready.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _languageCard() {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(sfSymbol('globe'), color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Text('Language', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _LanguageOptionButton(
                  title: 'Deutsch',
                  isSelected: widget.gameState.preferredLanguage == 'de',
                  onTap: () {
                    widget.gameState.setPreferredLanguage('de');
                    widget.gameState.playHaptic(HapticStyle.light);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _LanguageOptionButton(
                  title: 'English',
                  isSelected: widget.gameState.preferredLanguage != 'de',
                  onTap: () {
                    widget.gameState.setPreferredLanguage('en');
                    widget.gameState.playHaptic(HapticStyle.light);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dataCard() {
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(sfSymbol('lock.fill'), color: Colors.white, size: 16),
              const SizedBox(width: 8),
              const Text('Your Data', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Progress is stored on this device and, when a cloud account is available, synced privately to your other devices. Dreamkeepers doesn't collect or share personal data.",
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _resetButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: _confirmReset,
        style: TextButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.12),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text('Reset Progress', style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _LanguageOptionButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _LanguageOptionButton({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
