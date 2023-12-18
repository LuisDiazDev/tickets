

import '../../../models/profile_model.dart';

abstract class ProfileEvent {}

class FetchData extends ProfileEvent {}

class NewProfile extends ProfileEvent {
  final ProfileModel newProfile;
  NewProfile(this.newProfile);
}

class UpdateProfile extends ProfileEvent {
  final ProfileModel updateProfile;
  UpdateProfile(this.updateProfile);
}

class DeletedProfile extends ProfileEvent {
  final ProfileModel deletedProfile;
  DeletedProfile(this.deletedProfile);
}

