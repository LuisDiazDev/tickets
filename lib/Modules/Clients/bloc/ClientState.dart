import 'package:equatable/equatable.dart';

import '../../../models/profile_model.dart';
import '../../../models/ticket_model.dart';


class ClientsState extends Equatable {

  final bool load;
  final bool isError;
  final List<TicketModel> clients;
  final List<ProfileModel> profiles;

  const ClientsState({
    this.load = false,
    this.clients =const [],
    this.profiles =const [],
    this.isError = false,
  });


  ClientsState copyWith({
    bool? load,
    List<TicketModel>? clients,
    List<ProfileModel>? profiles,
    bool? isError,
  }) {
    return ClientsState(
      load: load ?? this.load,
      profiles: profiles ?? this.profiles,
      clients: clients ?? this.clients,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
    load,
    clients,
    isError,
    profiles
  ];
}