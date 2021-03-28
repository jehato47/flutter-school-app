import 'package:flutter/material.dart';

class PageGridItem extends StatelessWidget {
  final page;
  final title;
  final subtitle;
  PageGridItem(this.page, this.title, this.subtitle);

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
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.leaderboard),
              SizedBox(height: 30),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
