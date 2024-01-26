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
  final int limitMb;
  final bool isVirtualTicket;
  GeneratedTicket(this.profile,this.name,this.duration,this.price,{this.limitMb=0, required this.isVirtualTicket});
}

class VirtualTicketScanned extends HomeEvent{
  final String qr;
  VirtualTicketScanned(this.qr);
}


class VirtualTicketDismissed extends HomeEvent{
  VirtualTicketDismissed();
}
