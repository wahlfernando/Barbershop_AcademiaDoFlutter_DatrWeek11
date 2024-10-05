import 'package:dw_barbershop/src/core/theme/ui/constants.dart';
import 'package:flutter/material.dart';

class WeekdaysPanel extends StatelessWidget {
  final List<String>? enableDays;
  final ValueChanged<String> onDayPressed;
  const WeekdaysPanel({
    super.key,
    required this.onDayPressed,
    this.enableDays,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione dos dias da semana',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonDay(
                  label: 'Seg',
                  onDaySelected: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Ter',
                  onDaySelected: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Qua',
                  onDaySelected: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Qui',
                  onDaySelected: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Sex',
                  onDaySelected: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Sab',
                  onDaySelected: onDayPressed,
                  enableDays: enableDays,
                ),
                ButtonDay(
                  label: 'Dom',
                  onDaySelected: onDayPressed,
                  enableDays: enableDays,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ButtonDay extends StatefulWidget {
  final List<String>? enableDays;
  final String label;
  final ValueChanged<String> onDaySelected;

  const ButtonDay({
    super.key,
    required this.label,
    required this.onDaySelected,
    this.enableDays,
  });

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  var selected = false;
  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final ButtonDay(:enableDays, :label) = widget;
    final dissableDay = enableDays != null && !enableDays.contains(label);
    if (dissableDay) {
      buttonColor = Colors.grey[400]!;
    }

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: dissableDay
            ? null
            : () {
                widget.onDaySelected(label);
                setState(() {
                  selected = !selected;
                });
              },
        child: Container(
          margin: const EdgeInsets.only(left: 2, right: 2),
          width: 40,
          height: 56,
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
      ),
    );
  }
}
