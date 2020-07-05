class GamePosition {
  GamePosition(
      this.id,
      this.pos0,
      this.pos1,
      this.pos2,
      this.pos3,
      this.pos4,
      this.pos5,
      this.pos6,
      this.pos7,
      this.pos8,
      this.lastMoveBy,
      this.lastMoveAtUtc);

  String id;
  String pos0;
  String pos1;
  String pos2;
  String pos3;
  String pos4;
  String pos5;
  String pos6;
  String pos7;
  String pos8;
  String lastMoveBy;
  DateTime lastMoveAtUtc;

  GamePosition.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        pos0 = json["pos0"],
        pos1 = json["pos1"],
        pos2 = json["pos2"],
        pos3 = json["pos3"],
        pos4 = json["pos4"],
        pos5 = json["pos5"],
        pos6 = json["pos6"],
        pos7 = json["pos7"],
        pos8 = json["pos8"],
        lastMoveBy = json["lastMoveBy"],
        lastMoveAtUtc = DateTime.parse(json["lastMoveAtUtc"]);

  Map toJson() => {
        'id': id,
        'pos0': pos0,
        'pos1': pos1,
        'pos2': pos2,
        'pos3': pos3,
        'pos4': pos4,
        'pos5': pos5,
        'pos6': pos6,
        'pos7': pos7,
        'pos8': pos8,
        'lastMoveBy': lastMoveBy,
        'lastMoveAtUtc': lastMoveAtUtc.toIso8601String()
      };
}
