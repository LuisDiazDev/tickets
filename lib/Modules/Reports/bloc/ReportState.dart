import 'package:equatable/equatable.dart';

import '../../../models/profile_model.dart';
import '../../../models/ticket_model.dart';


class ReportState extends Equatable {

  final bool load;
  final bool isError;
  final List<TicketModel> tickets;
  final List<ProfileModel> profiles;

  const ReportState({
    this.load = false,
    this.tickets =const [],
    this.profiles =const [],
    this.isError = false,
  });


  ReportState copyWith({
    bool? load,
    List<TicketModel>? tickets,
    List<ProfileModel>? profiles,
    bool? isError,
  }) {
    return ReportState(
      load: load ?? this.load,
      profiles: profiles ?? this.profiles,
      tickets: tickets ?? this.tickets,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
    load,
    tickets,
    isError,
    profiles
  ];
}