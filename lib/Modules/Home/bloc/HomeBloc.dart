import 'dart:io';
import 'package:StarTickera/Data/database/databse_firebase.dart';
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
    on<NewQr>(
      (event, emit) async {
        emit(state.copyWith(currentUser: event.qr));
        alertCubit.showInfoDialog(
          AlertInfo(
            "Por favor seleccione un plan",
            "Clave: ${event.qr}",
          ),
        );
      },
    );
    on<GeneratedTicket>(
      (event, emit) async {
        DatabaseFirebase databaseFirebase = DatabaseFirebase();
        if (state.currentUser == "" &&
            (!sessionCubit.state.cfg!.disablePrint &&
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
            alertCubit.showErrorDialog(
                "ERROR", "No se ha detectado ninguna impresora");
            NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
            return;
          }
        }

        final user = state.currentUser != "" ? state.currentUser : event.name;
        late Response r;
        try {
          r = await provider.newTicket(
              user.toLowerCase(), event.profile, event.duration,
              limitBytesTotal: event.limitMb);
        } on UserAlreadyExist {
          alertCubit.showErrorDialog("USUARIO YA EXISTE",
              "Posiblemente el usuario ya se encuentre registrado en el sistema");
          return;
        } catch (e) {
          alertCubit.showErrorDialog("ERROR",
              "Ha ocurrido un error inesperado resgistrando el usuario");
          return;
        }
        if (r.statusCode == 200 || r.statusCode == 201) {
          // alertCubit.showDialog("Exito","Se ha creado un nuevo ticket");
          databaseFirebase.updateSeller(
              user, event.price, event.duration, event.profile);
          TicketDialogUtils.showNewTicketDetailDialog(
              configModel: sessionCubit.state.cfg!,
              user: user,
              price: event.price,
              duration: formatDuration(event.duration));
          if (state.currentUser == "") {
            alertCubit
                .showInfoDialog(AlertInfo("IMPRIMIENDO", "Espere un momento"));
          }
        } else {
          alertCubit.showInfoDialog(
            AlertInfo("ERROR", "Ha ocurrido un problema: ${r.body}"),
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
        // if(!PrinterService.isProgress){
        //   PrinterService().printTicket(user: event.name,configModel: sessionCubit.state.cfg,price: event.price,duration: event.duration);
        // }
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
