/// import statements
import 'package:flutter/material.dart';
import 'Chat.dart';

/// a chat bubble widget that takes in a message and automatically aligns itself based on the sender
class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);

  /// method for generating a standard string representation of a DateTime object
  String getFormattedTime(DateTime timestamp, bool isSemantic) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String ret = '';

    /// use Today if date is the same
    if (timestamp.year == DateTime.now().year &&
        timestamp.month == DateTime.now().month &&
        timestamp.day == DateTime.now().day) {
      ret += 'Today ';
    } else {
      if (isSemantic) {
        /// use month name for semantic label
        ret +=
            '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year} ';
      } else {
        /// use int value for regular label
        ret += '${timestamp.month}/${timestamp.day}/${timestamp.year} ';
      }
    }

    /// use AM/PM instead of military time
    int hour = timestamp.hour % 12;
    if (hour == 0) {
      hour = 12;
    }

    /// return date+time as string
    return ret +=
        '${hour.toString()}:${timestamp.minute.toString().padLeft(2, '0')}${timestamp.hour < 12 ? 'AM' : 'PM'}';
  }

  /// build page using inputs
  @override
  Widget build(BuildContext context) {
    /// adjusting bounds
    final messageWidth = MediaQuery.of(context).size.width * 0.5;
    return Column(
      crossAxisAlignment:

          /// align current user on the right with lighter color
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
        Text(
          getFormattedTime(message.timestamp, false),
          semanticsLabel: getFormattedTime(message.timestamp, true),
          style: const TextStyle(
            fontFamily: 'Times New Roman',
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.white : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isCurrentUser
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  bottomRight: isCurrentUser
                      ? const Radius.circular(0)
                      : const Radius.circular(16),
                ),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: messageWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black87,
                          fontFamily: 'Times New Roman',
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
