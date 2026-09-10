// The live battle screen. Mirrors `BattleView` (UI/Battle/BattleView.swift)
// with its decorative layer simplified the same way Campaign/Summon
// simplified theirs: the cross-screen attack-projectile bolt (tracked via a
// `GeometryReader`/`PreferenceKey` frame system) and the elaborate
// multi-layer particle bursts are replaced with simpler, cheaper Flutter
// equivalents (a portrait ring flash, a floating damage number, a plain
// screen shake) — every actual combat mechanic (tick loop, targeting,
// damage, energy, Ultimate/Active Skill dispatch, boss mechanics, outcome)
// is untouched, all already ported in `BattleEngine`/`Combatant`.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../combat/battle_engine.dart';
import '../../combat/combatant.dart';
import '../../data/world_catalog.dart';
import '../../models/element.dart';
import '../../models/world.dart';
import '../../platform/platform_service.dart';
import '../../state/game_state.dart';
import '../../theme/sf_symbol_icons.dart';
import '../../theme/theme.dart' as dk_theme;
import '../root/app_route.dart';

/// Owns the `BattleEngine` for one Campaign stage fight (or Arena floor, via
/// [ArenaBattleScreen]) — built once in `initState` so navigating within the
/// battle (button taps, rebuilds) doesn't tear down and recreate it. A fresh
/// `BattleScreen` instance (and therefore a fresh engine) is created every
/// time `RootView` re-enters `BattleRoute` — including "Next Battle" from
/// `BattleResultView` — mirroring Swift's own lazy
/// `activeEngine == nil ? gameState.makeBattleEngine() : activeEngine`.
class BattleScreen extends StatefulWidget {
  final GameState gameState;
  final ValueChanged<AppRoute> onNavigate;

  const BattleScreen({super.key, required this.gameState, required this.onNavigate});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late final BattleEngine? _engine = widget.gameState.makeBattleEngine();

  @override
  Widget build(BuildContext context) {
    final engine = _engine;
    if (engine == null) {
      // No deployed team — shouldn't be reachable (Campaign only offers
      // "Fight" once a team is deployed), but bounce back to Dream Haven
      // rather than showing an empty battlefield.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onNavigate(const DreamHavenRoute());
      });
      return const SizedBox.shrink();
    }
    return BattleView(
      engine: engine,
      gameState: widget.gameState,
      onFinished: (finishedEngine) {
        final summary = widget.gameState.applyBattleResult(finishedEngine);
        widget.onNavigate(BattleResultRoute(summary));
      },
    );
  }
}

/// Owns the `BattleEngine` for one Arena Tower floor fight — same lazy,
/// widget-identity-driven pattern as [BattleScreen], but built from
/// `GameState.makeArenaBattleEngine(floor)` and carrying `floor` through to
/// `BattleView.arenaFloor` for the banner, and to
/// `GameState.applyArenaBattleResult` on finish. A fresh `ArenaBattleScreen`
/// (and therefore a fresh engine, against a possibly different floor) is
/// created every time `RootView` re-enters `ArenaBattleRoute` — including
/// "Fight Again" from `ArenaResultView`.
class ArenaBattleScreen extends StatefulWidget {
  final GameState gameState;
  final int floor;
  final ValueChanged<AppRoute> onNavigate;

  const ArenaBattleScreen({super.key, required this.gameState, required this.floor, required this.onNavigate});

  @override
  State<ArenaBattleScreen> createState() => _ArenaBattleScreenState();
}

