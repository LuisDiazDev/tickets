import 'dart:io';

import 'package:StarTickera/models/ticket_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Core/utils/rand.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../Alerts/AlertCubit.dart';
import 'TicketsEvents.dart';
import 'TicketsState.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final AlertCubit alertCubit;
  final MkProvider provider;

  TicketsBloc(this.alertCubit, {required this.provider})
      : super(const TicketsState()) {
    on<FetchData>(
      (event, emit) async {
        emit(state.copyWith(load: event.load));
        // Hacer en paralelo
        var data = await provider.allTickets();//todo: only users whit not client plans
        var profiles = (await provider.allProfiles()).where((element) => element.metadata!.type! == "1").toList();

        List<TicketModel> tickets = [];

        for (var p in profiles){
          var ts = data.where((t) => t.profile == p.fullName);
          tickets.addAll(ts);
        }

        tickets.sort((a,b)=>b.id!.compareTo(a.id!));

        emit(state.copyWith(load: false, tickets: tickets, profiles: profiles));
      },
    );

    on<GenerateTicket>(
      (event, emit) async {

        var cant = double.tryParse(event.cant) ?? 1;

        for (int i = 0; i < cant; i++){
          var name =  generatePassword();
          await provider.newTicket(name, event.profile,event.duration);

          //generated
          add(FetchData());
        }
        // TODO: evaluar si esto es necesario
        var data = await provider.allTickets();
        emit(state.copyWith(load: false, tickets: data));
      },
    );

    on<ShareQRImage>((event, emit) async {
      final image = await QrPainter(
        data: "https://${event.host}/login?user=${event.user}&=password=${event.password}",
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(200.0); // Generate QR code image data

      const filename = 'qr_code.png';
      final tempDir =
          await getApplicationDocumentsDirectory(); // Get temporary directory to store the generated image
      final file = await File('${tempDir.path}/$filename')
          .create(); // Create a file to store the generated image
      var bytes = image!.buffer.asUint8List(); // Get the image bytes
      await file.writeAsBytes(bytes); // Write the image bytes to the file
      await Share.shareXFiles([XFile(file.path, mimeType: ".png")],
          text:
              "${event.user} ${event.password}"); // Share the generated image using the share_plus package
    });

    on<DeletedTicket>((event,emit)async{
      var r = await provider.removeTicket(event.id);
      if(r.statusCode <= 205 ){
        add(FetchData(load: false));
        alertCubit.showDialog(ShowDialogEvent(
          title: "ÉXITO",
          message: "Se ha eliminado el ticket",
          type: AlertType.success,
        ));
      } else{
        add(FetchData(load: false));
        alertCubit.showDialog(ShowDialogEvent(
          title: "ERROR",
          message: "Ha ocurrido un error inesperado eliminando el ticket",
          type: AlertType.error,
        ));
      }

    });
  }

  init() {
    add(FetchData());
  }
}
