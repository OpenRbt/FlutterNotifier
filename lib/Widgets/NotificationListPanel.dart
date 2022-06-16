import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';

class NotificationListPanel extends StatelessWidget {
  final NotificationEvent notificationEvent;

  final String? TargetPost;
  final String? TargetPostHash;
  final bool Success;
  final int Amount;

  const NotificationListPanel({
    Key? key,
    required this.notificationEvent,
    this.TargetPost,
    this.TargetPostHash,
    required this.Success,
    required this.Amount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 175,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Приложение: ${notificationEvent.packageName ?? ""}",
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Заголовок: ${notificationEvent.title ?? ""}",
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Время: ${DateTime.fromMillisecondsSinceEpoch(notificationEvent.timestamp ?? 0).toString()}",
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Сообщение: ${notificationEvent.text ?? ""}",
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(TargetPost ?? "Нет поста"),
              Text(TargetPostHash ?? "Нет привязки"),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Сумма: "),
              Text("$Amount ₸"),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Статус: "),
              Text(
                Success ? "Успешно" : "Не успешно",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Success ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
