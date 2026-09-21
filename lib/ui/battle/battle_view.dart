// The live battle screen. Mirrors `BattleView` (UI/Battle/BattleView.swift).
// The decorative layer is a lighter Flutter equivalent of native's
// elaborate multi-layer particle system, not a pixel-for-pixel port: a
// cross-screen attack-projectile bolt (tracked via `GlobalKey`/`RenderBox`
// instead of native's `GeometryReader`/`PreferenceKey`) plus an impact burst
// at the target, a portrait ring flash, a floating damage number, a
// boss-hit whole-screen color flash, and a weight-scaled screen shake.
// Every actual combat mechanic (tick loop, targeting, damage, energy,
// Ultimate/Active Skill dispatch, boss mechanics, outcome) is untouched,
// all already ported in `BattleEngine`/`Combatant`.

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../combat/battle_engine.dart';
import '../../combat/combatant.dart';
import '../../combat/dungeon_system.dart';
import '../../data/world_catalog.dart';
import '../../l10n/l10n.dart';
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

/// Owns the `BattleEngine` for one Dungeon run — same deferred,
/// post-frame-callback pattern as [ArenaBattleScreen] (building the engine
/// spends a Dungeon Key and calls `GameState.persist()`, which can't happen
/// mid-build), carrying `dungeon` through to `BattleView.dungeonName` for the
/// wave banner and to `GameState.applyDungeonBattleResult` on finish.
class DungeonBattleScreen extends StatefulWidget {
  final GameState gameState;
  final DungeonId dungeon;
  final ValueChanged<AppRoute> onNavigate;

  const DungeonBattleScreen({super.key, required this.gameState, required this.dungeon, required this.onNavigate});

  @override
  State<DungeonBattleScreen> createState() => _DungeonBattleScreenState();
}

