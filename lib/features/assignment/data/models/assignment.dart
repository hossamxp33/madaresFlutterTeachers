import 'package:madares_app_teacher/features/subject/data/models/subject.dart';

import '../../../../core/models/studyMaterial.dart';

class Assignment {
  Assignment({
    required this.id,
    required this.classSectionId,
    required this.subjectId,
    required this.name,
    required this.instructions,
    required this.dueDate,
    required this.points,
    required this.resubmission,
    required this.extraDaysForResubmission,
    required this.sessionYearId,
    required this.createdAt,
    required this.classSection,
    required this.link,
    required this.studyMaterial,
    required this.subject,
  });
  late final int id;
  late final int classSectionId;
  late final int subjectId;
  late final String name;
  late final String instructions;
  late final DateTime dueDate;
  late final int points;
  late final int resubmission;
  late final int extraDaysForResubmission;
  late final int sessionYearId;
  late final String createdAt;
  late final ClassSection classSection;
  late final List<StudyMaterial> studyMaterial;
  late final Subject subject;
  late final StudyMaterial link;

  Assignment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    classSectionId = json['class_section_id'] ?? 0;
    subjectId = json['subject_id'] ?? 0;
    name = json['name'] ?? "";
    instructions = json["instructions"] ?? "";
    dueDate = DateTime.parse(json['due_date'] ?? "");
    points = json["points"] ?? 0;
    resubmission = json['resubmission'] ?? 0;
    extraDaysForResubmission = json["extra_days_for_resubmission"] ?? 0;
    sessionYearId = json['session_year_id'] ?? 0;
    createdAt = json['created_at'] ?? "";
    link = StudyMaterial.fromJson(json['link'] ?? {});
    classSection = ClassSection.fromJson(json['class_section'] ?? {});
    studyMaterial = ((json['file'] ?? {}) as List)
        .map((e) => StudyMaterial.fromJson(Map.from(e)))
        .toList();
    // file = List.castFrom<dynamic, dynamic>(json['file']);
    subject = Subject.fromJson(json['subject'] ?? {});
  }
}

class ClassSection {
  ClassSection({
    required this.id,
    required this.classId,
    required this.sectionId,
    required this.classTeacherId,
    required this.classs,
    required this.section,
  });
  late final int id;
  late final int classId;
  late final int sectionId;
  late final int classTeacherId;
  late final Classs classs;
  late final Section section;

  ClassSection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'] ?? 0;
    sectionId = json['section_id'] ?? 0;
    classTeacherId = json['class_teacher_id'] ?? 0;
    classs = Classs.fromJson(json['class'] ?? {});
    section = Section.fromJson(json['section'] ?? {});
  }
}

class Classs {
  Classs({
    required this.id,
    required this.name,
    required this.mediumId,
  });
  late final int id;
  late final String name;
  late final int mediumId;

  Classs.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    mediumId = json['medium_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['medium_id'] = mediumId;
    return _data;
  }
}

class Section {
  Section({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
  }
}
