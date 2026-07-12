import 'package:chatapp_task/core/app_color.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.name,
    required this.chat,
    required this.lastTime,
    required this.countMessage,
    required this.image,
    this.onTap,
  });

  final String name;
  final String image;
  final String chat;
  final String lastTime;
  final int countMessage;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 26,
        backgroundImage:
            image.isNotEmpty ? NetworkImage(image) : null,
        child: image.isEmpty ? Icon(Icons.person) : null,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            lastTime,
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              chat,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xffADB5BD),
                  fontWeight: FontWeight.w300),
            ),
          ),

          if (countMessage > 0)
            CircleAvatar(
              radius: 9,
              backgroundColor: Color(0x26d84d4d),
              child: Text(
                countMessage.toString(),
                style: TextStyle(
                    color: AppColor.primrey,
                    fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}