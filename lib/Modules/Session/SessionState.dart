part of 'SessionCubit.dart';

class SessionState extends Equatable {
  final bool isAuthenticated;
  final String? state;
  final String? ip;
  final bool? wifi;
  final SessionStatus? sessionStatus;
  final ConfigModel? cfg;

  const SessionState({
    this.state = '',
    this.ip ="",
    this.wifi = false,
    this.isAuthenticated = false,
    this.sessionStatus = SessionStatus.none,
    this.cfg,
  });

  SessionState copyWith({
    bool? isAuthenticated,
    String? state,
    String? ip,
    SessionStatus? sessionStatus,
    ConfigModel? configModel,
    bool? wifi,
  }) =>
      SessionState(
          isAuthenticated: isAuthenticated ?? this.isAuthenticated,
          state: state ?? this.state,
          wifi: wifi ?? this.wifi,
          ip: ip ?? this.ip,
          sessionStatus: sessionStatus ?? this.sessionStatus,
          cfg: configModel ?? cfg);

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
      isAuthenticated: json['isAuthenticated'],
      wifi: json['wifi'] as bool?,
      state: json['state'] as String?,
      ip: json['ip'] as String?,
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
        'wifi':wifi,
        'ip':ip
      };

  @override
  List<Object?> get props => [isAuthenticated, state, sessionStatus, cfg,wifi];
}
