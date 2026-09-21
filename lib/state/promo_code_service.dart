import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Developer-configured gift codes, redeemable once per account for gold
/// and/or Dream Gems. Mirrors `FriendsService`'s Firebase Anonymous Auth +
/// Firestore pattern and its zero-in-app-admin-UI precedent: codes and
/// their rewards are created and edited directly in the Firebase Console
/// under a `promoCodes/{code}` document —
///
/// ```
/// promoCodes/WELCOME2026
///   active: true            // flip false to retire a code without deleting it
///   gold: 1000               // optional, defaults to 0
///   dreamGems: 50             // optional, defaults to 0
///   maxRedemptions: 0        // 0 = unlimited; otherwise a hard cap
///   redemptionCount: 0        // maintained by the redeem transaction — start at 0
/// ```
///
/// One-time-per-account enforcement is a `promoRedemptions/{code}_{uid}`
/// marker doc, written in the same transaction that reads and validates the
/// code, so a code can't be redeemed twice by the same account even under
/// concurrent taps. Codes are matched case-insensitively (stored/looked up
/// upper-cased).
///
/// This client-side transaction only *cooperates* with the rules below — it
/// doesn't enforce them. Firestore Security Rules restricting direct writes
/// to `promoCodes`/`promoRedemptions` to server-side/Console access are
/// required before shipping; see the rules text handed to the developer
/// alongside this feature.
class PromoCodeService extends ChangeNotifier {
  bool isRedeeming = false;
  String? lastError;

  Future<PromoCodeReward?> redeem(String rawCode) async {
    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) {
      lastError = 'Bitte gib einen Code ein.';
      notifyListeners();
      return null;
    }
    isRedeeming = true;
    lastError = null;
    notifyListeners();
    try {
      var user = FirebaseAuth.instance.currentUser;
      user ??= (await FirebaseAuth.instance.signInAnonymously()).user;
      if (user == null) {
        lastError = 'Anmeldung fehlgeschlagen.';
        return null;
      }
      final uid = user.uid;
      final db = FirebaseFirestore.instance;
      final codeRef = db.collection('promoCodes').doc(code);
      final redemptionRef = db.collection('promoRedemptions').doc('${code}_$uid');

      final reward = await db.runTransaction<PromoCodeReward?>((tx) async {
        final codeSnapshot = await tx.get(codeRef);
        if (!codeSnapshot.exists) {
          lastError = 'Dieser Code ist ungültig.';
          return null;
        }
        final data = codeSnapshot.data()!;
        final active = data['active'] as bool? ?? true;
        if (!active) {
          lastError = 'Dieser Code ist nicht mehr gültig.';
          return null;
        }
        final maxRedemptions = data['maxRedemptions'] as int? ?? 0;
        final redemptionCount = data['redemptionCount'] as int? ?? 0;
        if (maxRedemptions > 0 && redemptionCount >= maxRedemptions) {
          lastError = 'Dieser Code wurde bereits zu oft eingelöst.';
          return null;
        }
        final redemptionSnapshot = await tx.get(redemptionRef);
        if (redemptionSnapshot.exists) {
          lastError = 'Du hast diesen Code bereits eingelöst.';
          return null;
        }
        final gold = data['gold'] as int? ?? 0;
        final gems = data['dreamGems'] as int? ?? 0;
        tx.set(redemptionRef, {'redeemedAt': FieldValue.serverTimestamp()});
        tx.update(codeRef, {'redemptionCount': redemptionCount + 1});
        return PromoCodeReward(gold: gold, dreamGems: gems);
      });
      if (reward == null) {
        lastError ??= 'Dieser Code ist ungültig.';
      }
      return reward;
    } catch (e) {
      lastError = '$e';
      return null;
    } finally {
      isRedeeming = false;
      notifyListeners();
    }
  }
}

class PromoCodeReward {
  final int gold;
  final int dreamGems;
  const PromoCodeReward({required this.gold, required this.dreamGems});
}
