import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: prussianBlue,
            child: Center(
              child: Image.asset('assets/circle-g.png', width: 128),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            color: mikadoYellow,
            child: const Text(
              'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
              style: TextStyle(color: Colors.black87, fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}
