// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:music_app/src/data/provider/UserProvider.dart';
import 'package:music_app/src/domain/repository/Producer.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/ProducerScreenView/ProducerScreenView.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAvatarImage.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BuildLibraryRecentlyAddedWidget extends StatelessWidget {
  final double gap;
  const BuildLibraryRecentlyAddedWidget({Key? key,required this. gap}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    final dSize  = dynSize(context)/6;

    return StreamBuilder<List<String>>(
      stream: UserProvider.followingStream,
      builder: (context, snapshot) {
        final following = snapshot.data;
        return FutureBuilder<List<Producer>>(
          future: UserProvider.fetchFollowingProducers(following),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done ){
              final producers = snapshot.data ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: producers.length,
                        itemBuilder: (context , index) => InkWell(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: ProducerScreenView(
                                  producer: producers[index],
                                  gap: gap,
                                )
                            );
                          },
                          child: BuildAvatarImage(
                            imgUrl: producers[index].avatarUrl,
                            width: size(context).width/6,
                            // height: size(context).height,
                            circularRadius: 10,
                            padding:  EdgeInsets.only(right: dSize/6),
                          ),
                        )
                    ),
                  )
                ],
              );
            }
            return  Container();
          }
        );
      }
    );
  }
}
