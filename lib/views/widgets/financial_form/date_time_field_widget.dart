import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc_app/utils/theme_extensions.dart';

class DateTimeField extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;

  const DateTimeField({super.key, required this.onDateTimeSelected});

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  List<bool> isSelected = [true, false];
  bool showTimeWidget = false;
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateTimeSelected(selectedDateTime!);
    });
  }

  Future<void> _handlePressed(int index) async {
    FocusScope.of(context).unfocus();

    if (index == 0 && isSelected[0]) {
      final now = DateTime.now();
      setState(() => selectedDateTime = now);
      widget.onDateTimeSelected(now);
      return;
    }

    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = i == index;
      }
    });

    DateTime? pickedDateTime;

    if (index == 0) {
      pickedDateTime = DateTime.now();
    } else if (index == 1) {
      final now = DateTime.now();
      final safeContext = context;

      final pickedDate = await showDatePicker(
        context: safeContext,
        initialDate: now,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate == null) {
        final now = DateTime.now();
        setState(() {
          isSelected = [true, false];
          selectedDateTime = now;
        });
        widget.onDateTimeSelected(now);
        return;
      }

      final pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: safeContext,
        initialTime: TimeOfDay.fromDateTime(now),
        initialEntryMode: TimePickerEntryMode.inputOnly,
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              hourMinuteColor: Colors.transparent,
            ),
          ),
          child: child!,
        ),
      );

      if (pickedTime != null) {
        pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }

      if (pickedDateTime == null) {
        final now = DateTime.now();
        setState(() {
          isSelected = [true, false];
          selectedDateTime = now;
        });
        widget.onDateTimeSelected(now);
        return;
      }
    }

    if (!mounted) return;

    if (pickedDateTime != null) {
      setState(() {
        selectedDateTime = pickedDateTime;
        if (isSelected[1]) showTimeWidget = true;
      });
      widget.onDateTimeSelected(pickedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) => Row(
    spacing: 16,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        Icons.calendar_month_rounded,
        color: Theme.of(context).colorScheme.secondary,
      ),
      if (isSelected[0])
        ToggleButtons(
          isSelected: isSelected,
          onPressed: _handlePressed,
          borderColor: context.colorScheme.primary,
          selectedBorderColor: context.colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Agora'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Selecionar'),
            ),
          ],
        ),
      if (!isSelected[0] && showTimeWidget)
        _DateTimeDisplay(
          dateTime: selectedDateTime!,
          onTap: () => _handlePressed(1),
        ),
    ],
  );
}

class _DateTimeDisplay extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onTap;

  const _DateTimeDisplay({required this.dateTime, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(color: context.colorScheme.primary),
          ),
        ),
        child: Text(formatted, style: context.textTheme.bodyLarge),
      ),
    );
  }
}
