import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:flutter/material.dart';

class HoursPanel extends StatelessWidget {
  final List<int>? enableTimes;
  final int startTime;
  final int endTime;
  final ValueChanged<int> onHourPressed;

  const HoursPanel({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enableTimes,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Selecione os horarios do atendimento',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: [
              for (int i = startTime; i <= endTime; i++)
                TimeButton(
                  enableTimes: enableTimes,
                  onPressed: onHourPressed,
                  value: i,
                  label: '${i.toString().padLeft(2, '0')}:00',
                )
            ],
          )
        ],
      ),
    );
  }
}

class TimeButton extends StatefulWidget {
  final List<int>? enableTimes;
  final String label;
  final int value;
  final ValueChanged<int> onPressed;

  const TimeButton({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed, this.enableTimes,
  });

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final TimeButton(:enableTimes, :label, :value, :onPressed) = widget;
     final dissableTime = enableTimes != null && !enableTimes.contains(value);
    if (dissableTime) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: dissableTime ? null :() {
        setState(() {
          selected = !selected;
          onPressed(value);
        });
      },
      child: Container(
        width: 54,
        height: 36,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: buttonColor,
            border: Border.all(color: buttonBorderColor)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
