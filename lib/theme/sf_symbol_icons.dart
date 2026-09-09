import 'package:flutter/material.dart';

/// Best-effort SF Symbol name → Material Icons mapping. Ported Swift screens
/// name icons as SF Symbol strings (e.g. `"shield.righthalf.filled"`); this
/// gives every ported screen a single place to resolve one to a Material
/// `IconData` instead of re-guessing the mapping per screen. Not exhaustive —
/// add a case whenever porting a screen introduces a symbol name not listed
/// here. Unmapped names fall back to a generic filled circle rather than
/// throwing, so a missed mapping is visibly generic instead of a crash.
IconData sfSymbol(String name) {
  switch (name) {
    case 'sparkles':
      return Icons.auto_awesome;
    case 'star.fill':
      return Icons.star;
    case 'star.circle.fill':
      return Icons.stars;
    case 'person.3.fill':
      return Icons.groups;
    case 'person.3.sequence.fill':
      return Icons.groups_2;
    case 'flame.fill':
      return Icons.local_fire_department;
    case 'shield.fill':
      return Icons.shield;
    case 'shield.checkered':
      return Icons.shield_moon;
    case 'shield.righthalf.filled':
      return Icons.security;
    case 'arrow.up.circle.fill':
      return Icons.arrow_circle_up;
    case 'circle.hexagongrid.fill':
      return Icons.hexagon;
    case 'eye.fill':
      return Icons.visibility;
    case 'calendar.badge.checkmark':
      return Icons.event_available;
    case 'play.fill':
      return Icons.play_arrow;
    case 'gearshape.fill':
      return Icons.settings;
    case 'house.fill':
      return Icons.home;
    case 'map.fill':
      return Icons.map;
    case 'paid':
      return Icons.paid;
    case 'diamond':
      return Icons.diamond;
    case 'bolt':
    case 'bolt.fill':
      return Icons.bolt;
    case 'cart.fill':
      return Icons.shopping_cart;
    case 'flag.checkered':
      return Icons.flag;
    case 'gift.fill':
      return Icons.card_giftcard;
    case 'shield.lefthalf.filled':
      return Icons.shield_outlined;
    case 'chevron.right':
      return Icons.chevron_right;
    case 'person.fill.badge.plus':
      return Icons.person_add;
    case 'rosette':
      return Icons.military_tech;
    case 'leaf.arrow.circlepath':
      return Icons.eco;
    case 'sparkle.magnifyingglass':
      return Icons.travel_explore;
    case 'crown.fill':
      return Icons.emoji_events;
    case 'play.rectangle.fill':
      return Icons.smart_display;
    case 'hand.tap.fill':
      return Icons.touch_app;
    case 'sun.max.fill':
      return Icons.wb_sunny;
    case 'calendar':
      return Icons.calendar_month;
    case 'lock.fill':
      return Icons.lock;
    case 'checkmark':
      return Icons.check;
    case 'checkmark.circle.fill':
      return Icons.check_circle;
    // Added porting Team/Inventory (InventoryView, EquipmentSheet,
    // EquipmentDetailSheet) — see this function's doc comment.
    case 'wand.and.rays':
    case 'wand.and.stars':
      return Icons.auto_fix_high;
    case 'seal.fill':
      return Icons.workspace_premium;
    case 'theatermask.and.paintbrush.fill':
      return Icons.theater_comedy;
    case 'circle.circle.fill':
      return Icons.adjust;
    case 'hammer.fill':
      return Icons.build;
    case 'tag.fill':
      return Icons.sell;
    case 'arrow.up.arrow.down':
      return Icons.swap_vert;
    case 'arrow.up.forward':
      return Icons.north_east;
    case 'shippingbox.fill':
      return Icons.inventory_2;
    case 'book.closed.fill':
      return Icons.menu_book;
    case 'chevron.left':
      return Icons.chevron_left;
    case 'plus':
      return Icons.add;
    // Added porting Campaign (CampaignView) — GameElement.symbol values for
    // world/stage badges not already covered above.
    case 'drop.fill':
      return Icons.water_drop;
    case 'moon.stars.fill':
      return Icons.nightlight;
    // Added porting Shop (ShopView) — Arena Ticket pack icon.
    case 'ticket.fill':
      return Icons.confirmation_number;
    // Added porting Battle/BattleResult (BattleView, BattleResultView) —
    // Role.symbol values not already covered above, the auto-battle toggle,
    // and the party tile's elemental advantage/disadvantage badge.
    case 'cross.case.fill':
      return Icons.medical_services;
    case 'snowflake':
      return Icons.ac_unit;
    case 'leaf.fill':
      return Icons.eco;
    case 'arrow.triangle.2.circlepath':
      return Icons.autorenew;
    case 'arrowtriangle.up.fill':
      return Icons.arrow_drop_up;
    case 'arrowtriangle.down.fill':
      return Icons.arrow_drop_down;
    // Added porting Settings (SettingsView) — toggle-row icons, the
    // language card, and the account avatar placeholder.
    case 'speaker.wave.2.fill':
      return Icons.volume_up;
    case 'bell.fill':
      return Icons.notifications;
    case 'globe':
      return Icons.language;
    case 'person.crop.circle.fill':
    case 'person.crop.circle':
      return Icons.account_circle;
    // Added porting Profile (ProfileView, AchievementsSheet) — the level
    // card's avatar icon and locked-achievement placeholder icon.
    case 'person.fill':
      return Icons.person;
    // Added porting Bestiary (BestiaryView) — MonsterKind.symbol values not
    // already covered above.
    case 'diamond.fill':
      return Icons.diamond;
    case 'hexagon.fill':
      return Icons.hexagon;
    case 'ladybug.fill':
      return Icons.bug_report;
    case 'moon.fill':
      return Icons.dark_mode;
    case 'pawprint.fill':
      return Icons.pets;
    case 'sparkle':
      return Icons.auto_awesome;
    case 'tropicalstorm':
      return Icons.cyclone;
    case 'wind':
      return Icons.air;
    // Added porting Codex (DreamkeeperCodexView, DreamkeeperCodexDetailView)
    // — the close button, ownership/matchup icons, and the role filter menu.
    case 'xmark':
      return Icons.close;
    case 'checkmark.seal.fill':
      return Icons.verified;
    case 'questionmark.circle.fill':
      return Icons.help;
    case 'quote.opening':
      return Icons.format_quote;
    case 'link':
      return Icons.link;
    case 'line.3.horizontal.decrease.circle':
      return Icons.filter_list;
    case 'arrow.down.circle.fill':
      return Icons.arrow_circle_down;
    default:
      return Icons.circle;
  }
}
