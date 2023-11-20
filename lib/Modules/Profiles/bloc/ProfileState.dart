import 'package:equatable/equatable.dart';
import '../../../models/profile_model.dart';


class ProfileState extends Equatable {

  final bool load;
  final bool isError;
  final List<ProfileModel> profiles;

  const ProfileState({
    this.load = false,
    this.profiles =const [],
    this.isError = false,
  });


  ProfileState copyWith({
    bool? load,
    List<ProfileModel>? profiles,
    bool? isError,
  }) {
    return ProfileState(
      load: load ?? this.load,
      profiles: profiles ?? this.profiles,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [
    load,
    profiles,
    isError,
  ];
}