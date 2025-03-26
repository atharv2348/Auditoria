import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class CustomLoadingOverlay extends StatelessWidget {
  const CustomLoadingOverlay(
      {super.key, required this.overlayPortalController});
  final OverlayPortalController overlayPortalController;

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: (BuildContext context) {
        return Container(
          color: Colors.black.withOpacity(0.3),
          alignment: Alignment.center,
          child: const SpinKitFadingCircle(
            color: Colors.white,
          ),
        );
      },
    );
  }
}
