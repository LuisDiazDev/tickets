import 'dart:async';
import 'package:StarTickera/Widgets/starlink/button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../Data/Provider/MkProvider.dart';
import '../../../../Data/Services/navigator_service.dart';
import '../../../../Widgets/starlink/button_card.dart';
import '../../../../Widgets/starlink/colors.dart';
import '../../../../Widgets/starlink/percentage_progress_circle.dart';
import '../../../../Widgets/starlink/text_style.dart';

class IpSearch {
  Future<FoundMikrotik?> showDialogSearch(
      {BuildContext? context, isCancellable = true, String ip = ""}) async {
    if (NavigatorService.navigatorKey.currentState?.overlay?.context == null) {
      return null;
    }
    FoundMikrotik? foudMikrotik = await showDialog(
      barrierDismissible: false,
      context: NavigatorService.navigatorKey.currentState!.overlay!.context,
      builder: (context) {
        return const IpSearchDialog();
      },
    );
    return foudMikrotik;
  }
}

class MergeResult {
  final bool wasMerged;
  final FoundMikrotik value;

  MergeResult(this.wasMerged, this.value);
}

// Asegúrate de que tu clase de diálogo sea un StatefulWidget
class IpSearchDialog extends StatefulWidget {
  const IpSearchDialog({super.key});

  @override
  IpSearchDialogState createState() => IpSearchDialogState();
}

class IpSearchDialogState extends State<IpSearchDialog> {
  MkProvider mkProvider = MkProvider();
  late Stream<FoundMikrotik> result;
  final ValueNotifier<int> scannedIPCount = ValueNotifier<int>(0);
  Map<String, FoundMikrotik> foundMikrotiksMap = {};

  @override
  void initState() {
    super.initState();
    result = mkProvider.findMikrotiksInLocalNetwork(scannedIPCount);
    result.listen((event) {
      String key = event.ipv4 ?? "";
      if (key.isEmpty) {
        key = event.ipv6 ?? "";
      }
      if (key.isEmpty) {
        key = event.mac ?? "";
      }
      if (key.isEmpty) {
        return;
      }
      if (foundMikrotiksMap.containsKey(key)) {
        var mr = merge(foundMikrotiksMap[key]!, event);
        if (mr.wasMerged) {
          foundMikrotiksMap[key] = mr.value;
          setState(() {});
        }
      } else {
        foundMikrotiksMap[key] = event;
        setState(() {});
      }
    });
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (scannedIPCount.value < 500) {
        scannedIPCount.value += 10;
      } else {
        timer.cancel(); // Detener el temporizador después de 40 segundos
      }
    });
  }

  MergeResult merge(FoundMikrotik a, FoundMikrotik b) {
    bool wasMerged = false;
    if (a.ipv4 == null && b.ipv4 != null) {
      a.ipv4 = b.ipv4;
      wasMerged = true;
    }
    if (a.ipv6 == null && b.ipv6 != null) {
      a.ipv6 = b.ipv6;
      wasMerged = true;
    }
    if (a.mac == null && b.mac != null) {
      a.mac = b.mac;
      wasMerged = true;
    }
    if (a.name == null && b.name != null) {
      a.name = b.name;
      wasMerged = true;
    }
    if (a.name == null && b.name != null) {
      a.name = b.name;
      wasMerged = true;
    }
    if (a.identity == null && b.identity != null) {
      a.identity = b.identity;
      wasMerged = true;
    }
    if (a.softwareVersion == null && b.softwareVersion != null) {
      a.softwareVersion = b.softwareVersion;
      wasMerged = true;
    }
    if (a.uptime == null && b.uptime != null) {
      a.uptime = b.uptime;
      wasMerged = true;
    }
    if (a.boardName == null && b.boardName != null) {
      a.boardName = b.boardName;
      wasMerged = true;
    }
    if (a.boardImageUrl == null && b.boardImageUrl != null) {
      a.boardImageUrl = b.boardImageUrl;
      wasMerged = true;
    }
    if (a.interfaceName == null && b.interfaceName != null) {
      a.interfaceName = b.interfaceName;
      wasMerged = true;
    }
    if (a.model == null && b.model != null) {
      a.model = b.model;
      wasMerged = true;
    }
    return MergeResult(wasMerged, a);
  }

  @override
  Widget build(BuildContext context) {
    // Tu código de diálogo aquí, con algunas modificaciones:
    return AlertDialog(
      contentPadding: const EdgeInsets.all(2),
      title: StarlinkText("BUSCANDO UN MIKROTIK"),
      backgroundColor: StarlinkColors.darkGray,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: ValueListenableBuilder<int>(
                valueListenable: scannedIPCount,
                builder: (context, value, child) {
                  return StarlinkProgressCircle(
                    percent: ((scannedIPCount.value.floorToDouble() /
                                500.floorToDouble()) *
                            100.0)
                        .toInt(),
                  );
                },
              ),
            ),
            const Gap(20),
            SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, snapshot) {
                  if (foundMikrotiksMap.isEmpty) {
                    return StarlinkText("BUSCANDO...");
                  }
                  return Column(
                    children: [
                      StarlinkText("MIKROTIKS ENCONTRADOS:"),
                      const SizedBox(height: 20),
                      _buildFoundMikrotiksList(),
                      const Gap(20),
                      StarlinkButton(
                        text: "CERRAR",
                        onPressed: () async {
                          // NavigatorService.navigatorKey.currentState!.pop();
                          NavigatorService.goBack();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Column _buildFoundMikrotiksList() {
    return Column(
      children: foundMikrotiksMap.values
          .map(
            (e) => Builder(builder: (context) {
              String title = e.ipv4 ?? e.ipv6 ?? e.mac ?? "";
              String subtitle = "";
              if (e.name != null) {
                subtitle = e.name!;
              }
              if (e.boardName != null) {
                if (subtitle.isNotEmpty) {
                  subtitle += "\n";
                }
                subtitle += e.boardName!;
              }
              if (e.mac != null) {
                if (subtitle.isNotEmpty) {
                  subtitle += "\n";
                }
                subtitle += e.mac!;
              }
              late Widget suffixWidget;
              if (e.boardImageUrl != null) {
                suffixWidget = Image.network(
                  e.boardImageUrl!,
                  width: 50,
                  height: 50,
                );
              } else {
                suffixWidget = const Icon(
                  Icons.router_outlined,
                  color: Colors.white,
                );
              }
              return StarlinkButtonCard(
                title: title,
                subtitle: subtitle,
                onPressed: () async {
                  if (NavigatorService.navigatorKey.currentState!.canPop()) {
                    NavigatorService.navigatorKey.currentState!.pop(e);
                  }
                },
                suffixWidget: suffixWidget,
              );
            }),
          )
          .toList(),
    );
  }
}
