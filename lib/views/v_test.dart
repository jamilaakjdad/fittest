import 'dart:ui';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utilities/env.dart';

class DetailsPage extends StatefulWidget {
  final String nom;

  final String imageUrl;
  final String adresse;
  final String ville;
  final String tel;
  final String site;
  final String mail;
  final String desc;
  final String face;
  final String insta;
  final String wtp;

  const DetailsPage(
      {Key? key,
      required this.nom,
      required this.imageUrl,
      required this.adresse,
      required this.ville,
      required this.tel,
      required this.site,
      required this.mail,
      required this.desc,
      required this.face,
      required this.insta,
      required this.wtp})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  whatsapp() async {
    String url = 'whatsapp://send?phone=${widget.wtp}';

    await launchUrl(Uri.parse(url));
  }

  Future<void> _dialCall() async {
    String phoneNumber = widget.tel.toString();
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  // final String lat = '34.0017307';
  // final String lng = '-4.9721519';
  // _launchMap() async {
  //   final String googleMapsUlr =
  //       'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
  //   launchUrl(Uri.parse(googleMapsUlr));
  // }

  @override
  Widget build(BuildContext context) {
    print(widget.wtp);
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.network(
              '${API.MEDIA_ENDPOINT}${widget.imageUrl}',
              fit: BoxFit.cover,
            ),
          ),
          buttonArrow(context),
          scroll(),
        ],
      ),
    ));
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 1.0,
        minChildSize: 0.65,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 5,
                            width: 35,
                            color: Colors.black12,
                          )
                        ],
                      ),
                    ),
                    Text(
                      widget.nom,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .merge(TextStyle(color: Colors.blueGrey)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.adresse,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              LineAwesomeIcons.map_marker,
                              color: Colors.blueGrey,
                            ),
                            Text(widget.ville,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .merge(TextStyle(color: Colors.blueGrey)))
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.blueGrey,
                            ),
                            TextButton(
                              onPressed: () {
                                _dialCall();
                              },
                              child: Text(
                                widget.tel,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .merge(TextStyle(color: Colors.blueGrey)),
                              ),
                            )
                            // Text(widget.tel,
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .titleMedium!
                            //         .merge(TextStyle(color: Colors.blueGrey)))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse(widget.site),
                            mode: LaunchMode.externalApplication);
                      },
                      child: Text(
                        widget.site,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .merge(TextStyle(color: Colors.blueGrey)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: widget.mail,
                            query:
                                'j espere que notre club vous plait tu peux ecrire ici');
                        launchUrl(emailUri);
                      },
                      child: Text(widget.mail,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .merge(TextStyle(color: Colors.blueGrey))),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(
                        height: 4,
                      ),
                    ),
                    Text(
                      'Description',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.desc),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Contact',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Colors.black),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          IconButton(
                              iconSize: 72,
                              color: Colors.green,
                              onPressed: () {
                                whatsapp();
                              },
                              icon: Icon(LineAwesomeIcons.what_s_app)),
                          IconButton(
                              iconSize: 72,
                              color: Colors.blue,
                              onPressed: () {
                                launchUrl(Uri.parse(widget.face),
                                    mode: LaunchMode.externalApplication);
                              },
                              icon: Icon(LineAwesomeIcons.facebook)),
                          IconButton(
                              iconSize: 72,
                              color: Color.fromARGB(255, 250, 126, 30),
                              onPressed: () {
                                launchUrl(Uri.parse(widget.insta),
                                    mode: LaunchMode.externalApplication);
                              },
                              icon: Icon(LineAwesomeIcons.instagram)),
                          IconButton(
                              iconSize: 72,
                              color: Color.fromARGB(255, 250, 126, 30),
                              onPressed: () {
                                // _launchMap();
                                launchUrl(Uri.parse(
                                    'https://goo.gl/maps/3j3Ao5pxDBQCgpKf9'));
                              },
                              icon: Icon(LineAwesomeIcons.map_marked)),
                        ],
                      ),
                    )
                  ]),
            ),
          );
        });
  }
}
