library bananaq_camera;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class CameraWithOverlay extends StatefulWidget{
  List<CameraDescription> cameras;




  @override
  State createState() => _CameraWithOverlayState();
}

class _CameraWithOverlayState extends State<CameraWithOverlay>{
  CameraController controller;
  String filepath = '';


  @override
  void initState() {
    super.initState();
    availableCameras().then((value) => widget.cameras = value);
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((value){
      if(!mounted) return;
      setState(() {});
    });
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          child: Stack(
            alignment: FractionalOffset.center,
            children: [
              Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )),
              Align(
                alignment: Alignment.center,
                child: Image(
                  height: 200,
                  width: 300,
                  image: AssetImage('assets/CameraOverlay.png'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: IconButton(
                    onPressed: () => _captureImage(),
                    icon: Icon(Icons.camera),color: Colors.white,iconSize: 50,),
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _captureImage() async {
    var temp = await getTemporaryDirectory();
    String path = '${temp.path}/${DateTime.now()}.png';
    var xfile = await controller.takePicture();
    xfile.saveTo(path);

    filepath = path;
    Navigator.pop(context,path);

  }


}
