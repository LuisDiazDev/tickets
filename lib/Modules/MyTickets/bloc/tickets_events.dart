abstract class TicketsEvent {}

class FetchData extends TicketsEvent {
  final bool load;
  FetchData({this.load = true});
}

class ShareQRImage extends TicketsEvent {
  final String user;
  final String password;
  final String host;
  ShareQRImage(this.user,this.password,this.host);
}

class GenerateTicket extends TicketsEvent{
  final String profile;
  final String cant;
  final String duration;
  GenerateTicket(this.profile,this.cant,this.duration);
}

class DeletedTicket extends TicketsEvent{
  final String id;
  DeletedTicket(this.id);
}

