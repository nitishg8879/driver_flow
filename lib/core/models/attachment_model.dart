import 'package:freezed_annotation/freezed_annotation.dart';
import '../../utils/constants/app_enums.dart';

part 'attachment_model.freezed.dart';
part 'attachment_model.g.dart';

@freezed
class AttachmentModel with _$AttachmentModel {
  const factory AttachmentModel({
    required String id,
    required String name,
    required String url,
    required String storagePath,
    required AttachmentFileType fileType,
    required AttachmentSource source,
    required String ownerId,
    required String uploadedBy,
    DateTime? uploadedAt,
  }) = _AttachmentModel;

  factory AttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentModelFromJson(json);
}
