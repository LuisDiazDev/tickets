abstract class ActiveTicketsEvent {}

class FetchData extends ActiveTicketsEvent {
  final bool load;
  FetchData({this.load = true});
}

class DisconecTicket extends ActiveTicketsEvent{
  final String id;
  DisconecTicket(this.id);
}

