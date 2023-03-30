import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_notifier/internal/entity/entity.dart';

class NotificationListPanel extends StatelessWidget {
  final int? id;
  final String? packageName;
  final String? title;
  final DateTime? timestamp;
  final String? message;

  final bool success;
  final String? errorMessage;

  final int amount;
  final String? targetHost;
  final String? targetPost;
  final String? targetHash;

  static NotificationListPanel fromNotificationEvent(AppNotificationEvent event) {
    return NotificationListPanel(
      id: event.id,
      packageName: event.packageName,
      title: event.title,
      timestamp: event.timestamp != null ? DateTime.fromMillisecondsSinceEpoch(event.timestamp!, isUtc: true) : null,
      message: event.text,
      success: event.success,
      errorMessage: event.errorMessage,
      amount: event.amount,
      targetHost: event.targetHost,
      targetPost: event.targetPost,
      targetHash: event.targetHash,
    );
  }

  const NotificationListPanel({Key? key, this.id, this.targetPost, required this.success, required this.amount, this.packageName, this.title, this.timestamp, this.message, this.targetHost, this.targetHash, this.errorMessage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ID: ${id ?? ""}",
                  style: textTheme.bodySmall,
                ),
                Text(
                  packageName ?? "",
                  style: textTheme.bodySmall,
                ),
                Text(
                  " ${timestamp?.toLocal().hour ?? ""}:${timestamp?.toLocal().minute ?? ""}:${timestamp?.toLocal().second ?? ""}  ${timestamp?.toLocal().day ?? ""}.${timestamp?.toLocal().month ?? ""}.${timestamp?.toLocal().year ?? ""}",
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            Text(
              message ?? "",
              style: textTheme.titleLarge,
            ),
            Text(
              "Статус: ${success ? "УСПЕШНО" : "ОШИБКА"}",
              style: textTheme.titleLarge!.copyWith(color: success ? Colors.green : Colors.red),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    errorMessage != null
                        ? Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: Text(
                              errorMessage!,
                              style: textTheme.bodySmall!.copyWith(color: Colors.red),
                            ),
                          )
                        : const Spacer(
                            flex: 2,
                          ),
                  ],
                )
              ],
            ),
            Text(
              "Сумма: $amount",
              style: textTheme.titleLarge,
            ),
            Text(
              "Хост: ${targetHost ?? "NO_HOST"}",
              style: textTheme.titleMedium,
            ),
            Text(
              "Пост: ${targetPost ?? "NO_POST"} / ${targetHash ?? "NO_HASH"}",
              style: textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
