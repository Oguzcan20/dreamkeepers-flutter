/// Combat stats. `energyGain` controls how fast the ultimate charges per
/// basic attack. Mirrors GameCore/Models/Stats.swift exactly.
class Stats {
  final double hp;
  final double attack;
  final double defense;
  final double speed;

  const Stats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.speed,
  });

  static const zero = Stats(hp: 0, attack: 0, defense: 0, speed: 0);

  Stats operator +(Stats other) => Stats(
        hp: hp + other.hp,
        attack: attack + other.attack,
        defense: defense + other.defense,
        speed: speed + other.speed,
      );

  Stats operator *(double factor) => Stats(
        hp: hp * factor,
        attack: attack * factor,
        defense: defense * factor,
        speed: speed * factor,
      );

  Stats get rounded => Stats(
        hp: hp.roundToDouble(),
        attack: attack.roundToDouble(),
        defense: defense.roundToDouble(),
        speed: speed.roundToDouble(),
      );

  Map<String, dynamic> toJson() => {
        'hp': hp,
        'attack': attack,
        'defense': defense,
        'speed': speed,
      };

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        hp: (json['hp'] as num).toDouble(),
        attack: (json['attack'] as num).toDouble(),
        defense: (json['defense'] as num).toDouble(),
        speed: (json['speed'] as num).toDouble(),
      );

  @override
  bool operator ==(Object other) =>
      other is Stats &&
      hp == other.hp &&
      attack == other.attack &&
      defense == other.defense &&
      speed == other.speed;

  @override
  int get hashCode => Object.hash(hp, attack, defense, speed);
}
