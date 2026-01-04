import 'package:equatable/equatable.dart';

class Instruction extends Equatable {
  final String title;
  final List<String> steps;

  const Instruction({required this.title, required this.steps});

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      title: json['title'] ?? '',
      steps: List<String>.from(json['steps'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'steps': steps};

  @override
  List<Object?> get props => [title, steps];
}
