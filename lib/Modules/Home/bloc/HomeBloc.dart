import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Data/Services/navigator_service.dart';
import '../../../Data/Services/printer_service.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../../../Routes/Route.dart';
import '../../../Widgets/qr_dialog.dart';
import '../../Alerts/AlertCubit.dart';
import '../../Session/SessionCubit.dart';
import 'HomeEvents.dart';
import 'HomeState.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AlertCubit alertCubit;
  final TicketProvider provider;
  final SessionCubit sessionCubit;

  HomeBloc(this.alertCubit,this.sessionCubit, {required this.provider})
      : super(const HomeState()) {
    on<FetchData>(
      (event, emit) async {
        emit(state.copyWith(load: true));
        var profiles = await provider.allProfiles();
        emit(state.copyWith(load: false, profiles: profiles));

        if(sessionCubit.state.cfg?.contact == "" || sessionCubit.state.cfg?.nameBusiness == ""){
          NavigatorService.pushNamedAndRemoveUntil(Routes.settings,arguments: "Por favor escriba los datos del negocio");
        }
      },
    );

    on<GeneratedTicket>(
      (event, emit) async {
        if(!(sessionCubit.state.cfg?.connected ?? false)){
          if (sessionCubit.state.cfg?.bluetoothDevice != null) {
            await sessionCubit.state.cfg?.bluetoothPrintService.connect(sessionCubit.state.cfg!.bluetoothDevice!);
            sessionCubit.state.cfg?.connected = true;
          }
        }
        if(sessionCubit.state.cfg?.connected ?? false){
          var r = await provider.newTicket(event.name, event.profile,event.duration);
          if(r.statusCode == 200 || r.statusCode == 201){
            // alertCubit.showDialog("Exito","Se ha creado un nuevo ticket");
            TicketDialogUtils.showDialogT(
                configModel: sessionCubit.state.cfg!,
                user: event.name,
                price: event.price,
                duration: event.duration
            );
            alertCubit.showAlertInfo(
              title: "Imprimiendo",
              subtitle: "Espere un momento",
            );
          }else{
            alertCubit.showAlertInfo(title: "Error", subtitle: "Ah ocurrido un problema");
          }
          emit(state.copyWith(load: false,));
          if(!PrinterService.isProgress){
            PrinterService().printerB(user: event.name,configModel: sessionCubit.state.cfg,price: event.price,duration: event.duration);
          }

        }else{
          alertCubit.showDialog("Error", "No se ha detectado ninguna impresora conectada");
          NavigatorService.pushNamedAndRemoveUntil(Routes.settings);
        }
      },
    );

    on<ShareQRImage>((event, emit) async {
      final image = await QrPainter(
        data: "http://ticketwifi.net?user=${event.user}&=password=${event.password}",
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
