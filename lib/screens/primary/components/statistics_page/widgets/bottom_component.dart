import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../../../../../utilitiies/extensions.dart';
import '../statistics_page_viewmodel.dart';
import 'donut_piechart.dart';

class BottomRowComponent extends StatelessWidget {
  const BottomRowComponent({
    required this.data,
    required this.label,
    Key? key,
  }) : super(key: key);

  final List<LinearData> data;
  final String label;

  @override
  Widget build(BuildContext context) {
    final darkTheme = FluentTheme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: DonutAutoLabelChart(
                context.read<StatisticsPageVM>().pieData(
                      label,
                      darkTheme: darkTheme,
                      data: data,
                    ),
                animate: true,
                label: label,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  data.length,
                  (index) => Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: data[index].hexColor.toColor(),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          data[index].label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FluentTheme.of(context).typography.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
