part of 'SessionCubit.dart';

class SessionState extends Equatable {
  final bool? isAuthenticated;
  final String? state;
  final bool? wifi;
  final SessionStatus? sessionStatus;
  final ConfigModel? cfg;

  const SessionState({
    this.state = '',
    this.wifi = false,
    this.isAuthenticated = false,
    this.sessionStatus = SessionStatus.none,
    this.cfg,
  });

  SessionState copyWith({
    bool? isAuthenticated,
    String? state,
    SessionStatus? sessionStatus,
    ConfigModel? configModel,
    bool? wifi,
  }) =>
      SessionState(
          isAuthenticated: isAuthenticated ?? this.isAuthenticated,
          state: state ?? this.state,
          wifi: wifi ?? this.wifi,
          sessionStatus: sessionStatus ?? this.sessionStatus,
          cfg: configModel ?? cfg);

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
      isAuthenticated: json['isAuthenticated'] as bool?,
      wifi: json['wifi'] as bool?,
      state: json['state'] as String?,
      sessionStatus: SessionStatus.values.firstWhere(
        (element) => element.toString() == json['sessionStatus'],
      ),
      cfg: json['cfg'] != null
          ? ConfigModel.fromJson(json['cfg'])
          : json['cfg']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isAuthenticated': isAuthenticated,
        'state': state,
        'sessionStatus': SessionStatus.none.toString(),
        'cfg': cfg?.toJson(),
        'wifi':wifi
      };

  @override
  List<Object?> get props => [isAuthenticated, state, sessionStatus, cfg,wifi];
}
