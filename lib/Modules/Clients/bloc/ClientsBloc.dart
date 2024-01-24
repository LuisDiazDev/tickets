import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import '../../../Core/utils/format.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../../Widgets/qr_dialog.dart';
import '../../../models/ticket_model.dart';
import '../../Alerts/AlertCubit.dart';
import '../../Session/SessionCubit.dart';
import 'ClientsEvents.dart';
import 'ClientState.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final AlertCubit alertCubit;
  final MkProvider provider;
  final SessionCubit sessionCubit;

  ClientsBloc(this.alertCubit,
      {required this.provider, required this.sessionCubit})
      : super(const ClientsState()) {
    on<FetchData>(
      (event, emit) async {
        emit(state.copyWith(load: event.load));

        var data =
            await provider.allTickets(); //todo: only users whit client plans
        var profiles = (await provider.allProfiles())
            .where((element) => element.metadata!.type! == "2")
            .toList(); //todo: only users client plans

        List<TicketModel> clients = [];

        for (var p in profiles) {
          var ts = data.where((t) => t.profile == p.fullName);
          clients.addAll(ts);
        }

        clients.sort((a, b) => b.id!.compareTo(a.id!));

        emit(state.copyWith(load: false, clients: clients, profiles: profiles));
      },
    );

    on<NewProfile>(
      (NewProfile event, Emitter<ClientsState> emit) async {
        emit(state.copyWith(load: true));
        var r = await provider.newProfile(event.newProfile, event.duration);
        if (r.statusCode == 200 || r.statusCode == 201) {
          emit(state.copyWith(load: false));
          add(FetchData());
          alertCubit.showDialog(ShowDialogEvent(
            title: "ÉXITO",
            message: "Se ha creado un nuevo plan",
            type: AlertType.success,
          ));
        } else {
          alertCubit.showDialog(ShowDialogEvent(
            title: "ERROR",
            message: "Ha ocurrido un error inesperado registrando el plan",
            type: AlertType.error,
          ));
          emit(state.copyWith(load: false));
        }
      },
    );

    on<GenerateClient>(
      (event, emit) async {
        final user = event.name;
        late Response r;
        try {
          r = await provider.newTicket(user, event.profile, event.duration,
              limitBytesTotal: event.limitMb);
        } on UserAlreadyExist {
          alertCubit.showDialog(ShowDialogEvent(
            title: "USUARIO YA EXISTE",
            message: "El usuario '$user' ya se encuentre registrado en el sistema",
            type: AlertType.error,
          ));
          return;
        } catch (e) {
          alertCubit.showDialog(ShowDialogEvent(
            title: "ERROR",
            message: "Ha ocurrido un error inesperado resgistrando el usuario",
            type: AlertType.error,
          ));
          return;
        }
        if (r.statusCode == 200 || r.statusCode == 201) {
          // alertCubit.showDialog("Exito","Se ha creado un nuevo ticket");
          TicketDialogUtils.showNewTicketDetailDialog(
              configModel: sessionCubit.state.cfg!,
              user: event.name,
              price: event.price,
              duration: formatDuration(event.duration));

          add(FetchData());
        } else {
          alertCubit.showDialog(ShowDialogEvent(
            title: "ERROR",
            message: "Ha ocurrido un problema: ${r.body}",
            type: AlertType.error, // TODO: emit domain error
          ));
        }
      },
    );

    on<UpdateProfile>(
      (UpdateProfile event, Emitter<ClientsState> emit) async {
        emit(state.copyWith(load: true));

        var r = await provider.updateProfile(event.updateProfile);

        if (r.statusCode == 200 || r.statusCode == 201) {
          emit(state.copyWith(load: false));
          add(FetchData());
          alertCubit.showDialog(ShowDialogEvent(
            title: "ÉXITO",
            message: "Se ha modificado un plan",
            type: AlertType.success,
          ));
        } else {
          emit(state.copyWith(load: false));
          alertCubit.showDialog(ShowDialogEvent(
            title: "ERROR",
            message: "Ha ocurrido un error inesperado modificando el plan",
            type: AlertType.error,
          ));
        }
      },
    );

    on<DeletedProfile>(
      (event, emit) async {
        emit(state.copyWith(load: true));

        var r = await provider.removeProfile(event.id);
        if (r.statusCode <= 205) {
          add(FetchData());
          alertCubit.showDialog(ShowDialogEvent(
            title: "PLAN ELIMINADO",
            message: "Se ha eliminado un plan",
            type: AlertType.success,
          ));
        } else {
          alertCubit.showDialog(ShowDialogEvent(
            title: "ERROR ELIMINANDO PLAN",
            message: "Ha ocurrido un error inesperado eliminando el plan: ${r.body}",
            type: AlertType.error,
          ));
        }
      },
    );

    on<DeletedClient>(
      (event, emit) async {
        emit(state.copyWith(load: true));

        var r = await provider.removeTicket(event.id);
        if (r.statusCode <= 205) {
          add(FetchData());
          alertCubit.showDialog(ShowDialogEvent(
            title: "CLIENTE ELIMINADO",
            message: "Se ha eliminado un cliente",
            type: AlertType.success,
          ));
        } else {
          alertCubit.showDialog(ShowDialogEvent(
            title: "ERROR ELIMINANDO CLIENTE",
            message: "Ha ocurrido un error inesperado eliminando el cliente: ${r.body}",
            type: AlertType.error,
          ));
        }
      },
    );

    on<ResetClient>(
      (event, emit) async {
        emit(state.copyWith(load: true));
        var c = event.client;
        var response = await provider.reactiveUserHotspot(c);
        var r = await provider.resetClient(c.id!);
        if (response.statusCode <= 205 && r.statusCode <= 205) {
          add(FetchData());
          alertCubit.showDialog(ShowDialogEvent(
            title: "CLIENTE RESETEADO",
            message: "Se ha reseteado un cliente",
            type: AlertType.success,
          ));
        } else {
          alertCubit.showDialog(ShowDialogEvent(
            title: "ERROR RESETEANDO CLIENTE",
            message: "Ha ocurrido un error inesperado reseteando el cliente: ${r.body}",
            type: AlertType.error,
          ));
        }
      },
    );
  }

  init() {
    add(FetchData());
  }
}
