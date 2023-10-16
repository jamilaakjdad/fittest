import 'dart:ui';
import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:fithouse_mobile/utilities/constant.dart';
import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/v_acceuil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/env.dart';

class DetailsCoach extends StatefulWidget {
  final String civilite;
  final String imageUrl;
  final String nomcoach;
  final String prenomcoach;
  final String email;
  final String desc;
  const DetailsCoach({
    Key? key,
    required this.civilite,
    required this.imageUrl,
    required this.nomcoach,
    required this.prenomcoach,
    required this.email,
    required this.desc,
  }) : super(key: key);

  @override
  _DetailsCoachState createState() => _DetailsCoachState();
}

class _DetailsCoachState extends State<DetailsCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image
          Image.network(
            '${API.MEDIA_ENDPOINT}${widget.imageUrl}',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Dégradé pour la partie noire
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(1),
                    Colors.black,
                  ],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstATop,
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        'Coach ' + widget.prenomcoach,
                        style: GoogleFonts.amaranth(
                            fontSize: 35, color: Colors.white),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    //   child: Text(
                    //     'Description',
                    //     style: GoogleFonts.amaranth(
                    //         fontSize: 25, color: Colors.white),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: widget.desc != null
                          ? Text(
                              widget.desc,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )
                          : Text(''),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Icône étoile en haut à gauche de l'image
          Positioned(
              top: 40,
              left: 16,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black87),
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )),
              )),
        ],
      ),
    );
  }
  //////////////
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //       child: Scaffold(
  //     body: Stack(
  //       children: [
  //         SizedBox(
  //           width: double.infinity,
  //           child: Image.network(
  //             '${API.MEDIA_ENDPOINT}${widget.imageUrl}',
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         buttonArrow(context),
  //         scroll(),
  //       ],
  //     ),
  //   ));
  // }

  // buttonArrow(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: InkWell(
  //       onTap: () {
  //         Navigator.pop(context);
  //       },
  //       child: Container(
  //           clipBehavior: Clip.hardEdge,
  //           height: 40,
  //           width: 40,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(25),
  //           ),
  //           child: BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //             child: Container(
  //               height: 55,
  //               width: 55,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(25),
  //                   color: Colors.black87),
  //               padding: EdgeInsets.only(left: 8),
  //               child: Icon(
  //                 Icons.arrow_back_ios,
  //                 size: 20,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           )),
  //     ),
  //   );
  // }

  // scroll() {
  //   return DraggableScrollableSheet(
  //       initialChildSize: 0.5,
  //       maxChildSize: 1.0,
  //       minChildSize: 0.5,
  //       builder: (context, scrollController) {
  //         return Container(
  //           padding: EdgeInsets.symmetric(horizontal: 20),
  //           clipBehavior: Clip.hardEdge,
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(20),
  //                   topRight: Radius.circular(20))),
  //           child: SingleChildScrollView(
  //             controller: scrollController,
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 10, bottom: 25),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Container(
  //                           height: 5,
  //                           width: 35,
  //                           color: Colors.black12,
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   Text(
  //                     'Coach ' + widget.prenomcoach,
  //                     style: Theme.of(context)
  //                         .textTheme
  //                         .titleLarge!
  //                         .merge(TextStyle(color: Colors.blueGrey)),
  //                   ),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           // Icon(
  //                           //   Icons.email,
  //                           //   color: Colors.blue,
  //                           // ),
  //                           // Text('  ' + widget.email,
  //                           //     style: Theme.of(context)
  //                           //         .textTheme
  //                           //         .titleMedium!
  //                           //         .merge(TextStyle(color: Colors.black)))
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                   const Padding(
  //                     padding: EdgeInsets.symmetric(vertical: 5),
  //                     child: Divider(
  //                       height: 4,
  //                     ),
  //                   ),
  //                   // Text(
  //                   //   'Description',
  //                   //   style: TextStyle(
  //                   //       fontWeight: FontWeight.bold,
  //                   //       fontSize: 23,
  //                   //       color: Colors.black),
  //                   // ),
  //                   // const SizedBox(
  //                   //   height: 10,
  //                   // ),
  //                   Text(
  //                     'En tant que coach sportif passionné et expérimenté, nous sommes fiers de présenter notre coach, notre entraîneur principal au sein du Club FitHouse. ',
  //                     style: GoogleFonts.amaranth(fontSize: 25),
  //                   )
  //                 ]),
  //           ),
  //         );
  //       });
  // }
}
