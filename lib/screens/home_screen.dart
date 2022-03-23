import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List stations = [];

  void getRadios() async {
    try {
      Response response = await Dio().get(
        'https://fr1.api.radio-browser.info/json/stations/bycountrycodeexact/ID',
      );
      List data = response.data;
      List filteredList = data.where((x) {
        return x["favicon"] != "" || x['favicon'] != null;
      }).toList();
      setState(() {
        stations = filteredList;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getRadios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Overadio',
          style: GoogleFonts.coustard().copyWith(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: stations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(stations[index]['favicon']),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            stations[index]['name'],
                            style: GoogleFonts.poppins().copyWith(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            "${stations[index]['language']} - ${stations[index]['country']}",
                            style: GoogleFonts.poppins().copyWith(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              currentPlaying(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget currentPlaying(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.white, blurRadius: 10.0),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1556761175-129418cb2dfe?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Playing...',
                      style: GoogleFonts.poppins().copyWith(
                        fontSize: 12,
                        color: Colors.black38,
                      ),
                    ),
                    Text(
                      'Prambors Radio',
                      style: GoogleFonts.poppins()
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.pause_fill),
            )
          ],
        ),
      ),
    );
  }
}
