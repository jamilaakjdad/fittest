import 'dart:io';
import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

import '../utilities/constant.dart';

class ImageUploaderScreen extends StatefulWidget {
  final Client imclient;
  ImageUploaderScreen({super.key, required this.imclient});
  @override
  _ImageUploaderScreenState createState() => _ImageUploaderScreenState();
}

class _ImageUploaderScreenState extends State<ImageUploaderScreen> {
  File? _selectedImage;
  String _serverImagePath = '';
  String image_path = "";
  Future _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  final clientapi = Get.put(ClientAPI());

  Future<void> _refresh() {
    setState(() {
      clientapi.fetchClient();
    });

    return Future<void>.delayed(const Duration(seconds: 3));
  }

  Future _uploadImage() async {
    if (_selectedImage != null) {
      final url =
          '${HOST}/api/saveImage/'; // Replace with your server URL
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['path'] =
          'client/'; // Replace with the desired path to save the image on the server
      request.files.add(await http.MultipartFile.fromPath(
          'uploadedFile', _selectedImage!.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final parsedResponse = json.decode(responseData);
        final serverImagePath = parsedResponse['path'];

        setState(() {
          _serverImagePath = serverImagePath;
          print(_serverImagePath);
        });
        final clientapi = Get.put(ClientAPI());
        await clientapi.fetchClient();

        for (Client client in clientapi.clients) {
          if (client.idClient == widget.imclient.idClient) {
            final updatedClient = Client(
                idClient: client.idClient,
                civilite: client.civilite,
                nomClient: client.nomClient,
                prenomClient: client.prenomClient,
                adresse: client.adresse,
                tel: client.tel,
                mail: client.mail,
                dateInscription: client.dateInscription,
                dateNaissance: client.dateNaissance,
                // password: pass.text.toString(),
                cin: client.cin,
                idVille: client.idVille,
                image: _serverImagePath,
                blackliste: client.blackliste,
                statut: client.statut,
                newsletter: client.newsletter);
            print(updatedClient.toJson());
            await ClientAPI.updateClient(updatedClient);
            _refresh();
            setState(() {
              clientapi.fetchClient();
              _serverImagePath = serverImagePath;
            });

            Navigator.pop(context);
          }
        }
        // Show a success message or perform any other actions
      } else {
        // Show an error message
      }
    } else {
      // No image selected, show a message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier l\'Image '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null) ...[
              Container(
                height: 150,
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Sélectionner une image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('mettre à jour l\'image'),
            ),
            // if (_serverImagePath != null) ...[
            //   SizedBox(height: 20),
            //   Text('Server Image Path: $_serverImagePath'),
            // ],
          ],
        ),
      ),
    );
  }
}
