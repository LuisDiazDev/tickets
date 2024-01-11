import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Core/utils/format.dart';
import '../../../Data/Services/navigator_service.dart';
import '../../../Data/Services/printer_service.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../../Routes/Route.dart';
import '../../../Widgets/qr_dialog.dart';
import '../../Alerts/AlertCubit.dart';
import '../../Session/SessionCubit.dart';
import 'HomeEvents.dart';
import 'HomeState.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AlertCubit alertCubit;
  final MkProvider provider;
  final SessionCubit sessionCubit;

  HomeBloc(this.alertCubit, this.sessionCubit, {required this.provider})
      : super(const HomeState()) {
    on<FetchData>(
      (event, emit) async {
        emit(state.copyWith(load: true));
        var profiles = await provider.allProfiles();
        emit(state.copyWith(load: false, profiles: profiles));
      },
    );
    on<NewQr>(
      (event, emit) async {
        emit(state.copyWith(currentUser: event.qr));
        alertCubit.showAlertInfo(
          title: "Por favor seleccione un plan",
          subtitle: "Clave: ${event.qr}",
        );
      },
    );
    on<GeneratedTicket>(
      (event, emit) async {
        if (state.currentUser == "" &&
            sessionCubit.state.cfg?.bluetoothDevice != null &&
            !(sessionCubit.state.cfg?.bluetoothDevice?.isConnected ?? false)) {
          await sessionCubit.state.cfg?.bluetoothDevice?.connect();
        }
        if (state.currentUser != "" ||
            (sessionCubit.state.cfg?.bluetoothDevice?.isConnected ?? false)) {
          final user = state.currentUser != "" ? state.currentUser : event.name;
          late Response r;
          try {
            r = await provider.newTicket(user, event.profile, event.duration);
          } on UserAlreadyExist {
            alertCubit.showDialog("El usuario $user ya existe", "Posiblemente el usuario ya este conectado");
            return;
          } catch (e) {
            alertCubit.showDialog("Error", "Ha ocurrido un error");
            return;
          }
          if (r.statusCode == 200 || r.statusCode == 201) {
            // alertCubit.showDialog("Exito","Se ha creado un nuevo ticket");
            TicketDialogUtils.showNewTicketDetailDialog(
                configModel: sessionCubit.state.cfg!,
                user: state.currentUser != "" ? state.currentUser : event.name,
                price: event.price,
                duration: formatDuration(event.duration));
            if (state.currentUser == "") {
              alertCubit.showAlertInfo(
                title: "Imprimiendo",
                subtitle: "Espere un momento",
              );
            }
          } else {
            alertCubit.showAlertInfo(
                title: "Error", subtitle: "Ah ocurrido un problema");
          }
          if (state.currentUser == "") {
            PrinterService().printTicket(
                user: event.name,
                configModel: sessionCubit.state.cfg,
                price: event.price,
                duration: event.duration);
          }
          emit(state.copyWith(currentUser: ""));
          // if(!PrinterService.isProgress){
          //   PrinterService().printTicket(user: event.name,configModel: sessionCubit.state.cfg,price: event.price,duration: event.duration);
          // }
        } else {
          alertCubit.showDialog(
              "Error", "No se ha detectado ninguna impresora conectada");
          NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
        }
      },
    );

    on<ShareQRImage>((event, emit) async {
      final image = await QrPainter(
        data:
            "http://ticketwifi.net?user=${event.user}&=password=${event.password}",
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(200.0); // Generate QR code image data

      const filename = 'qr_code.png';
      final tempDir =
          await getTemporaryDirectory(); // Get temporary directory to store the generated image
      final file = await File('${tempDir.path}/$filename')
          .create(); // Create a file to store the generated image
      var bytes = image!.buffer.asUint8List(); // Get the image bytes
      await file.writeAsBytes(bytes); // Write the image bytes to the file
      await Share.shareXFiles([XFile(file.path, mimeType: ".png")],
          text:
              "${event.user} ${event.password}"); // Share the generated image using the share_plus package
    });
  }

  init() {
    add(FetchData());
  }
}
