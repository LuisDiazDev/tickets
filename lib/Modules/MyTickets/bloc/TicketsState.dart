import 'package:equatable/equatable.dart';
import 'package:tickets/models/profile_model.dart';
import 'package:tickets/models/ticket_model.dart';


class TicketsState extends Equatable {

  final bool load;
  final bool isError;
  final List<TicketModel> tickets;
  final List<ProfileModel> profiles;

  const TicketsState({
    this.load = false,
    this.tickets =const [],
    this.profiles =const [],
    this.isError = false,
  });


  TicketsState copyWith({
    bool? load,
    List<TicketModel>? tickets,
    List<ProfileModel>? profiles,
    bool? isError,
  }) {
    return TicketsState(
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