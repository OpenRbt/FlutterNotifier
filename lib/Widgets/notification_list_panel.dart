import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_notifier/Models/notification_event_log.dart';

class NotificationListPanel extends StatelessWidget {
  final String? PackageName;
  final String? Title;
  final DateTime? Timestamp;
  final String? Message;

  final bool Success;
  final String? ErrorMessage;

  final int Amount;
  final String? TargetHost;
  final String? TargetPost;
  final String? TargetHash;

  static NotificationListPanel fromNotificationEventLog(NotificationEventLog eventLog) {
    return NotificationListPanel(
      PackageName: eventLog.PackageName,
      Title: eventLog.Title,
      Timestamp: eventLog.Timestamp != null ? DateTime.fromMillisecondsSinceEpoch(eventLog.Timestamp!, isUtc: true) : null,
      Message: eventLog.Text,
      Success: eventLog.Success,
      ErrorMessage: eventLog.ErrorMessage,
      Amount: eventLog.Amount,
      TargetHost: eventLog.TargetHost,
      TargetPost: eventLog.TargetPost,
      TargetHash: eventLog.TargetHash,
    );
  }

  const NotificationListPanel({Key? key, this.TargetPost, required this.Success, required this.Amount, this.PackageName, this.Title, this.Timestamp, this.Message, this.TargetHost, this.TargetHash, this.ErrorMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 125,
        width: double.maxFinite,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      PackageName ?? "",
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      " ${Timestamp?.toLocal().hour ?? ""}:${Timestamp?.toLocal().minute ?? ""}:${Timestamp?.toLocal().second ?? ""}  ${Timestamp?.toLocal().day ?? ""}.${Timestamp?.toLocal().month ?? ""}.${Timestamp?.toLocal().year ?? ""}",
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: Text(
                Message ?? "",
                style: textTheme.bodyMedium,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Статус:",
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          Success ? "УСПЕШНО" : "ОШИБКА",
                          style: textTheme.bodyMedium!.copyWith(color: Success ? Colors.green : Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    ErrorMessage != null
                        ? Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: FittedBox(
                              alignment: Alignment.centerRight,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                ErrorMessage!,
                                style: textTheme.bodySmall!.copyWith(color: Colors.red),
                              ),
                            ),
                          )
                        : const Spacer(
                            flex: 2,
                          ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Сумма:",
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "$Amount",
                      style: textTheme.bodyMedium,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Хост:",
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      TargetHost ?? "NO_HOST",
                      style: textTheme.bodyMedium,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Пост:",
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      TargetPost ?? "NO_POST",
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      TargetHash ?? "NO_HASH",
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
