import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../state/player_name_service.dart';
import '../../theme/adaptive_scale.dart';
import '../../theme/theme.dart' as dk_theme;

/// Shown once, right after [StarterOlfChoiceView] resolves — locks in a
/// globally-unique player name via [PlayerNameService]. A simple glass-card
/// gate (not a cinematic full-screen moment like the starter-Olf choice),
/// matching `FriendsView`'s established convention of hardcoded English
/// screen text alongside German-only error strings sourced straight from
/// the service. Mirrors `PlayerNameChoiceView`
/// (UI/Onboarding/PlayerNameChoiceView.swift) exactly.
class PlayerNameChoiceView extends StatefulWidget {
  final PlayerNameService playerNameService;
  final ValueChanged<String> onChoose;
  const PlayerNameChoiceView({super.key, required this.playerNameService, required this.onChoose});

  @override
  State<PlayerNameChoiceView> createState() => _PlayerNameChoiceViewState();
}

class _PlayerNameChoiceViewState extends State<PlayerNameChoiceView> {
  final _nameController = TextEditingController();
  final _focusNode = FocusNode();
  bool _appeared = false;
  String? _claimErrorMessage;

  String? get _validationError =>
      _nameController.text.isEmpty ? null : PlayerNameService.validate(_nameController.text);

  bool get _canSubmit =>
      _nameController.text.isNotEmpty && _validationError == null && !widget.playerNameService.isClaiming;

  @override
  void initState() {
    super.initState();
    widget.playerNameService.addListener(_onServiceChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _appeared = true);
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    widget.playerNameService.removeListener(_onServiceChanged);
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    _focusNode.unfocus();
    setState(() => _claimErrorMessage = null);
    final result = await widget.playerNameService.claim(_nameController.text);
    if (!mounted) return;
    if (result.isSuccess) {
      widget.onChoose(result.name!);
    } else {
      setState(() => _claimErrorMessage = result.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final validationError = _validationError;
    // Re-centers the card in the space still visible above the keyboard
    // instead of staying centered on the full screen and running under it
    // — same math as `PlayerNameChoiceView.swift`'s `keyboardOffset`,
    // expressed in `.adaptiveScale()`'s 874x402 reference space so it scales
    // correctly once the whole view gets uniformly scaled to the real
    // screen size. Uses `rawKeyboardInset`, not `MediaQuery`'s `viewInsets`,
    // since the enclosing `Scaffold` has already zeroed that out here.
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = rawKeyboardInset(context);
    final keyboardOffset =
        (keyboardHeight > 0 && screenHeight > 0) ? (keyboardHeight / 2) / screenHeight * 402 : 0.0;
    return Semantics(
      container: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.78))),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: keyboardOffset),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              builder: (context, offset, child) => Transform.translate(offset: Offset(0, -offset), child: child),
              child: AnimatedOpacity(
              opacity: _appeared ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedScale(
                scale: _appeared ? 1 : 0.96,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: 380,
                  child: dk_theme.GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: dk_theme.Theme.gold.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: dk_theme.Theme.gold.withValues(alpha: 0.5), blurRadius: 14)],
                              ),
                            ),
                            const Icon(Icons.badge, size: 26, color: Colors.white),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text('Choose Your Name', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'This is how other Dreamkeepers will see you. Every name can only be claimed once.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.68), fontSize: 13, height: 1.35),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          focusNode: _focusNode,
                          autofocus: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9_]')),
                            LengthLimitingTextInputFormatter(PlayerNameService.maxLength),
                          ],
                          onChanged: (_) => setState(() {}),
                          onSubmitted: (_) => _submit(),
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.06),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: (validationError != null || _claimErrorMessage != null)
                                    ? Colors.red.withValues(alpha: 0.6)
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (validationError != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(validationError, style: TextStyle(color: Colors.red.withValues(alpha: 0.85), fontSize: 12)),
                          )
                        else if (_claimErrorMessage != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(_claimErrorMessage!, style: TextStyle(color: Colors.red.withValues(alpha: 0.85), fontSize: 12)),
                          )
                        else
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${PlayerNameService.minLength}–${PlayerNameService.maxLength} characters — letters, numbers, underscore.',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11),
                            ),
                          ),
                        const SizedBox(height: 16),
                        dk_theme.PrimaryButton(
                          onPressed: _canSubmit ? _submit : null,
                          tint: dk_theme.Theme.gold,
                          child: widget.playerNameService.isClaiming
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Confirm'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
          ),
        ],
      ),
    ).adaptiveScale();
  }
}
