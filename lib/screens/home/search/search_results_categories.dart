import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:frosty/l10n/app_localizations.dart';
import 'package:frosty/models/category.dart';
import 'package:frosty/screens/home/search/search_store.dart';
import 'package:frosty/screens/home/top/categories/category_card.dart';
import 'package:frosty/widgets/alert_message.dart';
import 'package:frosty/widgets/skeleton_loader.dart';
import 'package:mobx/mobx.dart';

class SearchResultsCategories extends StatelessWidget {
  final SearchStore searchStore;

  const SearchResultsCategories({super.key, required this.searchStore});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final future = searchStore.categoryFuture;

        // Show skeletons immediately while waiting for debounce.
        if (future == null) {
          if (searchStore.isSearching) {
            return SliverList.builder(
              itemCount: 8,
              itemBuilder: (context, index) => const CategorySkeletonLoader(),
            );
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        switch (future.status) {
          case FutureStatus.pending:
            return SliverList.builder(
              itemCount: 8,
              itemBuilder: (context, index) => const CategorySkeletonLoader(),
            );
          case FutureStatus.rejected:
            return SliverToBoxAdapter(
              child: SizedBox(
                height: 100.0,
                child: AlertMessage(
                  message: context.l10n('Unable to load categories'),
                  vertical: true,
                ),
              ),
            );
          case FutureStatus.fulfilled:
            final CategoriesTwitch? categories = future.result;

            if (categories == null) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 100.0,
                  child: AlertMessage(
                    message: context.l10n('Failed to get categories'),
                    vertical: true,
                  ),
                ),
              );
            }

            if (categories.data.isEmpty) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 100.0,
                  child: AlertMessage(
                    message: context.l10n('No matching categories'),
                    vertical: true,
                  ),
                ),
              );
            }

            return SliverList.builder(
              itemCount: categories.data.length,
              itemBuilder: (context, index) =>
                  CategoryCard(category: categories.data[index]),
            );
        }
      },
    );
  }
}
