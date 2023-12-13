abstract class TicketsEvent {}

class FetchData extends TicketsEvent {
  final bool load;
  FetchData({this.load = true});
}

class ShareQRImage extends TicketsEvent {
  final String user;
  final String password;
  ShareQRImage(this.user,this.password);
}

class GeneratedTickets extends TicketsEvent{
  final String profile;
  final String cant;
  final String duration;
  GeneratedTickets(this.profile,this.cant,this.duration);
}

class DeletedTicket extends TicketsEvent{
  final String id;
  DeletedTicket(this.id);
}

