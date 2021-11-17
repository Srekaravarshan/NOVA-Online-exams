import 'package:exam/models/models.dart';
import 'package:exam/screens/question_paper/cubit/question_paper_cubit.dart';
import 'package:exam/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

Widget textViewField({String? hintText, Function(String)? onChanged}) {
  return TextFormField(
    decoration: InputDecoration(
        hintText: hintText,
        border: const UnderlineInputBorder(),
        isDense: true,
        enabledBorder: InputBorder.none),
    onChanged: onChanged,
  );
}

class RadioButton extends StatelessWidget {
  const RadioButton({
    Key? key,
    required this.label,
    this.groupValue = false,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final bool groupValue;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: <Widget>[
            Radio<bool>(
              groupValue: groupValue,
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}

Map<QuestionType, String> dropdownValues = {
  QuestionType.choice: 'Multiple choice',
  QuestionType.checkBox: 'Check boxes',
  QuestionType.shortAnswer: 'Short answer',
  QuestionType.paragraph: 'Paragraph',
  QuestionType.dropdown: 'Dropdown',
};

Widget toolIcon({Function()? onTap, required IconData icon}) {
  return InkWell(
      onTap: onTap,
      child: Padding(padding: EdgeInsets.all(12), child: Icon(icon, size: 24)));
}

Widget bottomTools(
    {required BuildContext context, required QuestionPaperState state}) {
  return Row(
    children: [
      toolIcon(
          onTap: () => context.read<QuestionPaperBloc>().add(AddQuestion(
              sections: state.sections,
              sectionIndex: state.sectionIndex,
              questionIndex: state.questionIndex)),
          icon: Icons.add),
      toolIcon(
          onTap: () => context.read<QuestionPaperBloc>().add(
              AddTitleAndDescription(
                  sections: state.sections,
                  sectionIndex: state.sectionIndex,
                  questionIndex: state.questionIndex)),
          icon: Icons.text_fields_outlined),
      toolIcon(
          onTap: () => context.read<QuestionPaperBloc>().add(const AddImage()),
          icon: Icons.image_outlined),
      toolIcon(
          onTap: () => context.read<QuestionPaperBloc>().add(const AddVideo()),
          icon: Icons.video_collection_outlined),
      toolIcon(
          onTap: () => context
              .read<QuestionPaperBloc>()
              .add(AddSection(sections: state.sections)),
          icon: Icons.horizontal_split_outlined),
    ],
  );
}

Widget choiceWidget(Question question) {
  return Column(children: [
    ListView.builder(
      itemCount: question.options.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => RadioButton(
        label: question.options[index],
        groupValue: false,
        onChanged: () {},
        value: false,
      ),
    ),
    if (question.hasOtherOption)
      RadioButton(label: 'Other', value: true, onChanged: () {}),
    Row(
      children: [
        RadioButton(label: "Add option", value: true, onChanged: () {}),
        addHorizontalSpace(8),
        if (!question.hasOtherOption)
          TextButton(child: const Text('Add other'), onPressed: () {})
      ],
    ),
  ]);
}

Widget titleAndDescriptionWidget(Question question) {
  return Column(
    children: [
      TextFormField(
        decoration: const InputDecoration(
            hintText: 'Title',
            border: UnderlineInputBorder(),
            isDense: true,
            enabledBorder: InputBorder.none),
        onChanged: (value) => {},
      ),
      TextFormField(
        decoration: const InputDecoration(
            hintText: 'Description',
            border: UnderlineInputBorder(),
            isDense: true,
            enabledBorder: InputBorder.none),
        onChanged: (value) => {},
      ),
    ],
  );
}

Widget addFileWidget(Question question) {
  return ElevatedButton(onPressed: () {}, child: const Text('Upload File'));
}

Widget checkBoxWidget(Question question) {
  return const Text('checkBox');
}

Widget dropdownWidget(Question question) {
  return const Text('dropdown');
}

Widget shortAnswerWidget(Question question) {
  return TextFormField(
    decoration: const InputDecoration(
        hintText: 'Title',
        border: UnderlineInputBorder(),
        isDense: true,
        enabledBorder: InputBorder.none),
    onChanged: (value) => {},
  );
}

Widget paragraphWidget(Question question) {
  return TextFormField(
    decoration: const InputDecoration(
        hintText: 'Title',
        border: UnderlineInputBorder(),
        isDense: true,
        enabledBorder: InputBorder.none),
    onChanged: (value) => {},
  );
}

Widget imageWidget(Question question) {
  return Image.file(question.file!);
}

Widget videoWidget(Question question) {
  return const Text('video');
}
