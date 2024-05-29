import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_era_dev/all_news.dart';
import 'package:flutter_era_dev/app_fonts.dart';
import 'package:flutter_era_dev/news_bloc/news_bloc.dart';
import 'package:flutter_era_dev/repositories/news/news_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MockNewsRepository();
    return BlocProvider(
      create: (context) => NewsBloc(repository),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: _GoToAllNewsScreenButton(),
        ),
      ),
    );
  }
}

class _GoToAllNewsScreenButton extends StatelessWidget {
  const _GoToAllNewsScreenButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewsBloc>();
    String textButton = 'See news!';
    return Center(
      child: BlocListener<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is AllNewsLoaded) {
            textButton = 'See news!';
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AllNewsScreen()),
            );
          } else if (state is NewsLoadingFailure) {
            textButton = 'Something went wrong\nTry again later';
          } else {
            textButton = 'See news!';
          }
        },
        child: TextButton(
          onPressed: () => bloc.add(LoadAllNews()),
          child: Text(
            textButton,
            style: const TextStyle(
              fontFamily: AppFonts.sfProDisplay,
              color: Colors.black,
              fontSize: 28,
            ),
          ),
        ),
      ),
    );
  }
}
