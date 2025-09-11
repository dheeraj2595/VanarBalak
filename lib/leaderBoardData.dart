import 'package:vanarbalak/main.dart';
import 'dart:convert';

class leaderBoardData {
  final String leaderName;
  final int leaderScore;

  leaderBoardData({required this.leaderName, required this.leaderScore});

  Map<String, dynamic> toJson() {
    return {'leaderName': leaderName, 'leaderScore': leaderScore};
  }

  factory leaderBoardData.fromJson(Map<String, dynamic> json) {
    return leaderBoardData(
      leaderName: json['leaderName'],
      leaderScore: json['leaderScore'],
    );
  }

  static String encode(List<leaderBoardData> leaders) => json.encode(
    leaders.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
  );

  static List<leaderBoardData> decode(String leaders) =>
      (json.decode(leaders) as List<dynamic>)
          .map<leaderBoardData>((item) => leaderBoardData.fromJson(item))
          .toList();
}
