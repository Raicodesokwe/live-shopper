import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:video_compress/video_compress.dart';

class VideoService {
  static compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;
  }

  static getThumbnail(String videoPath) async {
    final thumbNail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbNail;
  }

  static uploadThumbnail(User user, String videoPath) async {
    String? url;
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance
        .ref()
        .child('thumbnail')
        .child('${user.uid}.$time.thumb');
    await ref.putFile(await getThumbnail(videoPath));
    url = await ref.getDownloadURL();
    return url;
  }

  static uploadVideoUrl(User user, String videoPath) async {
    String? url;
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance
        .ref()
        .child('videos')
        .child('${user.uid}.$time.vid');
    await ref.putFile(await compressVideo(videoPath));
    url = await ref.getDownloadURL();
    return url;
  }
}
