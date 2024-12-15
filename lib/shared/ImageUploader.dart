import 'dart:io';

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class ImageUploader extends StatelessWidget {
  File? selectedImage;
  final Future<void> Function() onPickImage;

  ImageUploader({required this.selectedImage, required this.onPickImage});

  Shadow shadow = Shadow(
    color: Colors.black.withOpacity(1),
    blurRadius: 12,
    offset: Offset(0, 0),
  );

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: selectedImage == null
            ? Styles.inputFieldBgColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        image: selectedImage != null
            ? DecorationImage(
                image: FileImage(selectedImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: InkWell(
        onTap: () async {
          await onPickImage();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload,
                  color: selectedImage == null
                      ? Styles.inputFieldTextColor
                      : Colors.white,
                  size: 32,
                  shadows: selectedImage != null ? [shadow] : [],
                ),
                SizedBox(height: 8),
                Text(
                  selectedImage == null
                      ? 'Tap to upload an image'
                      : 'Tap to change the image',
                  style: TextStyle(
                      color: selectedImage == null
                          ? Styles.inputFieldTextColor
                          : Colors.white,
                      shadows: selectedImage != null ? [shadow] : []),
                ),
                Text(
                  'Supports: JPG, JPEG and PNG',
                  style: TextStyle(
                    color: selectedImage == null
                        ? Color.fromRGBO(50, 50, 50, 1)
                        : Colors.white,
                    fontSize: 12,
                    shadows: selectedImage != null
                        ? [
                            shadow,
                          ]
                        : [],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
