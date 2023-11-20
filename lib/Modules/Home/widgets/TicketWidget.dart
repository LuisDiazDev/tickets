import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickets/Core/Values/Colors.dart';
import 'package:tickets/models/ticket_model.dart';
import 'package:badges/badges.dart' as badges;

import '../bloc/HomeBloc.dart';
import '../bloc/HomeEvents.dart';

class CustomTicketWidget extends StatelessWidget {
  final TicketModel ticket;

  const CustomTicketWidget({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipPath(
        clipper: CustomTicketClipper(), // <-- CustomClipper
        child: Container(
            color:  ColorsApp.secondary.withOpacity(.4), // <-- background color
            height: 115, // <-- height
            width: 190, // <-- width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 14),
                          child: Text(
                            ticket.name ?? "",
                            style: const TextStyle(
                              color: ColorsApp.primary,
                              fontSize: 18,
                              fontFamily: "poppins_regular",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0, left: 14),
                          child: Text("${ticket.password?[0] ?? "*"}*****",
                              style: const TextStyle(
                                color: ColorsApp.primary,
                                  fontSize: 14,
                                  fontFamily: "poppins_semi_bold",
                                  fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                    Spacer(),
                    const badges.Badge(
                      badgeContent: Text(
                        '01',
                        style:
                            TextStyle(color: ColorsApp.primary, fontSize: 14),
                      ),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: ColorsApp.secondary,
                      ),
                      child: Icon(
                        EvaIcons.calendarOutline,
                        color: ColorsApp.primary,
                        size: 32,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
               Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(top: 8.0, left: 10),
                     child: TextButton(
                       onPressed: () {
                         print("imprimir");
                       },
                       child: const Text(
                         "Imprimir",
                         style: TextStyle(
                             fontSize: 16,
                             color: ColorsApp.secondary,
                             fontFamily: "poppins_semi_bold",
                             fontWeight: FontWeight.w400),
                       ),
                     ),
                   ),
                   Spacer(),
                   Padding(
                     padding: const EdgeInsets.only(top: 10.0),
                     child: IconButton(
                         onPressed: (){
                          homeBloc.add(ShareQRImage(
                              ticket.name??"",
                              ticket.password??""
                          ));
                     }, icon: Icon(EvaIcons.shareOutline,color: ColorsApp.secondary,)),
                   )
                 ],
               )
              ],
            )),
      ),
    );
  }
}

class CustomTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    //Radius
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(8),
      ),
    );

    // Left Round In
    path.addOval(
      Rect.fromCircle(
        center: Offset(0, (size.height / 3) * 1.8), // Position Roun In Left
        radius: 10, // Size
      ),
    );

    // Right Round In
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, (size.height / 3) * 1.8),
        // Position Roun In Right
        radius: 10, // Size
      ),
    );

    // Horizontal Line Dash
    const dashWidth = 10;
    const dashSpace = 5;
    final dashCount = size.width ~/ (dashWidth + dashSpace);

    for (var i = 0; i < dashCount; i++) {
      path.addRect(
        Rect.fromLTWH(
          i * (dashWidth + dashSpace).toDouble() + 10,
          (size.height / 3) * 1.8,
          dashWidth.toDouble(),
          1,
        ),
      );
    }

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
