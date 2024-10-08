import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final bool hideUploadButton;
  const AvatarWidget({super.key, this.hideUploadButton = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      height: 102,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConatants.avatar),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Offstage(
              offstage: hideUploadButton,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ColorsConstants.brow, width: 4),
                    shape: BoxShape.circle),
                child: const Icon(
                  Icons.add,
                  size: 20,
                  color: ColorsConstants.brow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
