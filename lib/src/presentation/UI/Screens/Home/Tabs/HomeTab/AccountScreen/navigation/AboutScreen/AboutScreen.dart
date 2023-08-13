// ignore_for_file: file_names


import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context).textTheme.labelMedium;
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    return  Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [


                FittedBox(
                  child: Text("""
                      Hi I am Alexandr , thank you for    
                        download demo version of this app 
                        source code of this app can be found
                        bellow .  
                        I'd like to thank who create design 
                        I've coded biggest part from it  
                        And I want  this project to be for a 
                        real and  make it more interest combine
                        backend api to clients with real dates
                        and new innovations.        
                  """ , style: theme,),
                ),

                Text("Figma" ,  style: theme ),
                SelectableText("figma.com/file/B7TjdRvIyv9RvdT3JRgc0w/Music-App?type=design&node-id=0-1&mode=design&t=gCXIg8Fe8C3e413D-0" , style: titleMedium,),


                Text("GitHub" ,  style: theme ),
                SelectableText("github.com/h3ng3ll/MusicApp" , style: titleMedium,),


              ],
            ),
          ),
        )
    );
  }
}
