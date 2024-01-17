import 'package:StarTickera/models/ticket_model.dart';

import '../../../models/profile_model.dart';

abstract class ClientsEvent {}

class FetchData extends ClientsEvent {
  final bool load;
  FetchData({this.load = true});
}

class GenerateClient extends ClientsEvent{
  final String profile;
  final String name;
  final String duration;
  final String price;
  final int limitMb;
  GenerateClient(this.profile,this.name,this.duration,this.price,{this.limitMb=0});
}


class DeletedClient extends ClientsEvent{
  final String id;
  DeletedClient(this.id);
}

class ResetClient extends ClientsEvent{
  final TicketModel client;
  ResetClient(this.client);
}

class DeletedProfile extends ClientsEvent{
  final String id;
  DeletedProfile(this.id);
}

class NewProfile extends ClientsEvent {
  final ProfileModel newProfile;
  final String duration;
  NewProfile(this.newProfile,this.duration);
}

class UpdateProfile extends ClientsEvent {
  final ProfileModel updateProfile;
  UpdateProfile(this.updateProfile);
}