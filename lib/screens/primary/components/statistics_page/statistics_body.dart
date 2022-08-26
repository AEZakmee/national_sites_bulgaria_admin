import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/loading_indicator.dart';
import '../../../../widgets/vertical_separator.dart';
import 'statistics_page_viewmodel.dart';
import 'widgets/bottom_component.dart';
import 'widgets/top_component.dart';

class StatisticsBody extends StatelessWidget {
  const StatisticsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StatisticsPageVM>();
    if (viewModel.loading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(
          child: LoadingIndicator(),
        ),
      );
    }
    if (viewModel.error) {
      return const SizedBox(
        width: double.infinity,
        child: Center(
          child: ErrorIndicator(),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Consumer<StatisticsPageVM>(
          builder: (context, viewModel, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: TopRow(),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 800,
                width: double.infinity,
                child: BottomRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomRow extends StatelessWidget {
  const BottomRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<StatisticsPageVM>(
        builder: (context, viewModel, _) => Row(
          children: [
            BottomRowComponent(
              data: viewModel.mostLikedSites,
              label: 'Most liked sites',
            ),
            BottomRowComponent(
              data: viewModel.mostDislikedSites,
              label: 'Most disliked sites',
            ),
            BottomRowComponent(
              data: viewModel.mostSitesTown,
              label: 'Town with most sites',
            ),
            BottomRowComponent(
              data: viewModel.mostPhotosSites,
              label: 'Site with most images',
            ),
          ],
        ),
      );
}

class TopRow extends StatelessWidget {
  const TopRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<StatisticsPageVM>(
        builder: (context, viewModel, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TopRowComponent(
              data: viewModel.mostVotedSites,
              label: 'Most voted sites',
            ),
            const FluentVerticalSeparator(),
            TopRowComponent(
              data: viewModel.leastVotedSites,
              label: 'Least voted sites',
            ),
          ],
        ),
      );
}
