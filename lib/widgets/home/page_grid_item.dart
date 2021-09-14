import 'package:flutter/material.dart';

class PageGridItem extends StatelessWidget {
  final page;
  final title;
  final subtitle;
  const PageGridItem(this.page, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.of(context).pushNamed(page);
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.leaderboard),
              const SizedBox(height: 30),
              Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  subtitle,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
