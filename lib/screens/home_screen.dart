import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:overadio/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List stations = [];
  Map<String, dynamic> selectedRadio = {};

  void getRadios() async {
    Response response = await Dio().get(
      'https://fr1.api.radio-browser.info/json/stations/bycountrycodeexact/ID',
    );

    final filtered = response.data.where((row) {
      return row['favicon'] != '';
    });

    setState(() {
      stations = filtered.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getRadios();
  }

  Widget _loader(BuildContext context, String url) {
    return const Center(
      child: CupertinoActivityIndicator(color: Colors.white70),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    return const Icon(
      CupertinoIcons.exclamationmark_circle,
      color: Colors.yellow,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Overadio',
          style: GoogleFonts.oswald().copyWith(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: headingColor,
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
                          leading: SizedBox(
                            height: 60.0,
                            width: 60.0,
                            child: CachedNetworkImage(
                              imageUrl: stations[index]['favicon'],
                              placeholder: _loader,
                              errorWidget: _error,
                            ),
                          ),
                          title: Text(
                            stations[index]['name'],
                            style: GoogleFonts.roboto().copyWith(
                              fontSize: 14,
                              color: textColor,
                            ),
                          ),
                          subtitle: Text(
                            "${stations[index]['state']} - ${stations[index]['country']}",
                            style: GoogleFonts.roboto().copyWith(
                              fontSize: 12,
                              color: secondaryColor,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () => setState(
                              () => selectedRadio = stations[index],
                            ),
                            icon: const Icon(
                              Icons.play_circle_fill,
                              size: 32,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              selectedRadio.isNotEmpty ? currentPlaying(context) : Container(),
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
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 60.0,
                width: 60.0,
                child: CachedNetworkImage(
                  imageUrl: selectedRadio['favicon'],
                  placeholder: _loader,
                  errorWidget: _error,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Playing...',
                      style: GoogleFonts.roboto().copyWith(
                        fontSize: 12,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedRadio['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: GoogleFonts.roboto().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => selectedRadio = {}),
                icon: const Icon(
                  CupertinoIcons.pause_fill,
                  color: textColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
