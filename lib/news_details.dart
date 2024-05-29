import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_era_dev/all_news.dart';
import 'package:flutter_era_dev/app_fonts.dart';
import 'package:flutter_era_dev/news_bloc/news_bloc.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewsBloc>();
    final article = bloc.article;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 395,
              child: NewsCardWidget(
                imageUrl: article!.imageUrl,
                radius: 12,
                title: article.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(21),
              child: Text(
                article.description ?? 'Download failure, try again later',
                strutStyle: const StrutStyle(),
                style: const TextStyle(
                  fontFamily: AppFonts.sfProDisplay,
                  fontSize: 16,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(21, 0, 21, 21),
              child: SizedBox(
                height: 155,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://i.ibb.co/VCb4zLk/unsplash-SYTO3xs06f-U-1.jpg')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
