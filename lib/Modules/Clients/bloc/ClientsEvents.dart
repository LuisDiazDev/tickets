abstract class ClientsEvent {}

class FetchData extends ClientsEvent {
  final bool load;
  FetchData({this.load = true});
}

class GenerateClient extends ClientsEvent{
  final String profile;
  final String duration;
  final String name;
  GenerateClient(this.profile,this.name,this.duration);
}

class DeletedClient extends ClientsEvent{
  final String id;
  DeletedClient(this.id);
}

