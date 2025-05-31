import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  const PlaceTile(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>?;
    print("Snapshot: ${data}");
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 100.0,
            child: Image.network(
              data?["image"] ?? "https://via.placeholder.com/150" ,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress){
                if(loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    :null,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data?["title"] ?? "Sem titulo",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                Text(
                  data?["adress"] ?? "Sem endereco",
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  final lat = data?["lat"];
                  final long = data?["long"];
                  launchUrl(Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$long"));
                },
                child: Text(
                  "Ver no mapa",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  launchUrl(Uri.parse("tel: ${data?["phone"]}"));
                },
                child: Text(
                  "Ligar",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}