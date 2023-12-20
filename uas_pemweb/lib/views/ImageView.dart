import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;

  ImageView({required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isFavorite = false;

  Future<void> setLock() async {
    await _requestStoragePermission();
    int location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imgUrl);
    final bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
    _showWallpaperResult(result);
    Navigator.pop(context);
  }

  Future<void> setHome() async {
    await _requestStoragePermission();
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imgUrl);
    final bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
    _showWallpaperResult(result);
    Navigator.pop(context);
  }

  Future<void> setBoth() async {
    await _requestStoragePermission();
    int location = WallpaperManager.BOTH_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imgUrl);
    final bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
    _showWallpaperResult(result);
    Navigator.pop(context);
  }

  // Fungsi untuk meminta izin penyimpanan
  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      Fluttertoast.showToast(msg: "Give Storage permissions from Settings");
      await Permission.storage.request();
    }
  }

  // Fungsi untuk menampilkan hasil operasi atur wallpaper
  void _showWallpaperResult(bool result) {
    if (result == true) {
      Fluttertoast.showToast(
        msg: 'Wallpaper is Applied',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Fail to set image as wallpaper',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image View'),
        // Tombol kembali ke halaman utama
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: widget.imgUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon yang berubah berdasarkan kondisi favorit
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.black54,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.black54,
                  child: IconButton(
                    onPressed: () {
                      _saveImage();
                    },
                    icon: const Icon(
                      Icons.download,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.black54,
                  child: IconButton(
                    onPressed: () {
                      _showApplyWallpaperDialog();
                    },
                    icon: const Icon(
                      Icons.crop_free_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menyimpan gambar ke galeri
  Future<void> _saveImage() async {
    await _requestStoragePermission();
    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    if (result == false) {
      Fluttertoast.showToast(
        msg: 'Fail to save image',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Image Saved to Gallery',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  // Fungsi untuk menampilkan dialog pilihan atur wallpaper
  void _showApplyWallpaperDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.black,
          alignment: Alignment.bottomCenter,
          title: const Text(
            'Apply Wallpaper',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                setLock();
              },
              child: const Text(
                'Lock Screen Wallpaper',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setHome();
              },
              child: const Text(
                'Home Screen Wallpaper',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setBoth();
              },
              child: const Text(
                'Both',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
