import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';

enum LoadingType {
  cloudDownload,
  cloudTransfer,
  file,
  clock,
  plane,
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
    this.loadingType = LoadingType.cloudDownload,
  }) : super(key: key);
  final LoadingType loadingType;

  String _getFile() {
    switch (loadingType) {
      case LoadingType.cloudDownload:
        return 'assets/lottie/cloud-download.json';
      case LoadingType.cloudTransfer:
        return 'assets/lottie/cloud-transfer.json';
      case LoadingType.file:
        return 'assets/lottie/loading.json';
      case LoadingType.clock:
        return 'assets/lottie/loading2.json';
      case LoadingType.plane:
        return 'assets/lottie/loading3.json';
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 200,
        width: 200,
        child: Lottie.asset(
          _getFile(),
        ),
      );
}
