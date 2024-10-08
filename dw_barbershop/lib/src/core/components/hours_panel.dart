import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:flutter/material.dart';

class HoursPanel extends StatefulWidget {
  final List<int>? enableTimes;
  final int startTime;
  final int endTime;
  final ValueChanged<int> onHourPressed;
  final bool sinbgleSelection;

  const HoursPanel({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enableTimes,
  }) : sinbgleSelection = false;

  const HoursPanel.sinbgleSelection({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enableTimes,
  }) : sinbgleSelection = true;

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSeletion;

  @override
  Widget build(BuildContext context) {
    final HoursPanel(sinbgleSelection:singleSelection) = widget;
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
              for (int i = widget.startTime; i <= widget.endTime; i++)
                TimeButton(
                  enableTimes: widget.enableTimes,
                  timeSelected: lastSeletion,
                  singleSeletion: singleSelection,
                  onPressed: (timeSelected) {
                    setState(() {
                      if (singleSelection) {
                        if (lastSeletion == timeSelected) {
                          lastSeletion = null;
                        } else {
                          lastSeletion = timeSelected;
                        }
                      }
                    });

                    widget.onHourPressed(timeSelected);
                  },
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
  final bool singleSeletion;
  final int? timeSelected;

  const TimeButton({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
    this.enableTimes,
    required this.singleSeletion,
    required this.timeSelected,
  });

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final TimeButton(
      :singleSeletion,
      :timeSelected,
      :label,
      :value,
      :enableTimes,
      :onPressed
    ) = widget;

    if (singleSeletion) {
      if (timeSelected != null) {
        if (timeSelected == value) {
          selected = true;
        } else {
          selected = false;
        }
      }
    }

    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final dissableTime = enableTimes != null && !enableTimes.contains(value);
    if (dissableTime) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: dissableTime
          ? null
          : () {
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
