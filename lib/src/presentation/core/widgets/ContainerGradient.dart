// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class ContainerGradient extends StatefulWidget {


  const ContainerGradient({
    Key? key ,
    required this.child,
    this.height  ,
    this.width,
    this.light = true,
    this.gradient,
    this.boxShadow,
    this.circularRadius = 17.0
    // this.containerColor
  }) : super(key: key);


  factory  ContainerGradient.dark({
   required Widget  child ,
    double? height,
    double? width,
    Gradient? gradient,
    double circularRadius = 17.0,
    List<BoxShadow>? boxShadow,
    // Color? containerColor,
  }) => ContainerGradient(
    height: height,
    width: width,
    light:  false,
    gradient: gradient,
    boxShadow: boxShadow,
    circularRadius: circularRadius,
    // containerColor: containerColor,
    child: child ,

  );

  final Widget child;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  // final Color? containerColor;
  final bool light;
  final double circularRadius ;

  @override
  State<ContainerGradient> createState() => _ContainerGradientState();
}

class _ContainerGradientState extends State<ContainerGradient> {



  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.circularRadius),
          boxShadow: widget.boxShadow
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.circularRadius),
        child: Container(
          height: widget.height,
          width: widget.width,
          padding:  const EdgeInsets.symmetric(horizontal: 10 ,),
          decoration: BoxDecoration(
            color: widget.light ? null :  grey5,
            borderRadius: BorderRadius.circular(widget.circularRadius),
            gradient: widget.gradient ?? (widget.light ? const LinearGradient(
                colors: [gold2, gold4, gold5, gold,],
                stops: [0.1, 0.2, 0.3, 0.4,],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ) : null),
          ),
          child: Stack(
            children: [
              // if(widget.light) ...buildShadows(),
              Center(child: widget.child),

            ],
          )
        ),
      ),
    );
  }

  // Widget buildShadow ({
  //   required Color color,
  //   double? width,
  //   double? height,
  //   required Offset offset,
  //   double spreadRadius =  1 ,
  //   BlurStyle  style  = BlurStyle.normal
  // }) {
  //   return Container(
  //     width:  width,
  //     height: height,
  //     decoration: BoxDecoration(
  //         // borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
  //         // borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
  //         boxShadow:  [
  //           BoxShadow(
  //               blurStyle: style,
  //               blurRadius: 3,
  //               spreadRadius: spreadRadius ,
  //               color: color,
  //               offset: offset
  //           ),
  //
  //         ]
  //     ),
  //   );
  // }
  //
  // List<Widget> buildShadows() => [
  //   /// top
  //   Positioned(
  //     left: 0,
  //     right: 0,
  //     child: buildShadow(
  //         color: gold7,
  //         width: widget.width ,
  //         spreadRadius: 2 ,
  //         height: 1,
  //         offset: const Offset(0, 0)
  //     ),
  //   ),
  //
  //   /// right
  //   Positioned(
  //     top: 0,
  //     right: 0,
  //     bottom: 0,
  //     child: buildShadow(
  //         style: BlurStyle.solid,
  //         color: gold7,
  //         width:  1,
  //         spreadRadius: 1 ,
  //         height: widget.width,
  //         offset: const Offset(10, 0)
  //     ),
  //   ),
  //
  //   /// left
  //
  //   Positioned(
  //     top: 0,
  //     left: 0,
  //     bottom: 0,
  //     child: buildShadow(
  //         color: brown2,
  //         width:  1,
  //         spreadRadius: 2 ,
  //         height: widget.width,
  //         offset: const Offset(-10, 0)
  //     ),
  //   ),
  //
  //   /// bottom
  //   Positioned(
  //     right: 0,
  //     left: 0,
  //     bottom: 0,
  //     child: buildShadow(
  //         color: brown2,
  //         width:  widget.width,
  //         spreadRadius: 2 ,
  //         height: 1,
  //         offset: const Offset(-4, 0)
  //     ),
  //   ),
  // ];

}
