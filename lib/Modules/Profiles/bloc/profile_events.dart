

import '../../../models/profile_model.dart';

abstract class ProfileEvent {}

class FetchData extends ProfileEvent {}

class NewProfile extends ProfileEvent {
  final ProfileModel newProfile;
  final String duration;
  NewProfile(this.newProfile,this.duration);
}

class UpdateProfile extends ProfileEvent {
  final ProfileModel updateProfile;
  UpdateProfile(this.updateProfile);
}

class DeletedProfile extends ProfileEvent {
  final String id;
  DeletedProfile(this.id);
}

