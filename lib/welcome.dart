import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:korani/surahtile.dart';
import 'package:quran/quran.dart' as quran;
import 'constants.dart';
import 'quran_drawer.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int surah = Random().nextInt(114) + 1;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          leading: CustomizedIconButton(
            func: () {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: FontAwesomeIcons.barsProgress,
          ),
          title: const AppTitle(),
        ),
        drawer: const QuranDrawer(),
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomizedText(
                text: "Assalamualaikum",
                color: whiteShade,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return CustomizedText(
                      text: snapshot.hasData
                          ? snapshot.data!.get("english_username").toUpperCase()
                          : "",
                      color: white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    );
                  } else {
                    return CustomizedText(
                      text: snapshot.error.toString(),
                      color: white,
                      fontSize: 20,
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: <Color>[white, purple],
                    begin: AlignmentDirectional.bottomEnd,
                    end: AlignmentDirectional.bottomEnd,
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.bookOpen,
                                  size: 20,
                                  color: white,
                                ),
                                const SizedBox(width: 10),
                                CustomizedText(
                                  text: "Last Read",
                                  color: white,
                                  fontSize: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomizedText(
                            text: quran.getSurahName(surah),
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 10),
                          CustomizedText(
                            text:
                                "Ayah No : ${Random().nextInt(quran.getVerseCount(surah)) + 1}",
                            color: whiteShade,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/book.png",
                      width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.height * .4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return SurahTile(
                      number: index + 1,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: .2,
                      decoration: BoxDecoration(
                        color: whiteShade.withOpacity(.8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    );
                  },
                  itemCount: quran.totalSurahCount,
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: true,
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
