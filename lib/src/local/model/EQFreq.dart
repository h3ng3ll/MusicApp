// ignore_for_file: file_names


// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class EQFreq extends Equatable{

  final int fr_60hz;
  final int fr_230hz;
  final int fr_910hz;
  final int fr_3600hz;
  final int fr_14000hz;

  const EQFreq(this.fr_60hz, this.fr_230hz, this.fr_910hz, this.fr_3600hz, this.fr_14000hz);

  static EQFreq fromJson (Map<String, dynamic> json ) => EQFreq(
      json["fr_60hz"],
      json["fr_230hz"],
      json["fr_910hz"],
      json["fr_3600hz"],
      json["fr_14000hz"]
  );

  factory EQFreq.zero () => const EQFreq(0, 0, 0, 0, 0);

  Map<String, dynamic>  toJson () => {
    "fr_60hz" : fr_60hz,
    "fr_230hz" : fr_230hz,
    "fr_910hz" : fr_910hz,
    "fr_3600hz" : fr_3600hz,
    "fr_14000hz" : fr_14000hz,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EQFreq  &&
      fr_60hz == other.fr_60hz && fr_230hz == other.fr_230hz &&
      fr_910hz == other.fr_910hz && fr_3600hz == other.fr_3600hz &&
      fr_14000hz == other.fr_14000hz;

  @override
  // TODO: implement hashCode
  int get hashCode => fr_60hz ^ fr_230hz ^ fr_910hz ^ fr_3600hz ^ fr_14000hz;

  @override
  // TODO: implement props
  List<Object?> get props => [
    fr_60hz,
    fr_230hz,
    fr_910hz,
    fr_3600hz,
    fr_14000hz,
  ];





}
