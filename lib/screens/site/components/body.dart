import 'package:desktop_drop/desktop_drop.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:provider/provider.dart';

import '../../../data/models/site.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../widgets/vertical_separator.dart';
import '../site_viewmodel.dart';

class SiteBody extends StatelessWidget {
  const SiteBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: FluentTheme.of(context).micaBackgroundColor,
        child: ScaffoldPage(
          header: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () => context.read<SiteScreenVM>().goBack(context),
                      child: const Icon(
                        FluentIcons.back,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          padding: EdgeInsets.zero,
          content: context.select<SiteScreenVM, bool>((prov) => prov.loading)
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    bottom: 20,
                    right: 20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.siteInformation,
                              style:
                                  FluentTheme.of(context).typography.bodyLarge,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Expanded(
                              child: SiteInformation(),
                            ),
                            const FluentHorizontalSeparator(),
                            const Expanded(
                              child: SitePhotos(),
                            ),
                          ],
                        ),
                      ),
                      const FluentVerticalSeparator(),
                      Expanded(
                        child: Column(
                          children: const [
                            Expanded(
                              flex: 2,
                              child: SelectionMap(),
                            ),
                            CoordinatesRow(),
                            SizedBox(
                              height: 100,
                            ),
                            SiteCreationRow(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
}

class SiteCreationRow extends StatelessWidget {
  const SiteCreationRow({Key? key}) : super(key: key);

  Future<void> showFailDialog(
    BuildContext context,
  ) async {
    final text = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(text.error),
        content: Text(text.errorBackend),
        actions: [
          Button(
            child: Text(text.ok),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> emptyFieldsError(
    BuildContext context,
  ) async {
    final text = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(text.emptyFieldsSite),
        content: Text(text.enterAllFields),
        actions: [
          Button(
            child: Text(text.ok),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: () async {
          final response = await context.read<SiteScreenVM>().submit();
          switch (response) {
            case SubmitResponse.success:
              Navigator.of(context).pop();
              break;
            case SubmitResponse.fail:
              await showFailDialog(context);
              break;
            case SubmitResponse.errorFields:
              await emptyFieldsError(context);
              break;
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                context.watch<SiteScreenVM>().newSite
                    ? AppLocalizations.of(context)!.createSite
                    : AppLocalizations.of(context)!.updateSite,
                style: FluentTheme.of(context).typography.bodyLarge,
              ),
            ),
          ],
        ),
      );
}

class SelectionMap extends StatelessWidget {
  const SelectionMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<SiteScreenVM>(
        builder: (context, viewModel, _) => FlutterMap(
          mapController: viewModel.mapController,
          options: MapOptions(
            center: latlong.LatLng(
              42.5,
              26,
            ),
            zoom: 6,
            onTap: (_, position) => viewModel.mapClick(position),
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                if (viewModel.point != null)
                  Marker(
                    point: viewModel.point!,
                    builder: (context) => Icon(
                      MfgLabs.location,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
}

class CoordinatesRow extends StatelessWidget {
  const CoordinatesRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<SiteScreenVM>(
        builder: (context, viewModel, _) => SizedBox(
          height: 50,
          child: Stack(
            children: [
              if (viewModel.point != null)
                Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        viewModel.point!.latitude.toStringAsFixed(5),
                        style: FluentTheme.of(context).typography.bodyLarge,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(','),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        viewModel.point!.longitude.toStringAsFixed(5),
                        style: FluentTheme.of(context).typography.bodyLarge,
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: viewModel.clearMap,
                  child: Text(
                    AppLocalizations.of(context)!.clear,
                    style: FluentTheme.of(context).typography.bodyLarge,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

class SitePhotos extends StatelessWidget {
  const SitePhotos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<SiteScreenVM>(
        builder: (context, viewModel, _) => Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.sitePhotos,
                    style: FluentTheme.of(context).typography.bodyLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(
                        viewModel.site.images.length,
                        (index) => GridImage(
                          image: viewModel.site.images[index],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  const Expanded(
                    child: FileDropTarget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: viewModel.pickFiles,
                      child: Text(AppLocalizations.of(context)!.pickImage),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class FileDropTarget extends StatefulWidget {
  const FileDropTarget({
    Key? key,
  }) : super(key: key);

  @override
  State<FileDropTarget> createState() => _FileDropTargetState();
}

class _FileDropTargetState extends State<FileDropTarget> {
  bool dragEntered = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SiteScreenVM>();
    final theme = FluentTheme.of(context);
    return DropTarget(
      onDragDone: viewModel.dragFiles,
      onDragEntered: (detail) {
        setState(() {
          dragEntered = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          dragEntered = false;
        });
      },
      child: Container(
        color: dragEntered
            ? theme.micaBackgroundColor
            : theme.scaffoldBackgroundColor,
        child: Center(
          child: context.select<SiteScreenVM, bool>(
                  (viewModel) => viewModel.imageUploading)
              ? const LoadingIndicator(
                  loadingType: LoadingType.cloudTransfer,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      FluentIcons.file_image,
                      size: 30,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(AppLocalizations.of(context)!.dropHere),
                  ],
                ),
        ),
      ),
    );
  }
}

class GridImage extends StatelessWidget {
  const GridImage({
    required this.image,
    Key? key,
  }) : super(key: key);
  final SiteImage image;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          SizedBox.expand(
            child: CustomCachedImage(
              url: image.url,
              hash: image.hash,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => context.read<SiteScreenVM>().deleteImage(image),
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: FluentTheme.of(context).acrylicBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FluentIcons.cancel,
                ),
              ),
            ),
          )
        ],
      );
}

class SiteInformation extends StatelessWidget {
  const SiteInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<SiteScreenVM>();
    final textProvider = AppLocalizations.of(context)!;
    return Form(
      key: context.read<SiteScreenVM>().formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Scrollbar(
                child: Column(
                  children: [
                    TextFormBox(
                      controller: viewModel.numbController,
                      header: textProvider.number,
                      placeholder: textProvider.enterNumber,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return textProvider.enterNumber;
                        }
                        return null;
                      },
                    ),
                    TextFormBox(
                      controller: viewModel.nameController,
                      header: textProvider.name,
                      placeholder: textProvider.enterName,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return textProvider.enterNumber;
                        }
                        return null;
                      },
                    ),
                    TextFormBox(
                      controller: viewModel.townController,
                      header: textProvider.location,
                      placeholder: textProvider.enterLocation,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return textProvider.enterLocation;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextFormBox(
              controller: viewModel.descController,
              header: textProvider.description,
              placeholder: textProvider.enterDescription,
              maxLines: 20,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return textProvider.enterDescription;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
