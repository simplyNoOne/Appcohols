import 'package:flutter/material.dart';

class DrinkTile extends StatelessWidget {
  const DrinkTile(
      {super.key, required this.name, required this.imageUrl, this.onTap});

  final String name;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: flatButtonStyle,
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), topLeft: Radius.circular(15)),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,

                  ))),
          Expanded(child: Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            softWrap: true, )),
        ],
      ),
    );
  }
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.black87,
  backgroundColor: Color.fromRGBO(7, 7, 7, 0.09019607843137255),
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all( Radius.circular(15))
  ),
);
