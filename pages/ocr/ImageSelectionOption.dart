import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageSelectionOption {
  static final ImagePicker _picker = ImagePicker();

  /// Picks an image from the camera.
  static Future<File?> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image from camera: $e");
    }
    return null;
  }

  /// Picks an image from the gallery.
  static Future<File?> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
    }
    return null;
  }
}