class _DungeonBattleScreenState extends State<DungeonBattleScreen> {
  BattleEngine? _engine;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final engine = widget.gameState.makeDungeonBattleEngine(widget.dungeon);
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onNavigate(const DungeonRoute());
      });
      return const SizedBox.shrink();
    }
    return BattleView(
      engine: engine,
      gameState: widget.gameState,
      dungeonName: DungeonSystem.displayName(widget.dungeon),
      onFinished: (finishedEngine) {
        final summary = widget.gameState.applyDungeonBattleResult(finishedEngine, widget.dungeon);
        widget.onNavigate(DungeonResultRoute(summary));
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

  /// Non-nil only for a Dungeon run — swaps the banner text for the dungeon
  /// name plus a "Wave X/Y" counter.
  final String? dungeonName;
  final ValueChanged<BattleEngine> onFinished;

  const BattleView({
    super.key,
    required this.engine,
    required this.gameState,
    this.arenaFloor,
    this.dungeonName,
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
  SkillEvent? _lastHandledSkill;

  late final AnimationController _shakeController;
  double _shakeMagnitude = 8;

  /// The bolt's own coordinate space, and each combatant portrait's key
  /// within it — lets `_fireProjectile` find real screen positions to fly
  /// a bolt between, the same job native's `GeometryReader`/
  /// `CombatantFramePreferenceKey` does, just measured on demand via
  /// `RenderBox` instead of tracked every frame.
  final GlobalKey _battlefieldKey = GlobalKey();
  final Map<String, GlobalKey> _portraitKeys = {};
  GlobalKey _portraitKeyFor(String id) => _portraitKeys.putIfAbsent(id, () => GlobalKey());

  _AttackProjectile? _attackProjectile;
  _ImpactBurst? _impactBurst;
  Timer? _projectileTimer;
  Timer? _impactTimer;
  Color _bossFlashColor = Colors.transparent;

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
    _projectileTimer?.cancel();
    _impactTimer?.cancel();
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
      _gameState.playSound(SoundEffect.attack);

      Combatant? attacker;
      for (final c in _engine.combatants) {
        if (c.id == hit.attackerID) {
          attacker = c;
          break;
        }
      }
      final isBossHit = attacker?.isBoss ?? false;
      final isBig = hit.isElementAdvantage || isBossHit;

      // A boss's own hit gets a visibly heavier jolt than the same generic
      // tap every other combatant plays — mirrors native's split between a
      // regular and a boss-weight shake.
      _shakeMagnitude = isBossHit ? 16 : (isBig ? 11 : 8);
      _shakeController.forward(from: 0);

      if (isBossHit) _flashBossHit(hit.attackerElement);
      _fireProjectile(hit: hit, attackerSymbol: attacker?.symbol, isBig: isBig);
    }
    final skill = _engine.lastSkillUse;
    if (skill != null && skill != _lastHandledSkill) {
      // Fires for both manual taps and Auto-Battle, same as the Ultimate
      // sound below — a short, quiet cast blip.
      _lastHandledSkill = skill;
      _gameState.playSound(SoundEffect.skill);
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

  /// A boss landing its own blow gets a brief whole-screen tint in its
  /// element's color — reads even if the player's eyes are on their own
  /// party's HP bars, not the boss's corner of the screen. Mirrors native's
  /// `bossFlashColor`/`bossFlashOpacity`.
  void _flashBossHit(GameElement element) {
    setState(() => _bossFlashColor = element.color.withValues(alpha: 0.22));
    Timer(const Duration(milliseconds: 260), () {
      if (mounted) setState(() => _bossFlashColor = Colors.transparent);
    });
  }

  /// Center of `id`'s own portrait, in `_battlefieldKey`'s coordinate space
  /// — `null` until that portrait has actually been laid out once (first
  /// frame, or the tile isn't currently mounted).
  Offset? _centerOf(String id) {
    final box = _portraitKeys[id]?.currentContext?.findRenderObject() as RenderBox?;
    final battlefieldBox = _battlefieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || battlefieldBox == null || !battlefieldBox.hasSize) return null;
    return battlefieldBox.globalToLocal(box.localToGlobal(box.size.center(Offset.zero)));
  }

  /// A glowing bolt of the attacker's own element flying from the
  /// attacker's portrait to the target's the instant a hit lands, followed
  /// by an impact burst where it lands — the clearest possible "who is
  /// attacking whom" cue, and the one effect native has that no per-portrait
  /// flash alone can substitute for. Positions are measured post-frame so
  /// both portraits have already been laid out for this tick.
  void _fireProjectile({required HitEvent hit, required String? attackerSymbol, required bool isBig}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final start = _centerOf(hit.attackerID);
      final end = _centerOf(hit.targetID);
      if (start == null || end == null) return;
      final symbol = attackerSymbol ?? hit.attackerElement.symbol;
      setState(() {
        _attackProjectile = _AttackProjectile(
          id: hit.id,
          start: start,
          end: end,
          color: hit.attackerElement.color,
          symbol: symbol,
          big: isBig,
        );
      });
      _projectileTimer?.cancel();
      _projectileTimer = Timer(const Duration(milliseconds: 180), () {
        if (!mounted) return;
        setState(() {
          _attackProjectile = null;
          _impactBurst = _ImpactBurst(id: hit.id, point: end, color: hit.attackerElement.color, symbol: symbol, big: isBig);
        });
        _impactTimer?.cancel();
        _impactTimer = Timer(Duration(milliseconds: isBig ? 420 : 300), () {
          if (mounted) setState(() => _impactBurst = null);
        });
      });
    });
  }

  String _stageLabel() {
    final l = AppLocalizations.of(context);
    if (widget.dungeonName != null) {
      return l.dungeonBattleLabel(widget.dungeonName!, _engine.currentWave, _engine.totalWaves);
    }
    if (widget.arenaFloor != null) return l.battleArenaStageLabel(widget.arenaFloor!);
    final world = WorldCatalog.world(_engine.stage);
    final stageInWorld = _engine.stage - world.firstStage + 1;
    if (_engine.isBossStage) return l.battleWorldBossLabel(world.name);
    return l.battleWorldStageLabel(world.name, stageInWorld, World.stagesPerWorld);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _battlefieldKey,
      children: [
        _battleBackdrop(),
        AnimatedBuilder(
          animation: Listenable.merge([_engine, _shakeController]),
          builder: (context, _) {
            final dx = sin(_shakeController.value * pi * 3) * _shakeMagnitude * (1 - _shakeController.value);
            return Transform.translate(
              offset: Offset(dx, 0),
              child: Column(
                children: [
                  _battleBanner(),
                  Expanded(child: SafeArea(top: false, child: _enemyArea())),
                  SafeArea(top: false, child: _partyRow()),
                ],
              ),
            );
          },
        ),
        if (_attackProjectile != null)
          Positioned.fill(
            child: _AttackProjectileView(key: ValueKey('proj-${_attackProjectile!.id}'), projectile: _attackProjectile!),
          ),
        if (_impactBurst != null)
          Positioned.fill(child: _ImpactBurstView(key: ValueKey('impact-${_impactBurst!.id}'), burst: _impactBurst!)),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedContainer(duration: const Duration(milliseconds: 80), color: _bossFlashColor),
          ),
        ),
        if (_ultimateShowcase != null) _UltimateShowcaseOverlay(combatant: _ultimateShowcase!),
        if (_showOutcomeOverlay && _engine.outcome != null)
          _OutcomeOverlay(outcome: _engine.outcome!, onContinue: () => widget.onFinished(_engine)),
      ],
    );
  }

  /// The key art bled across the whole screen — blurred and darkened behind
  /// the gameplay UI — instead of a flat gradient with only a thin sliver of
  /// art up in the banner. Falls back to the same flat gradient underneath
  /// so nothing is ever fully unpainted while the image decodes.
  ///
  /// Previously opacity 0.5 + a 0.4→0.85 dark overlay on top of a 28px blur
  /// combined to nearly erase the art — the battlefield read as a flat dark
  /// gradient with no visible scene, matching in-game reports of a "missing"
  /// background. Brighter art and a lighter overlay keep the same
  /// "abstract backdrop, not a photo" read while the scene stays recognizable
  /// behind the UI. Mirrors `BattleView.swift`'s `battleBackdrop`.
  Widget _battleBackdrop() {
    final isBoss = _engine.isBossStage;
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(decoration: BoxDecoration(gradient: dk_theme.Theme.background)),
          Opacity(
            opacity: 0.85,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20, tileMode: TileMode.decal),
              child: Image.asset(
                isBoss ? dk_theme.SingletonArt.bossBattleBanner : dk_theme.SingletonArt.battleBanner,
                fit: BoxFit.cover,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  dk_theme.Theme.deepNavy.withValues(alpha: 0.15),
                  dk_theme.Theme.deepNavy.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Landscape has almost no vertical room to spare, so this is a thin
  /// title/controls row rather than a full banner.
  ///
  /// Previously this painted its own crisp, unblurred copy of the key art
  /// plus a near-opaque gradient in a hard-edged 44px box — sitting right on
  /// top of `_battleBackdrop()`'s much softer blurred version, the seam and
  /// sharp/blurred mismatch read as an ugly pasted-on bar. Dropping the
  /// duplicate image and using a gradient that fades to fully transparent by
  /// the bottom of the strip lets the shared backdrop show through
  /// continuously — the title/controls just float on the one scene instead
  /// of sitting in their own box.
  Widget _battleBanner() {
    final isBoss = _engine.isBossStage;
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (isBoss ? Colors.red : dk_theme.Theme.deepNavy).withValues(alpha: isBoss ? 0.28 : 0.5),
            dk_theme.Theme.deepNavy.withValues(alpha: 0),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _stageLabel(),
                  style: TextStyle(
                    color: isBoss ? Colors.red : Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              _battleControls(),
            ],
          ),
        ),
      ),
    );
  }

  /// Speed (1x/2x) and Auto-Battle toggles — tucked into the banner's
  /// trailing side so repeated stages can be blitzed through without
  /// hunting for a settings screen mid-fight.
  Widget _battleControls() {
    final l = AppLocalizations.of(context);
    final speedIs2x = _gameState.battleSpeedMultiplier >= 2.0;
    final auto = _gameState.autoBattleEnabled;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: speedIs2x ? l.battleSpeedTo1x : l.battleSpeedTo2x,
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
          label: auto ? l.battleAutoOn : l.battleAutoOff,
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
    final enemy = _engine.activeEnemy;
    if (enemy == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 340,
          child: _CombatantBanner(
            combatant: enemy,
            lastHit: _engine.lastHit,
            lastMechanicTrigger: _engine.lastMechanicTrigger,
            portraitKey: _portraitKeyFor(enemy.id),
          ),
        ),
      ),
    );
  }

  Widget _partyRow() {
    final units = _engine.playerUnits;
    final enemyElement = _engine.activeEnemy?.element;
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
                portraitKey: _portraitKeyFor(units[i].id),
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

class _AttackProjectile {
  final String id;
  final Offset start;
  final Offset end;
  final Color color;
  final String symbol;
  final bool big;
  _AttackProjectile({required this.id, required this.start, required this.end, required this.color, required this.symbol, required this.big});
}

class _ImpactBurst {
  final String id;
  final Offset point;
  final Color color;
  final String symbol;
  final bool big;
  _ImpactBurst({required this.id, required this.point, required this.color, required this.symbol, required this.big});
}

/// A glowing bolt of the attacker's own element flying straight from the
/// attacker's measured portrait position to the target's — the one effect
/// that spans both combatants, so it reads as "who is attacking whom" at a
/// glance, mirroring native's `AttackProjectileView` in spirit (a plain
/// straight flight rather than native's role-shaped arcs, to stay cheap).
class _AttackProjectileView extends StatefulWidget {
  final _AttackProjectile projectile;
  const _AttackProjectileView({super.key, required this.projectile});

  @override
  State<_AttackProjectileView> createState() => _AttackProjectileViewState();
}

class _AttackProjectileViewState extends State<_AttackProjectileView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 170))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.projectile;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final pos = Offset.lerp(p.start, p.end, t)!;
        final fade = t < 0.85 ? 1.0 : (1 - t) / 0.15;
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _TrailPainter(start: p.start, end: pos, color: p.color, big: p.big)),
            ),
            Positioned(
              left: pos.dx - (p.big ? 15 : 11),
              top: pos.dy - (p.big ? 15 : 11),
              child: Opacity(
                opacity: fade.clamp(0, 1),
                child: Icon(sfSymbol(p.symbol), size: p.big ? 30 : 22, color: p.color, shadows: [Shadow(color: p.color, blurRadius: 10)]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrailPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final bool big;
  _TrailPainter({required this.start, required this.end, required this.color, required this.big});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(start, end, [color.withValues(alpha: 0), color.withValues(alpha: 0.9)])
      ..strokeWidth = big ? 5 : 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant _TrailPainter oldDelegate) => oldDelegate.start != start || oldDelegate.end != end;
}

/// Where a bolt actually lands: an expanding ring (doubled for a big hit)
/// plus the element's own icon flashing white-hot at the center — impact
/// reads at the target too, not only as motion along the way there.
/// Mirrors native's `ImpactBurstView`.
class _ImpactBurstView extends StatelessWidget {
  final _ImpactBurst burst;
  const _ImpactBurstView({super.key, required this.burst});

  @override
  Widget build(BuildContext context) {
    final size = burst.big ? 92.0 : 58.0;
    return Stack(
      children: [
        Positioned(
          left: burst.point.dx - size,
          top: burst.point.dy - size,
          width: size * 2,
          height: size * 2,
          child: _ImpactBurstRing(burst: burst, size: size),
        ),
      ],
    );
  }
}

class _ImpactBurstRing extends StatelessWidget {
  final _ImpactBurst burst;
  final double size;
  const _ImpactBurstRing({required this.burst, required this.size});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: burst.big ? 440 : 300),
        curve: Curves.easeOut,
        builder: (context, t, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 1 - t,
                child: Transform.scale(
                  scale: 0.4 + 0.6 * t,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: burst.color.withValues(alpha: 0.85), width: burst.big ? 5 : 3)),
                  ),
                ),
              ),
              if (burst.big)
                Opacity(
                  opacity: (1 - t) * 0.7,
                  child: Transform.scale(
                    scale: 0.4 + 0.6 * t,
                    child: Container(
                      width: 138,
                      height: 138,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: burst.color.withValues(alpha: 0.45), width: 3)),
                    ),
                  ),
                ),
              Opacity(
                opacity: t < 0.7 ? 1 : (1 - t) / 0.3,
                child: Transform.scale(
                  scale: (0.3 + 0.7 * (t / 0.14).clamp(0, 1)).toDouble(),
                  child: Icon(sfSymbol(burst.symbol), size: burst.big ? 26 : 18, color: Colors.white, shadows: [Shadow(color: burst.color, blurRadius: 8)]),
                ),
              ),
            ],
          );
        },
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

  /// Lets `_BattleViewState` measure this portrait's real screen position to
  /// fly an attack bolt to/from it — see `_BattleViewState._centerOf`.
  final GlobalKey portraitKey;

  const _CombatantBanner({
    required this.combatant,
    required this.lastHit,
    required this.lastMechanicTrigger,
    required this.portraitKey,
  });

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
            key: portraitKey,
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
                        child: Text(AppLocalizations.of(context).battleBossBadge,
                            style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
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

  /// Portrait art lookup name — `portraitOverrideName` when set (Arena
  /// rivals), otherwise the combatant's own display name. Mirrors Swift's
  /// `CombatantBanner.portraitLookupName`.
  String get _portraitLookupName => combatant.portraitOverrideName ?? combatant.name;

  /// Checks both namespaces: an Arena rival's override names a real
  /// Dreamkeeper, ordinary enemies only ever have `Monster_` art. No name
  /// exists in both catalogs, so this is unambiguous.
  bool get _hasPortraitArt =>
      dk_theme.DreamkeeperArt.hasArt(_portraitLookupName) || dk_theme.MonsterArt.hasArt(_portraitLookupName);

  String get _portraitAssetName => dk_theme.DreamkeeperArt.hasArt(_portraitLookupName)
      ? dk_theme.DreamkeeperArt.assetName(_portraitLookupName)
      : dk_theme.MonsterArt.assetName(_portraitLookupName);

  Widget _portrait() {
    final tint = combatant.isBoss ? Colors.red : combatant.element.color;
    if (_hasPortraitArt) {
      return Container(
        width: _portraitSize,
        height: _portraitSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: tint.withValues(alpha: 0.6), width: combatant.isBoss ? 3 : 2),
          boxShadow: [BoxShadow(color: tint.withValues(alpha: 0.5), blurRadius: 14)],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(_portraitAssetName, fit: BoxFit.cover),
      );
    }
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

  /// See `_CombatantBanner.portraitKey`.
  final GlobalKey portraitKey;

  const _PartyMemberTile({
    required this.combatant,
    required this.lastHit,
    required this.lastSkillUse,
    required this.lastUltimate,
    required this.enemyElement,
    required this.onUltimate,
    required this.onSkill,
    required this.portraitKey,
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
              key: portraitKey,
              width: _portraitSize + 12,
              height: _portraitSize,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (dk_theme.DreamkeeperArt.hasArt(combatant.portraitOverrideName ?? combatant.name))
                    Opacity(
                      opacity: combatant.isAlive ? 1 : 0.35,
                      child: Container(
                        width: _portraitSize,
                        height: _portraitSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: combatant.element.color.withValues(alpha: 0.5), width: 1.5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          dk_theme.DreamkeeperArt.assetName(combatant.portraitOverrideName ?? combatant.name),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
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
                  semanticLabel: AppLocalizations.of(context).battleActiveSkillLabel,
                  onTap: (combatant.activeSkill != null && combatant.skillReady && combatant.isAlive) ? onSkill : null,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: 'sparkles',
                  ready: combatant.ultimateReady && combatant.isAlive,
                  tint: dk_theme.Theme.gold,
                  semanticLabel: AppLocalizations.of(context).battleUltimateLabel,
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

/// Shown once per Ultimate cast: a centered, scaled-in glowing portrait
/// ringed by a spinning dashed circle plus two layers of icons punching
/// outward — mirrors native's `UltimateShowcaseView` (glow blob, rotating
/// `RevealRing`, inner fast + outer slow icon bursts) instead of the flat
/// glowing-circle stand-in this used to be.
class _UltimateShowcaseOverlay extends StatefulWidget {
  final Combatant combatant;

  const _UltimateShowcaseOverlay({required this.combatant});

  @override
  State<_UltimateShowcaseOverlay> createState() => _UltimateShowcaseOverlayState();
}

class _UltimateShowcaseOverlayState extends State<_UltimateShowcaseOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final combatant = widget.combatant;
    final color = combatant.element.color;
    const portraitSize = 160.0;
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final elapsedMs = _controller.value * 900;
            // Entry: 0-220ms ease-out scale/opacity-in, matching the old timing.
            final entryT = Curves.easeOut.transform((elapsedMs / 220).clamp(0, 1).toDouble());
            // Ring spins continuously for the whole showcase.
            final ringRotation = (elapsedMs / 1400) * 2 * pi;
            // Inner burst: quick 0-300ms.
            final innerT = Curves.easeOut.transform(((elapsedMs) / 300).clamp(0, 1).toDouble());
            final innerOpacity = elapsedMs < 300 ? 1.0 : (1 - ((elapsedMs - 300) / 250)).clamp(0, 1).toDouble();
            // Outer burst: slightly delayed, slower 160-620ms.
            final outerRaw = ((elapsedMs - 160) / 460).clamp(0, 1).toDouble();
            final outerT = Curves.easeOut.transform(outerRaw);
            final outerOpacity = elapsedMs < 160 ? 0.0 : (elapsedMs < 560 ? 1.0 : (1 - (elapsedMs - 560) / 300).clamp(0, 1).toDouble());

            return Container(
              color: Colors.black.withValues(alpha: 0.5 * entryT),
              alignment: Alignment.center,
              child: SizedBox(
                width: 340,
                height: 340,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Soft glow blob behind everything.
                    Opacity(
                      opacity: entryT,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [color.withValues(alpha: 0.55), color.withValues(alpha: 0)]),
                        ),
                      ),
                    ),
                    // Outer slow icon burst (10 icons).
                    ...List.generate(10, (index) {
                      final angle = (index / 10) * 2 * pi;
                      final radius = 150 * outerT;
                      return Opacity(
                        opacity: outerOpacity,
                        child: Transform.translate(
                          offset: Offset(cos(angle) * radius, sin(angle) * radius),
                          child: Icon(sfSymbol(combatant.element.symbol), size: 24, color: color, shadows: [Shadow(color: color, blurRadius: 10)]),
                        ),
                      );
                    }),
                    // Inner fast icon burst (8 icons).
                    ...List.generate(8, (index) {
                      final angle = (index / 8) * 2 * pi + 0.4;
                      final radius = 90 * innerT;
                      return Opacity(
                        opacity: innerOpacity,
                        child: Transform.translate(
                          offset: Offset(cos(angle) * radius, sin(angle) * radius),
                          child: Icon(sfSymbol(combatant.element.symbol), size: 14, color: color),
                        ),
                      );
                    }),
                    // Spinning dashed reveal ring.
                    Opacity(
                      opacity: entryT,
                      child: Transform.rotate(
                        angle: ringRotation,
                        child: CustomPaint(size: const Size(portraitSize + 34, portraitSize + 34), painter: _DashedRingPainter(color: color)),
                      ),
                    ),
                    // Portrait.
                    Opacity(
                      opacity: entryT,
                      child: Transform.scale(
                        scale: 0.3 + 0.7 * entryT,
                        child: Container(
                          width: portraitSize,
                          height: portraitSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color.withValues(alpha: 0.45),
                            border: Border.all(color: color, width: 5),
                            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.85), blurRadius: 34)],
                          ),
                          // No `alignment` here (unlike a plain centering
                          // Container) — Container inserts an `Align` for its
                          // child whenever `alignment` is set, and `Align`
                          // hands its child loose constraints instead of the
                          // Container's own tight portraitSize box. Without a
                          // forced box size, `Image`'s `BoxFit.cover` has
                          // nothing to fill and the image lays out at its own
                          // natural aspect-fit size — a thin cropped strip
                          // instead of filling the circle.
                          clipBehavior: Clip.antiAlias,
                          child: dk_theme.DreamkeeperArt.hasArt(combatant.portraitOverrideName ?? combatant.name)
                              ? Image.asset(dk_theme.DreamkeeperArt.assetName(combatant.portraitOverrideName ?? combatant.name), fit: BoxFit.cover)
                              : Center(child: Icon(sfSymbol(combatant.role.symbol), size: 60, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A dashed circle that spins around the Ultimate portrait — mirrors
/// native's `RevealRing`.
class _DashedRingPainter extends CustomPainter {
  final Color color;
  static const dashCount = 30;
  _DashedRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < dashCount; i++) {
      if (i.isOdd) continue;
      final startAngle = (i / dashCount) * 2 * pi;
      final sweep = (2 * pi / dashCount) * 0.6;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) => oldDelegate.color != color;
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
                isVictory ? AppLocalizations.of(context).brVictoryTitle : AppLocalizations.of(context).brDefeatTitle,
                style: TextStyle(color: isVictory ? dk_theme.Theme.gold : Colors.red, fontWeight: FontWeight.w900, fontSize: 34),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: dk_theme.PrimaryButton(
                  tint: isVictory ? dk_theme.Theme.violet : Colors.grey,
                  onPressed: onContinue,
                  child: Text(AppLocalizations.of(context).commonContinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
