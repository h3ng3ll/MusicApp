// ignore_for_file: file_names






import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:music_app/src/data/provider/AudioProvider.dart';
import 'package:music_app/src/domain/model/Album.dart';
import 'package:music_app/src/domain/model/song/NetworkSong.dart';
import 'package:music_app/src/domain/repository/Producer.dart';
import 'package:music_app/src/presentation/UI/Screens/Home/ShareScreen/ProducerScreenView/SongsOfAlbumScreen.dart';
import 'package:music_app/src/presentation/core/constants.dart';
import 'package:music_app/src/presentation/core/widgets/BuildAvatarImage.dart';
import 'package:music_app/src/presentation/core/widgets/BuildSongTileItem.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ProducerScreenView extends StatelessWidget {
  final Producer producer ;
  final double gap ; 
  const ProducerScreenView({Key? key, required this.producer, required this.gap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Album>>(
          future: producer.getAlbums(),
          builder: (context, snapshot) {
            if(ConnectionState.done == snapshot.connectionState && snapshot.hasData) {
              final albums = snapshot.data!;
              return buildBody(albums , context);
            }

            return const Center(child: CircularProgressIndicator());
          }
        ),
      ),
    );
  }

  /// some popular songs which
  /// describe popularity of
  /// producer .
  List<NetworkSong> takeSongsFromAlbums(List<Album> albums) =>  [
      for (var album in albums)
        for (var song in album.songs)
          song,
  ];

  Widget buildBody (List<Album> albums , BuildContext context) {

    final songs = takeSongsFromAlbums(albums);
    final titleLarge = Theme.of(context).textTheme.titleLarge;
    final titleMedium = Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [

          SizedBox(height: size(context).height*0.03,),
          Center(child: Text(producer.producerName.capitalize() , style: titleLarge,)),
          SizedBox(height: size(context).height*0.03,),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.,
            children: [
              Column(
                children: [
                  BuildAvatarImage(imgUrl: producer.avatarUrl, padding: EdgeInsets.zero,),
                  SizedBox(height: size(context).height*0.01,),
                  Text(producer.producerName , style: titleMedium,),
                ],
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: songs.take(5).map((song) => BuildSongTileItem(
                    song: song,
                    songs: songs
                  )).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: size(context).height*0.03,),

          Center(child: Text(AppLocalizations.of(context)!.albums , style: titleLarge,)),

          SizedBox(height: size(context).height*0.03,),

          SizedBox(
            height: size(context).height/2,
            width: size(context).width,
            child: buildAlbums(albums , context)
          ),

        ],
      ),
    );
  }


  Widget buildAlbums (List<Album> albums , BuildContext context) {
    final theme = Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20);
    return GridView.builder(
        itemCount: albums.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
        ),
        itemBuilder: (context , index ){
          return InkWell(
            onTap: () {
              final provider = Provider.of<AudioProvider>(context , listen:  false);
              PersistentNavBarNavigator.pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: ChangeNotifierProvider.value(
                    value: provider,
                    child: SongOfAlbumScreen(
                      album: albums[index],
                    ),
                  )
              );
            },
            child: Column(
              children: [
                BuildAvatarImage(imgUrl: albums[index].coverPath, padding: EdgeInsets.zero,),
                SizedBox(height: size(context).height*0.01,),
                FittedBox(child: Text(albums[index].name ?? "no name" , style: theme, )),
              ],
            ),
          );
        }
    );
  }
}
