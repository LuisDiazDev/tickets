part of 'SessionCubit.dart';

class SessionState extends Equatable {
  final bool isAuthenticated;
  final StreamSubscription? listener;
  final String uuid;
  final String firebaseID;
  final String? state;
  final String? ip;
  final bool? wifi;
  final bool active;
  final SessionStatus? sessionStatus;
  final ConfigModel? cfg;

  const SessionState({
    this.state = '',
    this.ip = "",
    this.uuid = "",
    this.listener,
    this.firebaseID = "",
    this.active = false,
    this.wifi = false,
    this.isAuthenticated = false,
    this.sessionStatus = SessionStatus.none,
    this.cfg,
  });

  SessionState copyWith({
    bool? isAuthenticated,
    String? state,
    String? ip,
    String? uuid,
    String? firebaseID,
    SessionStatus? sessionStatus,
    ConfigModel? configModel,
    bool? wifi,
    bool? active,
    StreamSubscription? listener
  }) =>
      SessionState(
          isAuthenticated: isAuthenticated ?? this.isAuthenticated,
          state: state ?? this.state,
          wifi: wifi ?? this.wifi,
          ip: ip ?? this.ip,
          firebaseID: firebaseID ?? this.firebaseID,
          uuid: uuid ?? this.uuid,
          listener: listener ?? this.listener,
          active: active ?? this.active,
          sessionStatus: sessionStatus ?? this.sessionStatus,
          cfg: configModel ?? cfg);

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
      isAuthenticated: json['isAuthenticated'],
      wifi: json['wifi'] as bool?,
      state: json['state'] as String?,
      ip: json['ip'] as String?,
      uuid: json['uuid'] as String,
      firebaseID: json['firebase_id'] ?? "",
      active: json['active'] as bool ?? false,
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
        'wifi': wifi,
        'ip': ip,
        'uuid': uuid,
        'active': active,
        'firebase_id': firebaseID,
      };

  @override
  List<Object?> get props =>
      [isAuthenticated, state, sessionStatus, cfg, wifi, active, uuid];
}
