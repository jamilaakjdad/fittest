// import 'package:fithouse_mobile/core/providers/p_clientv.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ClientDetailsWidget extends StatelessWidget {
//   final int idClient;

//   const ClientDetailsWidget({Key? key, required this.idClient})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Provider.of<ClientProvider>(context, listen: false)
//           .fetchDataFromApi(idClient),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error fetching data'));
//         }
//         final clientProvider = Provider.of<ClientProvider>(context);
//         return Column(
//           children: [
//             Text('Client name: ${clientProvider.client.nomClient}'),
//             Text('City name: ${clientProvider.ville.nomVille}'),
//           ],
//         );
//       },
//     );
//   }
// }
