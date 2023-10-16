import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/providers/p_coach.dart';
import 'package:fithouse_mobile/core/providers/p_cours.dart';
import 'package:fithouse_mobile/core/providers/p_etablissement.dart';
import 'package:fithouse_mobile/views/v_deailscoursp.dart';
import 'package:fithouse_mobile/views/v_deatilcoach.dart';
import 'package:fithouse_mobile/views/v_detailscours.dart';
import 'package:fithouse_mobile/views/v_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import '../utilities/constant.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/env.dart';

class PublicPage extends StatefulWidget {
  const PublicPage({
    super.key,
  });

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
  final EtablissementController etablissementController =
      Get.put(EtablissementController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Visiteur',
            style: GoogleFonts.amaranth(fontSize: 25),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back when the back button in the app bar is pressed
              Navigator.pop(context);
            },
          ),
        ),
        body: GetBuilder<EtablissementController>(builder: (controller) {
          return ListView.builder(
            itemCount: 7,
            itemBuilder: (_, i) {
              if (i < 1)
                return Column(
                  children: [
                    // Container(
                    //   // set the width of the container
                    //   height: 50, // set the height of the container
                    //   color: Colors.white, // set the color of the container
                    //   child: Center(
                    //     child: ClipPath(
                    //       clipper: OvalRightBorderClipper(),
                    //       child: Container(
                    //         height: 50,
                    //         color: const Color.fromARGB(184, 228, 142, 21),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, bottom: 7),
                      child: Container(
                        color: Colors.white,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Cours",
                              style: GoogleFonts.amaranth(fontSize: 25),
                            )),
                      ),
                    ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    _horizontalScrollSnapList2(), // assuming this returns a Widget
                  ],
                );
              else if (i < 2)
                return Column(
                  children: [
                    // Container(
                    //   // set the width of the container
                    //   height: 50, // set the height of the container
                    //   color: Colors.white, // set the color of the container
                    //   child: Center(
                    //     child: ClipPath(
                    //       clipper: OvalRightBorderClipper(),
                    //       child: Container(
                    //         height: 50,
                    //         color: const Color.fromARGB(184, 228, 142, 21),
                    SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, bottom: 7),
                      child: Container(
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Etablissement",
                              style: GoogleFonts.amaranth(fontSize: 25)),
                        ),
                      ),
                    ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    _horizontalScrollSnapList(), // assuming this returns a Widget
                  ],
                );
              else if (i == 2)
                return Column(
                  children: [
                    // Container(
                    //   // set the width of the container
                    //   height: 50, // set the height of the container
                    //   color: Colors.white, // set the color of the container
                    //   child: Center(
                    //     child: ClipPath(
                    //       clipper: OvalRightBorderClipper(),
                    //       child: Container(
                    //         height: 50,
                    //         color: const Color.fromARGB(184, 228, 142, 21),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, bottom: 7),
                      child: Container(
                        color: Colors.white,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Coach",
                            style: GoogleFonts.amaranth(fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    _horizontalScrollSnapList3(), // assuming this returns a Widget
                  ],
                );
            },
          );
        }),
      ),
    );
  }

  Widget _horizontalScrollSnapList() {
    final etablissementController = Get.put(
        EtablissementController()); // create an instance of EtablissementController and register it with the GetX framework
    return Obx(() {
      if (etablissementController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        final etablissements = etablissementController.etablissements;
        return SizedBox(
          height: 230,
          child: ScrollSnapList(
            itemSize: 200,
            itemBuilder: (context, index) => _buildBox2(
                etablissements[index].nomEtablissement.toString(),
                etablissements[index].image.toString(),
                etablissements[index].adresseEtablissement.toString(),
                etablissements[index].ville.toString(),
                etablissements[index].teletablissement.toString(),
                etablissements[index].sitewebetablissement.toString(),
                etablissements[index].mailetablissement.toString(),
                etablissements[index].description.toString(),
                etablissements[index].facebook.toString(),
                etablissements[index].instagram.toString(),
                etablissements[index].wtp.toString()),

            itemCount: etablissements.length,
            onItemFocus: (index) {
              // handle item focus
            },
            dynamicItemSize: true, // set to true if item sizes vary
            // other ScrollSnapList properties can be set here as well
          ),
        );
      }
    });
  }

  Widget _buildBox(String civilite, String imageUrl, String nomcoach,
          String prenomcoach, String email, String desc) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsCoach(
                civilite: civilite,
                imageUrl: imageUrl,
                nomcoach: nomcoach,
                prenomcoach: prenomcoach,
                email: email,
                desc: desc,
              ),
            ),
          );
        },
        child: SizedBox(
          width: 200,
          height: 300,
          child: Card(
            elevation: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: Image.network(
                      '${API.MEDIA_ENDPOINT}${imageUrl}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            nomcoach + ' ' + prenomcoach,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget _buildBox2(
          String nom,
          String imageUrl,
          String adresse,
          String ville,
          String tel,
          String site,
          String mail,
          String desc,
          String face,
          String insta,
          String wtp) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                nom: nom,
                imageUrl: imageUrl,
                adresse: adresse,
                ville: ville,
                tel: tel,
                site: site,
                mail: mail,
                desc: desc,
                face: face,
                insta: insta,
                wtp: wtp,
              ),
            ),
          );
        },
        child: SizedBox(
          width: 200,
          height: 300,
          child: Card(
            elevation: 12,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: Image.network(
                      '${HOST}/media/${imageUrl}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              nom,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                Icon(Icons.place, color: Colors.blueGrey),
                                Text(
                                  ville,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget _buildBox3(String nom, String imageUrl, String reglement, String genre,
          String desc) =>
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsCoursp(
                  nom: nom,
                  imageUrl: imageUrl,
                  reglement: reglement,
                  genre: genre,
                  desc: desc),
            ),
          );
        },
        child: SizedBox(
          width: 200,
          height: 300,
          child: Card(
            elevation: 12,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: Image.network(
                      '${API.MEDIA_ENDPOINT}${imageUrl}',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    child: Row(
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              nom,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              genre == 'Homme' || genre == 'homme'
                                  ? Icon(Icons.man, color: Colors.blue)
                                  : (genre == 'Femme' || genre == 'femme')
                                      ? Icon(Icons.woman, color: Colors.pink)
                                      : Row(
                                          children: [
                                            Icon(Icons.man, color: Colors.blue),
                                            Icon(Icons.woman,
                                                color: Colors.pink),
                                          ],
                                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  Widget _horizontalScrollSnapList2() {
    final courController = Get.put(
        CourController()); // create an instance of EtablissementController and register it with the GetX framework
    return Obx(() {
      if (courController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        final cours = courController.cours;
        return SizedBox(
          height: 230,
          child: ScrollSnapList(
            itemSize: 200,
            itemBuilder: (context, index) => _buildBox3(
                cours[index].nomCours.toString(),
                cours[index].image.toString(),
                cours[index].reglement.toString(),
                cours[index].genre.toString(),
                cours[index].description.toString()),
            itemCount: cours.length,
            onItemFocus: (index) {
              // handle item focus
            },
            dynamicItemSize: true, // set to true if item sizes vary
            // other ScrollSnapList properties can be set here as well
          ),
        );
      }
    });
  }
  // Widget _horizontalScrollSnapList2() {
  //   final courController = Get.put(
  //       CourController()); // create an instance of EtablissementController and register it with the GetX framework
  //   return Obx(() {
  //     if (courController.isLoading.value) {
  //       return Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     } else {
  //       final cours = courController.cours;
  //       return SizedBox(
  //         height: 250,
  //         child: ScrollSnapList(
  //           itemSize: 200,
  //           itemBuilder: (context, index) => _buildBox(
  //               cours[index].nomCours.toString(),
  //               cours[index].image.toString()),
  //           itemCount: cours.length,
  //           onItemFocus: (index) {
  //             // handle item focus
  //           },
  //           dynamicItemSize: true, // set to true if item sizes vary
  //           // other ScrollSnapList properties can be set here as well
  //         ),
  //       );
  //     }
  //   });
  // }

  // Widget _buildBox2(String address) => Container(
  //       margin: EdgeInsets.all(5),
  //       height: 200,
  //       width: 200,
  //       child: Column(
  //         children: [
  //           Expanded(
  //             child: Container(
  //               height: 80,
  //               child: FilledButton.tonal(
  //                 child: Text(address),
  //                 onPressed: () => null,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );

  Widget _horizontalScrollSnapList3() {
    final coachController = Get.put(
        CoachController()); // create an instance of EtablissementController and register it with the GetX framework
    return Obx(() {
      if (coachController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        final coachs = coachController.coachs;
        return SizedBox(
          height: 220,
          child: ScrollSnapList(
            itemSize: 200,
            itemBuilder: (context, index) => _buildBox(
                coachs[index].civilite.toString(),
                coachs[index].image.toString(),
                coachs[index].nomCoach.toString(),
                coachs[index].prenomCoach.toString(),
                coachs[index].mail.toString(),
                coachs[index].description.toString()),
            itemCount: coachs.length,
            onItemFocus: (index) {
              // handle item focus
            },
            dynamicItemSize: true, // set to true if item sizes vary
            // other ScrollSnapList properties can be set here as well
          ),
        );
      }
    });
  }
}
