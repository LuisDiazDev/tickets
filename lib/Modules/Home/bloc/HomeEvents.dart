abstract class HomeEvent {}

class FetchData extends HomeEvent {}

class ShareQRImage extends HomeEvent {
  final String user;
  final String password;
  ShareQRImage(this.user,this.password);
}

class GeneratedTicket extends HomeEvent{
  final String profile;
  final String name;
  final String duration;
  final String price;
  GeneratedTicket(this.profile,this.name,this.duration,this.price);
}

class NewQr extends HomeEvent{
  final String qr;
  NewQr(this.qr);
}

