// Regression test for a crash where fusing enough duplicates to actually
// cross into a new star (as opposed to just banking progress) threw
// "Incorrect use of ParentDataWidget" the moment `_StarUpShowcase` mounted —
// see its own fix comment in `fusion_picker_view.dart`.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dreamkeepers/progression/star_fusion_system.dart';
import 'package:dreamkeepers/state/game_state.dart';
import 'package:dreamkeepers/ui/equipment/fusion_picker_view.dart';
import '../../support/test_app.dart';

void main() {
  testWidgets('fusing enough duplicates to star-up shows the showcase without crashing', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final gameState = await GameState.create();
    final target = gameState.save.roster.first;
    final needed = StarFusionSystem.duplicatesRequired(target.stars + 1);
    gameState.debugSeedDuplicates(needed);

    await tester.pumpWidget(testApp(FusionPickerView(targetID: target.id, gameState: gameState)));
    await tester.pumpAndSettle();

    final cards = find.byWidgetPredicate((w) => w.runtimeType.toString() == '_DuplicatePickerCard');
    expect(cards, findsNWidgets(needed));
    for (var i = 0; i < needed; i++) {
      await tester.tap(cards.at(i));
      await tester.pump();
    }

    await tester.tap(find.text('Fuse').first);
    await tester.pump();
    // The showcase appears on a short delay, then its ring animation repeats
    // forever by design — `pumpAndSettle` would time out on it, so pump a
    // few finite frames instead.
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
    expect(find.text('STAR UP!'), findsOneWidget);
  });
}
