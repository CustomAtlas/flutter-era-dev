import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_era_dev/app_fonts.dart';
import 'package:flutter_era_dev/news_bloc/news_bloc.dart';
import 'package:flutter_era_dev/news_details.dart';
import 'package:provider/provider.dart';

class ScrollControllerHolder extends ChangeNotifier {
  ScrollControllerHolder() {
    scrollController.addListener(_listenScroll);
  }

  final scrollController = ScrollController();

  void _listenScroll() {
    if (scrollController.offset > 0) notifyListeners();
  }

  @override
  void dispose() {
    scrollController.removeListener(_listenScroll);
    scrollController.dispose();
    super.dispose();
  }
}

class AllNewsScreen extends StatelessWidget {
  const AllNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: AppFonts.sfProDisplay,
      fontSize: 18,
      color: Colors.black,
    );
    final bloc = context.read<NewsBloc>();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Notifications', style: textStyle),
        centerTitle: true,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 14),
            onPressed: () => bloc.add(MarkReadAllNews()),
            icon: const Text('Mark all read', style: textStyle),
          ),
        ],
      ),
      body: const _AllNewsWidget(),
    );
  }
}

class _AllNewsWidget extends StatelessWidget {
  const _AllNewsWidget();

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontFamily: AppFonts.sfProDisplay,
      fontSize: 20,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
      child: ChangeNotifierProvider(
        create: (context) => ScrollControllerHolder(),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Featured', style: textStyle),
            SizedBox(height: 20),
            _FeaturedNewsWidget(),
            SizedBox(height: 20),
            Text('Latest news', style: textStyle),
            SizedBox(height: 20),
            Expanded(child: _LatestNewsWidget()),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FeaturedNewsWidget extends StatelessWidget {
  const _FeaturedNewsWidget();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewsBloc>();
    final scrollController =
        context.watch<ScrollControllerHolder>().scrollController;
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      child: SizedBox(
        height: scrollController.hasClients && scrollController.offset > 10
            ? 120
            : 300,
        child: ListView.separated(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          itemCount: bloc.featuredArticles.length,
          itemBuilder: (context, index) => FeaturedNewsItemWidget(index),
          separatorBuilder: (context, index) => const SizedBox(width: 20),
        ),
      ),
    );
  }
}

class FeaturedNewsItemWidget extends StatelessWidget {
  const FeaturedNewsItemWidget(this.index, {super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NewsBloc>();
    return BlocListener<NewsBloc, NewsState>(
      listener: (context, state) {
        if (state is NewsDetailsLoaded && ModalRoute.of(context)!.isCurrent) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewsDetailsScreen()),
          );
        } else if (state is NewsLoadingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.exception.toString()),
              duration: const Duration(milliseconds: 1500),
            ),
          );
        }
      },
      child: ElevatedButton(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
        ),
        onPressed: () =>
            bloc.add(LoadNewsDetails(id: bloc.featuredArticles[index].id)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width - 56,
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              NewsCardWidget(
                imageUrl: bloc.featuredArticles[index].imageUrl,
                radius: 12,
                title: bloc.featuredArticles[index].title,
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Icon(
                  Icons.done_all,
                  color: bloc.featuredArticles[index].readed
                      ? Colors.white
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestNewsWidget extends StatelessWidget {
  const _LatestNewsWidget();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewsBloc>();
    final scrollController =
        context.read<ScrollControllerHolder>().scrollController;
    return ListView.separated(
      // clipBehavior: Clip.none,
      controller: scrollController,
      itemCount: bloc.latestArticles.length,
      itemBuilder: (context, index) => _LatestNewsItemWidget(index),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }
}

class _LatestNewsItemWidget extends StatelessWidget {
  const _LatestNewsItemWidget(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NewsBloc>();
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 12),
      child: ElevatedButton(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
          elevation: WidgetStatePropertyAll(0),
        ),
        onPressed: () =>
            bloc.add(LoadNewsDetails(id: bloc.latestArticles[index].id)),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 9,
                    offset: const Offset(9, 9),
                  )
                ],
                borderRadius: const BorderRadius.all(Radius.circular(9)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    SizedBox(
                        height: 60,
                        width: 90,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            bloc.latestArticles[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bloc.latestArticles[index].title,
                            style: const TextStyle(
                              fontFamily: AppFonts.sfProDisplay,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${DateTime.now().day - bloc.latestArticles[index].publicationDate.day} day(s) ago',
                            style: const TextStyle(
                              fontFamily: AppFonts.sfProDisplay,
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Icon(
                Icons.done_all,
                color: bloc.featuredArticles[index].readed
                    ? Colors.black
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsCardWidget extends StatelessWidget {
  const NewsCardWidget({
    super.key,
    required this.imageUrl,
    required this.radius,
    required this.title,
  });

  final String imageUrl;
  final double radius;
  final String title;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 9,
          )
        ],
        image: DecorationImage(
          opacity: 0.5,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.lighten),
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl),
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Align(
            alignment: const Alignment(-0.6, 0.7),
            child: SizedBox(
              width: 270,
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: AppFonts.sfProDisplay,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
