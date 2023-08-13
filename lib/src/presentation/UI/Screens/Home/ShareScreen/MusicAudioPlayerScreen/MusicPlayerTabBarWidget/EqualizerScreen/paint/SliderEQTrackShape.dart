// ignore_for_file: file_names



import 'package:flutter/material.dart';
import 'package:music_app/src/presentation/service/ColorService.dart';

class SliderEQTrackShape extends RoundedRectSliderTrackShape {

  final LinearGradient activeGradient;
  final bool darkenInactive;
  final bool enabledSlider ;

  SliderEQTrackShape({
    this.activeGradient = const LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [0.0, 0.1, 0.6, 0.7, 0.85, 1],
      colors: [gold7, gold, gold3, gold2, gold, brown2],
    ),
    this.darkenInactive = true,
    required this.enabledSlider
  });


  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required Offset thumbCenter,
      Offset? secondaryOffset,
      bool isDiscrete = false,
      bool isEnabled = false,
      double additionalActiveTrackHeight = 2}) {

    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(sliderTheme.trackHeight != null && sliderTheme.trackHeight! > 0);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final activeGradientRect = Rect.fromLTRB(
      trackRect.left,
      (textDirection == TextDirection.ltr)
          ? trackRect.top - (additionalActiveTrackHeight / 2)
          : trackRect.top,
      thumbCenter.dx,
      (textDirection == TextDirection.ltr)
          ? trackRect.bottom + (additionalActiveTrackHeight / 2)
          : trackRect.bottom,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);

    final Paint activePaint = Paint()
      ..shader = activeGradient.createShader(activeGradientRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;

    final Paint inactivePaint = Paint()
      ..color = grey3;

    final Paint leftTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        break;
    }

    final Radius trackRadius = Radius.circular(trackRect.height / 1.5);
    final Radius activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);


    final rRect2 = RRect.fromLTRBAndCorners(
      thumbCenter.dx,
      trackRect.top-2,
      trackRect.right+2,
      trackRect.bottom+2,
      topRight:  trackRadius,
      bottomRight:  trackRadius,
    );

    var paint = Paint()
      ..color = black2;

    buildInactiveTrack(rRect2 , context ,  paint);


    final rRect3 = RRect.fromLTRBAndCorners(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right+0.5,
      trackRect.bottom+2,
      topRight:  trackRadius,
      bottomRight:  trackRadius,
    );
    var paint2 = Paint()
      ..color = grey;
    buildInactiveTrack(rRect3 , context ,  paint2);


    final rRect = RRect.fromLTRBAndCorners(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
      topRight:  trackRadius,
      bottomRight:  trackRadius,
    );

    buildInactiveTrack(rRect , context ,  inactivePaint );



    ///  build Active track

    Paint disabledActiveSlider = Paint()..color = grey;

      buildElevationActiveTrack(trackRect , thumbCenter , context );

      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          trackRect.left,
          (textDirection == TextDirection.ltr)
              ? trackRect.top - (additionalActiveTrackHeight / 2)
              : trackRect.top + 200,
          thumbCenter.dx,
          (textDirection == TextDirection.ltr)
              ? trackRect.bottom + (additionalActiveTrackHeight / 2)
              : trackRect.bottom,
          topLeft: (textDirection == TextDirection.ltr)
              ? activeTrackRadius
              : trackRadius,
          bottomLeft: (textDirection == TextDirection.ltr)
              ? activeTrackRadius
              : trackRadius,
        ),
        enabledSlider ? leftTrackPaint :  disabledActiveSlider ,
      );
  }

  void buildInactiveTrack (
      RRect rrect ,
      PaintingContext context ,
      Paint paint ,

      ) {
    context.canvas.drawRRect(
      rrect,
      paint,
    );
  }

  void buildShadowInactiveTrack () {

  }
  void buildElevationActiveTrack (Rect  trackRect , Offset thumbCenter , PaintingContext context) {
    final Path path = Path()
      ..addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(
                trackRect.left - 2,
                trackRect.top  -5 ,
                thumbCenter.dx,
                trackRect.bottom+5
            ),
            bottomLeft: const Radius.circular(17.5),
            topLeft: const Radius.circular(17.5),
          )
      );

    if(enabledSlider) {
      /// draw Shadow
      context.canvas.drawShadow(path, gold, 2, true);
    }

  }

}