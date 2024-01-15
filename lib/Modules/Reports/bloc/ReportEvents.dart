abstract class ReportEvent {}

class FetchData extends ReportEvent {
  final bool load;
  FetchData({this.load = true});
}

class ShareQRImage extends ReportEvent {
  final String user;
  final String password;
  final String host;
  ShareQRImage(this.user,this.password,this.host);
}

class GenerateTicket extends ReportEvent{
  final String profile;
  final String cant;
  final String duration;
  GenerateTicket(this.profile,this.cant,this.duration);
}

class DeletedTicket extends ReportEvent{
  final String id;
  DeletedTicket(this.id);
}

