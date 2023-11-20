abstract class HomeEvent {}

class FetchData extends HomeEvent {}

class ShareQRImage extends HomeEvent {
  final String user;
  final String password;
  ShareQRImage(this.user,this.password);
}

class GeneratedTickets extends HomeEvent{
  final String profile;
  final String cant;
  GeneratedTickets(this.profile,this.cant);
}

