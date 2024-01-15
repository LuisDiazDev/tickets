import 'dart:async';
import 'package:StarTickera/Core/Values/Colors.dart';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../Data/Provider/MkProvider.dart';
import '../../../Data/Services/navigator_service.dart';
import '../../../Widgets/starlink/button_card.dart';
import '../../../Widgets/starlink/progress_circle.dart';
import '../../../Widgets/starlink/text_style.dart';

class IpSearch {
  Future<FoundMikrotik?> showDialogSearch(
      {BuildContext? context, isCancellable = true, String ip = ""}) async {
    if (NavigatorService.navigatorKey.currentState?.overlay?.context == null) {
      return null;
    }
    MkProvider mkProvider = MkProvider();
    final ValueNotifier<int> scannedIPCount = ValueNotifier<int>(0);
    Future<List<FoundMikrotik?>> result =
        mkProvider.findMikrotiksInLocalNetwork(scannedIPCount);
    FoundMikrotik foudMikrotik = await showDialog(
      barrierDismissible: false,
      context: NavigatorService.navigatorKey.currentState!.overlay!.context,
      builder: (context) {
        return AlertDialog(
          title: StarlinkText("BUSCANDO UN MIKROTIK"),
          backgroundColor: StarlinkColors.darkGray,          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: scannedIPCount,
                builder: (context, value, child) {
                  return StarlinkProgressCircle(
                    percent: ((scannedIPCount.value.floorToDouble() /
                                250.floorToDouble()) *
                            100.0)
                        .toInt(),
                  );
                },
              ),
              const Gap(20),
              FutureBuilder(
                future: result,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return StarlinkText("BUSCANDO...");
                  }
                  if (snapshot.data!.isEmpty) {
                    return StarlinkText("NO SE ENCONTRARON MIKROTIKS");
                  }
                  return Column(
                    children: [
                      StarlinkText("MIKROTIKS ENCONTRADOS:"),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Column(
                          children: List<Widget>.generate(
                            snapshot.data!.length,
                            (index) => StarlinkButtonCard(
                              title: snapshot.data![index]!.ip,
                              onPressed: () {
                                NavigatorService.navigatorKey.currentState!
                                    .pop(snapshot.data![index]);
                              },
                              suffixIcon: const Icon(
                                Icons.router_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Gap(50),
              StarlinkButton(
                text: "VOLVER A BUSCAR",
                onPressed: () {
                  scannedIPCount.value = 0;
                  mkProvider.findMikrotiksInLocalNetwork(scannedIPCount,
                      timeoutSecs: 10);
                },
              ),
            ],
          ),
        );
      },
    );
    return foudMikrotik;
  }
}