class _ArenaBattleScreenState extends State<ArenaBattleScreen> {
  BattleEngine? _engine;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    // Unlike Campaign's `makeBattleEngine()` (a pure read), `makeArenaBattleEngine`
    // spends an Arena ticket and calls `GameState.persist()`, which
    // synchronously notifies this screen's own `ChangeNotifierProvider`
    // ancestor. Computing it eagerly as a `late final` field — first read
    // from this widget's own first `build()` — tries to rebuild that
    // ancestor while it's still mid-build-pass and crashes ("setState() or
    // markNeedsBuild() called during build"). Deferring it to right after
    // the first frame (same post-frame-callback convention `ArenaView`
    // already uses) keeps the ticket-spend and its notification fully
    // outside any build pass.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final engine = widget.gameState.makeArenaBattleEngine(widget.floor);
      if (mounted) {
        setState(() {
          _engine = engine;
          _resolved = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_resolved) return const SizedBox.shrink();
    final engine = _engine;
    if (engine == null) {
      // No deployed team, no tickets left, or an already-invalid floor —
      // shouldn't be reachable (`ArenaView.attemptFight` gates both), but
      // bounce back to the Arena hub rather than showing an empty battlefield.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onNavigate(const ArenaRoute());
      });
      return const SizedBox.shrink();
    }
    return BattleView(
      engine: engine,
      gameState: widget.gameState,
      arenaFloor: widget.floor,
      onFinished: (finishedEngine) {
        final summary = widget.gameState.applyArenaBattleResult(finishedEngine);
        widget.onNavigate(ArenaResultRoute(summary));
      },
    );
  }
}

/// The stateless-from-the-outside battle view itself — takes an
/// already-built `engine` so both a Campaign stage fight (`BattleScreen`)
/// and an Arena Tower fight (`ArenaBattleScreen`) can drive the exact same
/// widget, the same way Swift's `BattleView` is shared by both `.battle` and
/// `.arenaBattle` routes.
class BattleView extends StatefulWidget {
  final BattleEngine engine;
  final GameState gameState;

  /// Non-nil only for an Arena Tower fight — swaps the banner's world/stage
  /// text for the floor number instead. See Swift's own doc comment on this
  /// same field.
  final int? arenaFloor;
  final ValueChanged<BattleEngine> onFinished;

  const BattleView({
    super.key,
    required this.engine,
    required this.gameState,
    this.arenaFloor,
    required this.onFinished,
  });

  @override
  State<BattleView> createState() => _BattleViewState();
}

