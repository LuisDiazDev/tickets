part of 'SessionCubit.dart';

class SessionState extends Equatable {
  final bool? isAuthenticated;
  final String? state;
  final SessionStatus? sessionStatus;
  final bool fistUse;
  final ConfigModel? cfg;

  const SessionState({
    this.fistUse = false,
    this.state = '',
    this.isAuthenticated = false,
    this.sessionStatus = SessionStatus.none,
    this.cfg,
  });

  SessionState copyWith({
    String? accessToken,
    bool? isAuthenticated,
    String? refreshToken,
    String? state,
    int? expiresIn,
    String? tokenType,
    bool? fistUse,
    SessionStatus? sessionStatus,
    ConfigModel? configModel,
  }) =>
      SessionState(
        fistUse: fistUse ?? this.fistUse,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        state: state ?? this.state,
        sessionStatus: sessionStatus ?? this.sessionStatus,
        cfg: configModel ?? ConfigModel.defaultConfig
      );

  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
        isAuthenticated: json['isAuthenticated'] as bool?,
        fistUse: json['fistUse'] as bool,
        state: json['state'] as String?,
        sessionStatus: SessionStatus.values.firstWhere(
          (element) => element.toString() == json['sessionStatus'],
        ),
        cfg: ConfigModel.defaultConfig
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'fistUse':fistUse,
        'isAuthenticated': isAuthenticated,
        'state': state,
        'sessionStatus': SessionStatus.none.toString(),
      };

  @override
  List<Object?> get props => [
        isAuthenticated,
        state,
        sessionStatus,
        fistUse,
        cfg
      ];
}
