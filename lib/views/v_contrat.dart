import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/menu_page.dart';
import 'package:fithouse_mobile/views/menu_wideget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
// import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:intl/intl.dart';
import 'package:fithouse_mobile/core/models/m_contrat.dart';

import '../core/models/m_client.dart';
import '../utilities/constant.dart';
import 'Datab.dart';

class ContratScreen extends StatefulWidget {
  final Client paclient;
  const ContratScreen({Key? key, required this.paclient}) : super(key: key);

  @override
  State<ContratScreen> createState() => _ContratScreenState();
}

class _ContratScreenState extends State<ContratScreen> {
  List<Contrat> data = [];
  List<Contrat> init_data = [];
  bool loading = false;

  void fetchContrat() async {
    setState(() {
      loading = true;
    });
    print("loading ...");
    final data_token = await DatabaseHelper.getItems();
    final headers = {'Content-Type': 'application/json',
      "Authorization": "Bearer ${data_token[0]["token"]}",};

    final response = await http.get(Uri.parse(
        '${HOST}/api/contrat/?client_id=' +
            widget.paclient.idClient.toString()), headers: headers);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      setState(() {
        data = result.map<Contrat>((e) => Contrat.fromJson(e)).toList();
        init_data = result.map<Contrat>((e) => Contrat.fromJson(e)).toList();
      });
      print("--data--");
      print(data.length);
    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchContrat();
    print("init state");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              client: widget.paclient,
              currentItem: MenuItems.acceuil,
            ),
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Mes contrats',
            style: TextStyle(color: Colors.black),
          ),
          leading: MenuWidget(),
        ),
        body: SafeArea(
          child: data.isEmpty
              ? Center(child: Text('Vous n\'avez pas de contrat'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.all(15),
                    //   child: Text(
                    //     "Mes Contrats",
                    //     style: TextStyle(
                    //         fontSize: 24,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.black),
                    //   ),
                    // ),
                    Expanded(
                        flex: 1,
                        child: !loading
                            ? Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.blueAccent,
                                              width: 2.0,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    double.parse(data[index]
                                                                .reste
                                                                .toString()) ==
                                                            0
                                                        ? Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            size: 22,
                                                            color: Colors.green,
                                                          )
                                                        : Icon(
                                                            Icons.close_rounded,
                                                            size: 22,
                                                            color: Colors.red,
                                                          ),
                                                    SizedBox(
                                                      width: 9,
                                                    ),
                                                    Text(
                                                        "Num Contrat: ${data[index].numcontrat}"),
                                                    //SizedBox(height: 5,),
                                                    //Text("Client: ${data[index].client}"),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Contrat N°:${data[index].numcontrat}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 16),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Nom client:",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 9),
                                                                              Text("${data[index].client.toString() + ' ' + data[index].prenomClient.toString()}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 4),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Type abonnement:",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 9),
                                                                              Text("${data[index].abonnement}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 4),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Reste:",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 9),
                                                                              Text("${data[index].reste}" + " DHS"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 4),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Statut:",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 9),
                                                                              Text(double.parse(data[index].reste.toString()) != null && double.parse(data[index].reste.toString()) == 0 ? "Payee" : "Impayee"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 4),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "Date de debut :",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 9),
                                                                              Text("${data[index].dateDebut}"),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                              height: 4),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                                  ('Date de fin')),
                                                                              SizedBox(width: 9),
                                                                              Text(data[index].dateFin.toString())
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height: 16),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    // Add your action widgets here
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  height: 28,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: Colors
                                                              .blueAccent)),
                                                  child: Center(
                                                    child: Icon(
                                                        Icons.remove_red_eye,
                                                        size: 15,
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const CircularProgressIndicator()),
                  ],
                ),
        ),
      ),
    );
  }
}