class _BattleViewState extends State<BattleView> with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _showOutcomeOverlay = false;
  Combatant? _ultimateShowcase;
  Timer? _ultimateTimer;
  HitEvent? _lastHandledHit;
  UltimateEvent? _lastHandledUltimate;

  late final AnimationController _shakeController;

  BattleEngine get _engine => widget.engine;
  GameState get _gameState => widget.gameState;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
    if (_engine.isBossStage) {
      _gameState.playSound(SoundEffect.bossEncounter);
    }
    _engine.addListener(_onEngineChanged);
    _startTicking();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ultimateTimer?.cancel();
    _shakeController.dispose();
    _engine.removeListener(_onEngineChanged);
    super.dispose();
  }

  void _startTicking() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _engine.tick(0.1 * _gameState.battleSpeedMultiplier);

      // Auto-Battle: fire every ready Dreamkeeper's Active Skill and
      // Ultimate on its own, the instant each is ready, rather than
      // waiting on a tap — same calls the buttons make.
      if (_gameState.autoBattleEnabled && _engine.outcome == null) {
        for (final unit in _engine.playerUnits) {
          if (!unit.isAlive) continue;
          if (unit.ultimateReady) _engine.activateUltimate(unit.id);
          if (unit.skillReady) _engine.activateSkill(unit.id);
        }
      }

      if (_engine.outcome != null && !_showOutcomeOverlay) {
        _timer?.cancel();
        _gameState.playHaptic(_engine.outcome == BattleOutcome.victory ? HapticStyle.success : HapticStyle.warning);
        if (_engine.outcome == BattleOutcome.victory && _engine.isBossStage) {
          _gameState.playSound(SoundEffect.bossVictory);
        }
        setState(() => _showOutcomeOverlay = true);
      }
    });
  }

  void _onEngineChanged() {
    if (!mounted) return;
    final hit = _engine.lastHit;
    if (hit != null && hit != _lastHandledHit) {
      _lastHandledHit = hit;
      _shakeController.forward(from: 0);
    }
    final ultimate = _engine.lastUltimate;
    if (ultimate != null && ultimate != _lastHandledUltimate) {
      _lastHandledUltimate = ultimate;
      _gameState.playSound(SoundEffect.ultimate);
      Combatant? caster;
      for (final c in _engine.combatants) {
        if (c.id == ultimate.casterID) {
          caster = c;
          break;
        }
      }
      if (caster != null) _triggerUltimateShowcase(caster);
    }
  }

  void _triggerUltimateShowcase(Combatant caster) {
    setState(() => _ultimateShowcase = caster);
    _ultimateTimer?.cancel();
    _ultimateTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _ultimateShowcase = null);
    });
  }

  String _stageLabel() {
    if (widget.arenaFloor != null) return 'Endless Trial · Floor ${widget.arenaFloor}';
    final world = WorldCatalog.world(_engine.stage);
    final stageInWorld = _engine.stage - world.firstStage + 1;
    if (_engine.isBossStage) return '${world.name} · Boss';
    return '${world.name} · $stageInWorld/${World.stagesPerWorld}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: const BoxDecoration(gradient: dk_theme.Theme.background)),
        SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([_engine, _shakeController]),
            builder: (context, _) {
              final dx = sin(_shakeController.value * pi * 3) * 8 * (1 - _shakeController.value);
              return Transform.translate(
                offset: Offset(dx, 0),
                child: Column(
                  children: [
                    _battleBanner(),
                    Expanded(child: _enemyArea()),
                    _partyRow(),
                  ],
                ),
              );
            },
          ),
        ),
        if (_ultimateShowcase != null) _UltimateShowcaseOverlay(combatant: _ultimateShowcase!),
        if (_showOutcomeOverlay && _engine.outcome != null)
          _OutcomeOverlay(outcome: _engine.outcome!, onContinue: () => widget.onFinished(_engine)),
      ],
    );
  }

  /// Landscape has almost no vertical room to spare, so this is a thin
  /// accent strip with the stage title overlaid on top of `BattleBanner`/
  /// `BossBattleBanner` key art (mirrors Swift's
  /// `Image(engine.isBossStage ? "BossBattleBanner" : "BattleBanner")`),
  /// darkened underneath the same tinted gradient as before so the strip
  /// reads as one unit rather than a bare cropped photo.
  Widget _battleBanner() {
    final isBoss = _engine.isBossStage;
    return Container(
      height: 44,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            isBoss ? dk_theme.SingletonArt.bossBattleBanner : dk_theme.SingletonArt.battleBanner,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isBoss
                    ? [Colors.red.withValues(alpha: 0.35), dk_theme.Theme.deepNavy.withValues(alpha: 0.9)]
                    : [dk_theme.Theme.violet.withValues(alpha: 0.22), dk_theme.Theme.deepNavy.withValues(alpha: 0.9)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _stageLabel(),
                    style: TextStyle(
                      color: isBoss ? Colors.red : Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                _battleControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Speed (1x/2x) and Auto-Battle toggles — tucked into the banner's
  /// trailing side so repeated stages can be blitzed through without
  /// hunting for a settings screen mid-fight.
  Widget _battleControls() {
    final speedIs2x = _gameState.battleSpeedMultiplier >= 2.0;
    final auto = _gameState.autoBattleEnabled;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: speedIs2x ? 'Battle speed 2x, tap for 1x' : 'Battle speed 1x, tap for 2x',
          button: true,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _gameState.setBattleSpeedMultiplier(speedIs2x ? 1.0 : 2.0);
                _gameState.playHaptic(HapticStyle.light);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: speedIs2x ? dk_theme.Theme.softBlue : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                speedIs2x ? '2x' : '1x',
                style: TextStyle(
                  color: speedIs2x ? Colors.black : Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Semantics(
          label: auto ? 'Auto-Battle on' : 'Auto-Battle off',
          button: true,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _gameState.setAutoBattleEnabled(!auto);
                _gameState.playHaptic(HapticStyle.light);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: auto ? dk_theme.Theme.gold : Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                sfSymbol('arrow.triangle.2.circlepath'),
                size: 14,
                color: auto ? Colors.black : Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _enemyArea() {
    if (_engine.enemyUnits.isEmpty) return const SizedBox.shrink();
    final enemy = _engine.enemyUnits.first;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 340,
          child: _CombatantBanner(combatant: enemy, lastHit: _engine.lastHit, lastMechanicTrigger: _engine.lastMechanicTrigger),
        ),
      ),
    );
  }

  Widget _partyRow() {
    final units = _engine.playerUnits;
    final enemyElement = _engine.enemyUnits.isNotEmpty ? _engine.enemyUnits.first.element : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < units.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            Expanded(
              child: _PartyMemberTile(
                combatant: units[i],
                lastHit: _engine.lastHit,
                lastSkillUse: _engine.lastSkillUse,
                lastUltimate: _engine.lastUltimate,
                enemyElement: enemyElement,
                onUltimate: () {
                  if (_engine.activateUltimate(units[i].id)) {
                    _gameState.playHaptic(HapticStyle.success);
                  }
                },
                onSkill: () {
                  if (_engine.activateSkill(units[i].id)) {
                    _gameState.playHaptic(HapticStyle.light);
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Enemy portrait + HP. Reacts to `lastHit` (attacker glow / hit flash /
/// floating damage number) and `lastMechanicTrigger` (a colored ring pulse)
/// — a simplified stand-in for Swift's much more elaborate multi-layer
/// particle bursts, restarted every time via a `TweenAnimationBuilder` keyed
/// to the firing event's own id.
class _CombatantBanner extends StatelessWidget {
  final Combatant combatant;
  final HitEvent? lastHit;
  final MechanicEvent? lastMechanicTrigger;

  const _CombatantBanner({required this.combatant, required this.lastHit, required this.lastMechanicTrigger});

  static const double _portraitSize = 120;

  @override
  Widget build(BuildContext context) {
    final hit = lastHit;
    final isTarget = hit != null && hit.targetID == combatant.id;
    final isAttacker = hit != null && hit.attackerID == combatant.id;
    final mechanicEvent = lastMechanicTrigger;
    final mechanic = mechanicEvent != null && mechanicEvent.targetID == combatant.id ? mechanicEvent.mechanic : null;

    return dk_theme.GlassCard(
      child: Row(
        children: [
          SizedBox(
            width: _portraitSize,
            height: _portraitSize,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                _portrait(),
                if (isAttacker)
                  TweenAnimationBuilder<double>(
                    key: ValueKey('atk-${hit.id}'),
                    tween: Tween(begin: 1, end: 0),
                    duration: const Duration(milliseconds: 320),
                    builder: (context, v, _) => Opacity(
                      opacity: v,
                      child: Container(
                        width: _portraitSize,
                        height: _portraitSize,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: combatant.element.color, width: 3.5)),
                      ),
                    ),
                  ),
                if (isTarget) ...[
                  TweenAnimationBuilder<double>(
                    key: ValueKey('hit-${hit.id}'),
                    tween: Tween(begin: 0.6, end: 0),
                    duration: const Duration(milliseconds: 350),
                    builder: (context, v, _) => Opacity(
                      opacity: v,
                      child: Container(width: _portraitSize, height: _portraitSize, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    key: ValueKey('dmg-${hit.id}'),
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 850),
                    builder: (context, t, _) => Opacity(
                      opacity: 1 - t,
                      child: Transform.translate(
                        offset: Offset(0, -34 - 40 * t),
                        child: Text(
                          '-${hit.amount}',
                          style: TextStyle(
                            color: hit.isElementAdvantage ? dk_theme.Theme.gold : Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (mechanic != null)
                  TweenAnimationBuilder<double>(
                    key: ValueKey('mech-${mechanicEvent!.id}'),
                    tween: Tween(begin: 1.0, end: 1.6),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, scale, _) => Opacity(
                      opacity: (1.6 - scale) / 0.6,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: _portraitSize,
                          height: _portraitSize,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: mechanic.triggerColor, width: 2)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(combatant.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                    ),
                    if (combatant.isBoss) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(999)),
                        child: const Text('BOSS', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                // Spells out the enemy's element in text, not just the
                // portrait ring's tint — the plain-language anchor each
                // party member's advantage/disadvantage badge reads against.
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(sfSymbol(combatant.element.symbol), size: 12, color: combatant.element.color),
                    const SizedBox(width: 4),
                    Text(combatant.element.displayName, style: TextStyle(color: combatant.element.color, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 6),
                _HPBar(fraction: combatant.hpFraction, tint: combatant.isBoss ? Colors.red : dk_theme.Theme.softBlue, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _portrait() {
    final tint = combatant.isBoss ? Colors.red : combatant.element.color;
    return Container(
      width: _portraitSize,
      height: _portraitSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tint.withValues(alpha: 0.35),
        border: Border.all(color: tint.withValues(alpha: 0.6), width: combatant.isBoss ? 3 : 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        sfSymbol(combatant.symbol ?? (combatant.isBoss ? 'flame.fill' : combatant.element.symbol)),
        size: _portraitSize * 0.38,
        color: Colors.white,
      ),
    );
  }
}

/// One deployed Dreamkeeper's portrait, HP, and Active Skill/Ultimate
/// buttons. Reacts to `lastHit`/`lastSkillUse`/`lastUltimate` with the same
/// simplified flash treatment as `_CombatantBanner`.
class _PartyMemberTile extends StatelessWidget {
  final Combatant combatant;
  final HitEvent? lastHit;
  final SkillEvent? lastSkillUse;
  final UltimateEvent? lastUltimate;

  /// The single enemy's element (there's only ever one — see
  /// `BattleEngine._pickTarget`), used to badge this Dreamkeeper's own
  /// elemental advantage/disadvantage directly on its portrait.
  final GameElement? enemyElement;
  final VoidCallback onUltimate;
  final VoidCallback onSkill;

  const _PartyMemberTile({
    required this.combatant,
    required this.lastHit,
    required this.lastSkillUse,
    required this.lastUltimate,
    required this.enemyElement,
    required this.onUltimate,
    required this.onSkill,
  });

  static const double _portraitSize = 64;

  (String, Color)? get _advantageBadge {
    final enemy = enemyElement;
    if (enemy == null) return null;
    final multiplier = combatant.element.multiplier(enemy);
    if (multiplier > 1.0) return ('arrowtriangle.up.fill', Colors.green);
    if (multiplier < 1.0) return ('arrowtriangle.down.fill', Colors.red);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final hit = lastHit;
    final isTarget = hit != null && hit.targetID == combatant.id;
    final isAttacker = hit != null && hit.attackerID == combatant.id;
    final skill = lastSkillUse;
    final skillFlash = skill != null && skill.casterID == combatant.id;
    final ultimate = lastUltimate;
    final ultimateFlash = ultimate != null && ultimate.casterID == combatant.id;
    final badge = _advantageBadge;

    return Opacity(
      opacity: combatant.isAlive ? 1 : 0.4,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: dk_theme.Theme.cardStroke),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _portraitSize + 12,
              height: _portraitSize,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: _portraitSize,
                    height: _portraitSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: combatant.isAlive ? combatant.element.color.withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.05),
                      border: Border.all(color: combatant.element.color.withValues(alpha: 0.5), width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Icon(sfSymbol(combatant.role.symbol),
                        size: _portraitSize * 0.4, color: combatant.isAlive ? Colors.white : Colors.white.withValues(alpha: 0.3)),
                  ),
                  if (isAttacker)
                    TweenAnimationBuilder<double>(
                      key: ValueKey('atk-${hit.id}'),
                      tween: Tween(begin: 1, end: 0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, v, _) => Opacity(
                        opacity: v,
                        child: Container(
                            width: _portraitSize,
                            height: _portraitSize,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: combatant.element.color, width: 3))),
                      ),
                    ),
                  if (isTarget) ...[
                    TweenAnimationBuilder<double>(
                      key: ValueKey('hit-${hit.id}'),
                      tween: Tween(begin: 0.6, end: 0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, v, _) => Opacity(
                        opacity: v,
                        child: Container(width: _portraitSize, height: _portraitSize, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      key: ValueKey('dmg-${hit.id}'),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 700),
                      builder: (context, t, _) => Opacity(
                        opacity: 1 - t,
                        child: Transform.translate(
                          offset: Offset(0, -22 - 28 * t),
                          child: Text('-${hit.amount}',
                              style: TextStyle(color: hit.isElementAdvantage ? dk_theme.Theme.gold : Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                        ),
                      ),
                    ),
                  ],
                  if (skillFlash)
                    TweenAnimationBuilder<double>(
                      key: ValueKey('skill-${skill.id}'),
                      tween: Tween(begin: 0.9, end: 0),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, v, _) => Opacity(
                        opacity: v,
                        child: Container(
                            width: _portraitSize,
                            height: _portraitSize,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: dk_theme.Theme.softBlue, width: 3))),
                      ),
                    ),
                  if (ultimateFlash)
                    TweenAnimationBuilder<double>(
                      key: ValueKey('ult-${ultimate.id}'),
                      tween: Tween(begin: 1.0, end: 1.5),
                      duration: const Duration(milliseconds: 700),
                      builder: (context, scale, _) => Opacity(
                        opacity: (1.5 - scale) / 0.5,
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                              width: _portraitSize,
                              height: _portraitSize,
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: dk_theme.Theme.gold, width: 2))),
                        ),
                      ),
                    ),
                  if (badge != null)
                    Positioned(
                      right: 2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, color: badge.$2, border: Border.all(color: dk_theme.Theme.deepNavy.withValues(alpha: 0.6))),
                        child: Icon(sfSymbol(badge.$1), size: 9, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: _portraitSize + 12,
              child: Text(
                combatant.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withValues(alpha: combatant.isAlive ? 0.85 : 0.4), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(width: _portraitSize, child: _HPBar(fraction: combatant.hpFraction, tint: combatant.element.color, height: 6)),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: 'bolt.fill',
                  ready: combatant.activeSkill != null && combatant.skillReady && combatant.isAlive,
                  tint: dk_theme.Theme.softBlue,
                  semanticLabel: 'Active Skill',
                  onTap: (combatant.activeSkill != null && combatant.skillReady && combatant.isAlive) ? onSkill : null,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: 'sparkles',
                  ready: combatant.ultimateReady && combatant.isAlive,
                  tint: dk_theme.Theme.gold,
                  semanticLabel: 'Ultimate',
                  onTap: (combatant.ultimateReady && combatant.isAlive) ? onUltimate : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final bool ready;
  final Color tint;
  final String semanticLabel;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.ready, required this.tint, required this.semanticLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(color: ready ? tint : Colors.white.withValues(alpha: 0.08), shape: BoxShape.circle),
          child: Icon(sfSymbol(icon), size: 14, color: ready ? Colors.black : Colors.white.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}

class _HPBar extends StatelessWidget {
  final double fraction;
  final Color tint;
  final double height;

  const _HPBar({required this.fraction, required this.tint, required this.height});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(height: height, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999))),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: height,
              width: constraints.maxWidth * fraction.clamp(0, 1),
              decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(999)),
            ),
          ],
        );
      },
    );
  }
}

/// Shown once per Ultimate cast: a centered, scaled-in glowing portrait —
/// the primary "something big just happened, and it was them" cue. A
/// simplified stand-in for Swift's spinning dashed ring + two-layer
/// outward icon burst.
class _UltimateShowcaseOverlay extends StatelessWidget {
  final Combatant combatant;

  const _UltimateShowcaseOverlay({required this.combatant});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          key: ValueKey('showcase-${combatant.id}'),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          builder: (context, t, child) => Container(
            color: Colors.black.withValues(alpha: 0.45 * t),
            alignment: Alignment.center,
            child: Opacity(
              opacity: t,
              child: Transform.scale(scale: 0.3 + 0.7 * t, child: child),
            ),
          ),
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: combatant.element.color.withValues(alpha: 0.45),
              border: Border.all(color: combatant.element.color, width: 4),
              boxShadow: [BoxShadow(color: combatant.element.color.withValues(alpha: 0.7), blurRadius: 30)],
            ),
            alignment: Alignment.center,
            child: Icon(sfSymbol(combatant.role.symbol), size: 60, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _OutcomeOverlay extends StatelessWidget {
  final BattleOutcome outcome;
  final VoidCallback onContinue;

  const _OutcomeOverlay({required this.outcome, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final isVictory = outcome == BattleOutcome.victory;
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.55),
        alignment: Alignment.center,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, scale, child) => Opacity(opacity: ((scale - 0.85) / 0.15).clamp(0, 1), child: Transform.scale(scale: scale, child: child)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isVictory ? 'Victory!' : 'Defeat...',
                style: TextStyle(color: isVictory ? dk_theme.Theme.gold : Colors.red, fontWeight: FontWeight.w900, fontSize: 34),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: dk_theme.PrimaryButton(
                  tint: isVictory ? dk_theme.Theme.violet : Colors.grey,
                  onPressed: onContinue,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
