import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../state/friends_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

/// Add friends by an 8-digit code, see their level/stage progress and
/// whether they're online right now. Backed by [FriendsService] (Firebase)
/// — shows a plain "not set up yet" card instead of any of the real content
/// when Firebase hasn't been configured for this build. Mirrors
/// `UI/Profile/FriendsView.swift` exactly, including its English screen
/// text alongside German-only error strings straight from `FriendsService`
/// (the Swift original never localized either) — the new one-time
/// referral-bonus banner below follows that same hardcoded-English
/// convention for consistency with the rest of this screen.
class FriendsView extends StatefulWidget {
  final GameState gameState;
  final FriendsService friendsService;
  final ValueChanged<AppRoute> onNavigate;
  const FriendsView({super.key, required this.gameState, required this.friendsService, required this.onNavigate});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  final _codeController = TextEditingController();
  Timer? _onlineTickTimer;
  bool _justEarnedReferralReward = false;
  bool _justCopiedCode = false;
  Timer? _justCopiedTimer;

  @override
  void initState() {
    super.initState();
    widget.friendsService.addListener(_onFriendsChanged);
    // Mirrors the Swift original's `TimelineView(.periodic(from: .now, by:
    // 15))` around the friends list — re-renders every 15s purely so each
    // `FriendRow`'s `isOnline` (computed from `DateTime.now()`) visibly
    // ticks over without needing a fresh Firestore snapshot.
    _onlineTickTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    widget.friendsService.removeListener(_onFriendsChanged);
    _onlineTickTimer?.cancel();
    _justCopiedTimer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  void _onFriendsChanged() {
    if (mounted) setState(() {});
  }

  /// Writes the code to the clipboard and flips a temporary "Copied!" state
  /// so tapping the icon visibly does something — before this, the tap
  /// silently succeeded (`Clipboard.setData` really does copy the code) but
  /// gave no feedback at all, which read as "copying doesn't work".
  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    _justCopiedTimer?.cancel();
    setState(() => _justCopiedCode = true);
    _justCopiedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _justCopiedCode = false);
    });
  }

  void _submitCode() {
    final code = _codeController.text;
    if (code.length != 8) return;
    FocusScope.of(context).unfocus();
    widget.friendsService.addFriend(code).then((added) {
      if (!added || !mounted) return;
      _codeController.clear();
      if (widget.friendsService.lastAddGrantedReferralReward) {
        widget.gameState.grantCurrency(
          gold: FriendsService.referralRewardGold,
          dreamGems: FriendsService.referralRewardGems,
        );
        setState(() => _justEarnedReferralReward = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsService = widget.friendsService;
    return Container(
      color: dk_theme.Theme.deepNavy,
      child: Column(
        children: [
          _header(),
          if (!friendsService.isConfigured)
            Expanded(child: _notConfiguredCard())
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _myCodeCard(),
                    const SizedBox(height: 16),
                    _addFriendCard(),
                    const SizedBox(height: 16),
                    _friendsListCard(),
                  ],
                ),
              ),
            ),
        ],
      ),
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
              onTap: () => widget.onNavigate(const ProfileRoute()),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
                child: const Icon(Icons.chevron_left, color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
          const Text('Friends', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          const SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }

  Widget _notConfiguredCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: dk_theme.GlassCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(sfSymbol('person.2.slash.fill'), size: 32, color: Colors.white.withValues(alpha: 0.4)),
                const SizedBox(height: 10),
                const Text(
                  "Friends Aren't Set Up Yet",
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  'This feature needs a one-time Firebase project setup. Once that\'s done, you\'ll be able to add friends by code here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myCodeCard() {
    final friendsService = widget.friendsService;
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your Friend Code', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          if (friendsService.myFriendCode != null)
            Row(
              children: [
                Text(
                  _formattedCode(friendsService.myFriendCode!),
                  style: const TextStyle(
                    color: dk_theme.Theme.gold,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const Spacer(),
                Semantics(
                  label: _justCopiedCode ? 'Code copied' : 'Copy code',
                  button: true,
                  child: GestureDetector(
                    onTap: () => _copyCode(friendsService.myFriendCode!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: _justCopiedCode ? dk_theme.Theme.gold.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _justCopiedCode ? sfSymbol('checkmark') : sfSymbol('doc.on.doc'),
                            size: 16,
                            color: _justCopiedCode ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.6),
                          ),
                          if (_justCopiedCode) ...[
                            const SizedBox(width: 5),
                            const Text('Copied!', style: TextStyle(color: dk_theme.Theme.gold, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text('Creating code…', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _addFriendCard() {
    final friendsService = widget.friendsService;
    final codeComplete = _codeController.text.length == 8;
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Add Friend', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            'Enter a friend\'s code — you both get a reward. Your first time only.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontFeatures: [FontFeature.tabularFigures()]),
                  decoration: InputDecoration(
                    hintText: '8-digit code',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: codeComplete && !friendsService.isAddingFriend ? _submitCode : null,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: codeComplete ? dk_theme.Theme.violet : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: friendsService.isAddingFriend
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Add', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          if (friendsService.lastError != null) ...[
            const SizedBox(height: 8),
            Text(
              friendsService.lastError!,
              style: TextStyle(color: Colors.red.withValues(alpha: 0.85), fontSize: 12),
            ),
          ],
          if (_justEarnedReferralReward) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(sfSymbol('gift.fill'), size: 14, color: dk_theme.Theme.gold),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Bonus! +${FriendsService.referralRewardGold} Gold, +${FriendsService.referralRewardGems} Dream Gems.',
                    style: const TextStyle(color: dk_theme.Theme.gold, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _friendsListCard() {
    final friends = widget.friendsService.friends;
    return dk_theme.GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Your Friends (${friends.length})', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          if (friends.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('No friends added yet.', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
            )
          else
            Column(
              children: [
                for (final friend in friends) ...[
                  _FriendRow(friend: friend),
                  if (friend != friends.last) const SizedBox(height: 8),
                ],
              ],
            ),
        ],
      ),
    );
  }

  String _formattedCode(String code) {
    if (code.length != 8) return code;
    return '${code.substring(0, 4)} ${code.substring(4)}';
  }
}

class _FriendRow extends StatelessWidget {
  final Friend friend;
  const _FriendRow({required this.friend});

  @override
  Widget build(BuildContext context) {
    final online = friend.isOnline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (online ? dk_theme.Theme.softBlue : Colors.white).withValues(alpha: online ? 0.22 : 0.06),
                  shape: BoxShape.circle,
                ),
              ),
              Icon(sfSymbol('person.fill'), size: 14, color: online ? dk_theme.Theme.softBlue : Colors.white.withValues(alpha: 0.4)),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Level ${friend.playerLevel}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              Text('Stage ${friend.currentStage}', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: online ? Colors.green : Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text(
                online ? 'Online' : 'Offline',
                style: TextStyle(color: online ? Colors.green : Colors.white.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
