import 'dart:io';
import 'package:startickera/Data/database/databse_firebase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Core/utils/format.dart';
import '../../../Data/Services/navigator_service.dart';
import '../../../Data/Services/printer_service.dart';
import '../../../Data/Provider/mikrotik/mk_provider.dart';
import '../../../Routes/route.dart';
import '../../../Widgets/qr_dialog.dart';
import '../../Alerts/alert_cubit.dart';
import '../../Session/session_cubit.dart';
import 'home_events.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AlertCubit alertCubit;
  final MkProvider provider;
  final SessionCubit sessionCubit;

  HomeBloc(this.alertCubit, this.sessionCubit, {required this.provider})
      : super(const HomeState()) {
    on<FetchData>(
      (event, emit) async {
        // if(sessionCubit.state.cfg!.password == "1234"){
        //   alertCubit.showAlertInfo(
        //     title: "Recomendacion",
        //     subtitle: "su contraseña esta por defecto, cambiarla en la configuracion",
        //   );
        // }

        emit(state.copyWith(load: true));
        var profiles = (await provider.allProfiles())
            .where((element) => element.metadata!.type! == "1")
            .toList();
        emit(state.copyWith(load: false, profiles: profiles));
      },
    );
    on<VirtualTicketScanned>(
      (event, emit) async {
        emit(state.copyWith(currentUser: event.qr));
        // alertCubit.showDialog(
        //   // ShowDialogEvent(
        //   //   title: "SELECCIONE UN PLAN",
        //   //   message: "Clave: ${event.qr}",
        //   //   type: AlertType.info,
        //   // ),
        // );
      },
    );
    on<VirtualTicketDismissed>(
          (event, emit) async {
        emit(state.copyWith(currentUser: null));
      },
    );
    on<GeneratedTicket>(
      (event, emit) async {
        if (!event.isVirtualTicket && !sessionCubit.state.cfg!.disablePrint) {
          if ((!sessionCubit.state.cfg!.disablePrint &&
              sessionCubit.state.cfg?.bluetoothDevice != null &&
              !(sessionCubit.state.cfg?.bluetoothDevice?.isConnected ??
                  false))) {
            await sessionCubit.state.cfg?.bluetoothDevice
                ?.connect(timeout: const Duration(seconds: 20));
          }

          if (!sessionCubit.state.cfg!.disablePrint) {
            if (sessionCubit.state.cfg?.bluetoothDevice?.isConnected ?? false) {
              sessionCubit.changeState(sessionCubit.state.copyWith(
                  configModel: sessionCubit.state.cfg!.copyWith(
                      bluetoothDevice: sessionCubit.state.cfg?.bluetoothDevice)));
            } else {
              alertCubit.showDialog(ShowDialogEvent(
                title: "ERROR",
                message: "No se ha detectado ninguna impresora",
                type: AlertType.warning,
              ));
              NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
              return;
            }
          }
        }



        String user="";
        if (event.isVirtualTicket) {
          user = state.currentUser;
        } else {
          user = event.name;
        }

        late Response r;
        try {
          String validDuration = _validDuration(event.duration);
          r = await provider.newTicket(
              user.toLowerCase(), event.profile, validDuration,
              limitBytesTotal: event.limitMb);
        } on UserAlreadyExist {

          alertCubit.showDialog(
            ShowDialogEvent(
              title: "USUARIO YA EXISTE",
              message:
                  "Posiblemente el usuario ya se encuentre registrado en el sistema",
              type: AlertType.error,
            ),
          );
          return;
        } catch (e) {
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ERROR",
              message:
                  "Ha ocurrido un error inesperado registrando el usuario",
              type: AlertType.error,
            ),
          );
          return;
        }
        if (r.statusCode == 200 || r.statusCode == 201) {
          // alertCubit.showDialog("Exito","Se ha creado un nuevo ticket");
          DatabaseFirebase databaseFirebase = DatabaseFirebase();
          databaseFirebase.updateSeller(
              user, event.price, event.duration, event.profile);
          TicketDialogUtils.showNewTicketDetailDialog(
              configModel: sessionCubit.state.cfg!,
              user: user,
              price: event.price,
              duration: formatDuration(event.duration));
          if (state.currentUser == "") {
            // alertCubit.showDialog(
            //   ShowDialogEvent(
            //     title: "TICKET GENERADO",
            //     message: "Imprimiendo el ticket",
            //     type: AlertType.success,
            //   ),
            // );
          }
        } else {
          alertCubit.showDialog(
            ShowDialogEvent(
              title: "ERROR",
              message: "Ha ocurrido un problema: ${r.body}",
              type: AlertType.error, // TODO: emit domain error
            ),
          );
        }
        if (state.currentUser == "" && !sessionCubit.state.cfg!.disablePrint) {
          PrinterService().printTicket(
              user: event.name.toUpperCase(),
              configModel: sessionCubit.state.cfg,
              price: event.price,
              duration: event.duration);
        }
        emit(state.copyWith(currentUser: ""));
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

  String _validDuration(String duration) {
    String days="",hours="00",min="00";

    if(duration.contains("m")){
      min = duration.substring(0,duration.length - 1);
    }else if(duration.contains("h")){
      hours = duration.substring(0,duration.length - 1);
    }else if(duration.contains("d")){
      days = "$duration-";
    }

    return "$days$hours:$min:00";
  }
}

