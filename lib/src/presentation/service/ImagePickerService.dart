// ignore_for_file: file_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/src/presentation/core/widgets/BuildModalBottomSheet.dart';

class ImagePickerService {


  Future<File?> pickImage(BuildContext context) async {

    ImagePicker picker = ImagePicker();

    ImageSource?  source = await showModalBottomSheet(
        context: context,
        builder: (context) => const BuildModalBottomSheet()
    );


    if(source == null) return null;

    final xFile = await picker.pickImage(source: source);

    if(xFile == null) return null;

    final file = File(xFile.path);
    return file ;
  }
}