import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appTextStyles.dart';


class AppColorsText extends StatelessWidget {
  const AppColorsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Design System Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ColorPalette(),
          TypographyDisplay(),
        ],
      ),
    );
  }
}

class ColorPalette extends StatelessWidget {
  final List<Map<String, String>> colors = [
    {'name': 'BK', 'color': '#000000'},
    {'name': 'GR900', 'color': '#1B1C1F'},
    {'name': 'GR800', 'color': '#404249'},
    {'name': 'GR700', 'color': '#53555E'},
    {'name': 'GR600', 'color': '#6A6C73'},
    {'name': 'GR550', 'color': '#8E9096'},
    {'name': 'GR500', 'color': '#A5A8AE'},
    {'name': 'GR400', 'color': '#C9CACD'},
    {'name': 'GR300', 'color': '#DFE0E3'},
    {'name': 'GR250', 'color': '#EFEFF2'},
    {'name': 'GR200', 'color': '#F3F3F4'},
    {'name': 'GR150', 'color': '#F8F8FB'},
    {'name': 'GR100', 'color': '#FAFAFC'},
    {'name': 'WH', 'color': '#FFFFFF'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Color Palette', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            return Container(
              color: Color(int.parse(colors[index]['color']!.substring(1, 7), radix: 16) + 0xFF000000),
              child: Center(
                child: Text(
                  colors[index]['name']!,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class TypographyDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> textStyles = [
    {'name': 'Title S28', 'style': TextStyle(fontSize: 28, fontWeight: FontWeight.w600, height: 1.285)},
    {'name': 'Title B24', 'style': TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.25)},
    {'name': 'Title B20', 'style': TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.4)},
    {'name': 'Title S18', 'style': TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.222)},
    {'name': 'Body S16', 'style': TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5)},
    {'name': 'Body M16', 'style': TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5)},
    {'name': 'Body S15', 'style': TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.466)},
    {'name': 'Body S14', 'style': TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.571)},
    {'name': 'Body M14', 'style': TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.571)},
    {'name': 'Caption M12', 'style': TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.5)},
    {'name': 'Caption B12', 'style': TextStyle(fontSize: 12, fontWeight: FontWeight.bold, height: 1.5)},
    {'name': 'Caption M10', 'style': TextStyle(fontSize: 10, fontWeight: FontWeight.w500, height: 1.6)},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Typography', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        Column(
          children: textStyles.map((textStyle) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textStyle['name']!,
                style: textStyle['style'] as TextStyle,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}