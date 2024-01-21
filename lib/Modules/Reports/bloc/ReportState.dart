import 'package:equatable/equatable.dart';

import '../../../models/profile_model.dart';
import '../../../models/ticket_model.dart';


class ReportState extends Equatable {

  final bool load;
  final bool isError;
  final List sellers;
  final List<ProfileModel> profiles;

  const ReportState({
    this.load = false,
    this.sellers =const [],
    this.profiles =const [],
    this.isError = false,
  });


  ReportState copyWith({
    bool? load,
    List? sellers,
    List<ProfileModel>? profiles,
    bool? isError,
  }) {
    return ReportState(
      load: load ?? this.load,
      profiles: profiles ?? this.profiles,
      sellers: sellers ?? this.sellers,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
    load,
    sellers,
    isError,
    profiles
  ];
}