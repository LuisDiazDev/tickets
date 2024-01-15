import 'package:equatable/equatable.dart';

import '../../../../../models/active_user_models.dart';


class ActiveTicketState extends Equatable {

  final bool load;
  final bool isError;
  final List<ActiveModel> ticketsA;

  const ActiveTicketState({
    this.load = false,
    this.ticketsA =const [],
    this.isError = false,
  });


  ActiveTicketState copyWith({
    bool? load,
    List<ActiveModel>? ticketsA,
    bool? isError,
  }) {
    return ActiveTicketState(
      load: load ?? this.load,
      ticketsA: ticketsA ?? this.ticketsA,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
    load,
    ticketsA,
    isError,
  ];
}