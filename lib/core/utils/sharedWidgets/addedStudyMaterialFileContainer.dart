
import 'package:madares_app_teacher/core/models/pickedStudyMaterial.dart';
import 'package:madares_app_teacher/core/utils/labelKeys.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/addStudyMaterialBottomSheet.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/deleteButton.dart';
import 'package:madares_app_teacher/core/utils/sharedWidgets/editButton.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class AddedStudyMaterialContainer extends StatelessWidget {
  final int fileIndex;
  final PickedStudyMaterial file;
  final Function(int, PickedStudyMaterial) onEdit;
  final Function(int) onDelete;
  const AddedStudyMaterialContainer(
      {Key? key,
      required this.file,
      required this.fileIndex,
      required this.onDelete,
      required this.onEdit,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.w500,
        fontSize: 13.5,);

    final subTitleTextStyle = TextStyle(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
        fontSize: 13,);

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      width: MediaQuery.of(context).size.width * (0.85),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15),),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Show youtubelink or added file path
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: boxConstraints.maxWidth * (0.75),
                  child: Text(
                    file.fileName,
                    style: titleTextStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
                const Spacer(),
                EditButton(onTap: () {
                  UiUtils.showBottomSheet(
                      child: AddStudyMaterialBottomsheet(
                          editFileDetails: true,
                          pickedStudyMaterial: file,
                          onTapSubmit: (updatedFile) {
                            onEdit(fileIndex, updatedFile);
                          },),
                      context: context,);
                },),
                const SizedBox(
                  width: 10,
                ),
                DeleteButton(onTap: () {
                  onDelete(fileIndex);
                },)
              ],
            ),

            file.pickedStudyMaterialTypeId != 2
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text(UiUtils.getTranslatedLabel(context, filePathKey),
                          overflow: TextOverflow.ellipsis,
                          style: titleTextStyle,
                          textAlign: TextAlign.left,),
                      Text(
                        file.studyMaterialFile?.name ?? "",
                        style: subTitleTextStyle,
                      ),
                    ],
                  )
                : const SizedBox(),

            file.pickedStudyMaterialTypeId == 2
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text(UiUtils.getTranslatedLabel(context, youtubeLinkKey),
                          overflow: TextOverflow.ellipsis,
                          style: titleTextStyle,
                          textAlign: TextAlign.left,),
                      Text(
                        file.youTubeLink ?? "",
                        style: subTitleTextStyle,
                      ),
                    ],
                  )
                : const SizedBox(),

            file.pickedStudyMaterialTypeId != 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text(
                          UiUtils.getTranslatedLabel(
                              context, thumbnailImageKey,),
                          overflow: TextOverflow.ellipsis,
                          style: titleTextStyle,
                          textAlign: TextAlign.left,),
                      Text(
                        file.videoThumbnailFile?.name ?? "",
                        style: subTitleTextStyle,
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        );
      },),
    );
  }
}
