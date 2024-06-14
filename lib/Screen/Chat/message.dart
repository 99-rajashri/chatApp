import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayMeassage extends StatefulWidget {
  final String name;
  const DisplayMeassage({super.key, required this.name});

  @override
  State<DisplayMeassage> createState() => _DisplayMeassageState();
}

class _DisplayMeassageState extends State<DisplayMeassage> {
  final Stream<QuerySnapshot> _msgStream = FirebaseFirestore.instance
      .collection("Message")
      .orderBy('time')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _msgStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          primary: true,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot qds = snapshot.data!.docs[index];
            Map<String, dynamic> data = qds.data() as Map<String, dynamic>;
            Timestamp time = data['time'];
            DateTime dateTime = time.toDate();
            String type = data.containsKey('type')
                ? data['type']
                : 'text'; // Default to 'text' if 'type' doesn't exist

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                  crossAxisAlignment: widget.name == data['name']
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 300,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.purple),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              )),
                          title: Text(
                            data['name'],
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (type == 'text')
                                Text(
                                  data['message'],
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                )
                              else if (type == 'image')
                                Image.network(data['fileUrl'])
                              else if (type == 'video')
                                Text(
                                  'Video: ${data['fileUrl']}',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              Text("${dateTime.hour}:${dateTime.minute}")
                            ],
                          ),
                        ))
                  ]),
            );
          },
        );
      },
    );
  }
}
