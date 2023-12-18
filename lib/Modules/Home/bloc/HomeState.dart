import 'package:equatable/equatable.dart';

import '../../../models/profile_model.dart';
import '../../../models/ticket_model.dart';


class HomeState extends Equatable {

  final bool load;
  final bool isError;
  final List<TicketModel> tickets;
  final List<ProfileModel> profiles;

  const HomeState({
    this.load = false,
    this.tickets =const [],
    this.profiles =const [],
    this.isError = false,
  });


  HomeState copyWith({
    bool? load,
    List<TicketModel>? tickets,
    List<ProfileModel>? profiles,
    bool? isError,
  }) {
    return HomeState(
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