import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Data/Provider/TicketProvider.dart';
import '../../Alerts/AlertCubit.dart';
import 'HomeEvents.dart';
import 'HomeState.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AlertCubit alertCubit;
  final TicketProvider provider;

  HomeBloc(this.alertCubit, {required this.provider})
      : super(const HomeState()) {
    on<FetchData>(
      (event, emit) async {
        emit(state.copyWith(load: true));
        var data = await provider.allTickets();
        var profiles = await provider.allProfiles();
        emit(state.copyWith(load: false, tickets: data,profiles: profiles));
      },
    );

    on<ShareQRImage>((event, emit) async {
      final image = await QrPainter(
        data: "https://host?user=${event.user}&=password=${event.password}",
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
      await Share.shareXFiles([XFile(file.path,mimeType: ".png")],text: "${event.user} ${event.password}"); // Share the generated image using the share_plus package
    });
  }

  init() {
    add(FetchData());
  }
}
