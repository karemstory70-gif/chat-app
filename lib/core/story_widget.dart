import 'package:chatapp_task/core/app_color.dart';
import 'package:flutter/material.dart';
class StoryWidget extends StatelessWidget {
  StoryWidget({
    super.key, required this.image , required this.isMe, this.name
  });

  final String? name;
  final String? image;
   bool isMe;


  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color:
                     isMe
                    ? Colors.grey.shade500
                    : AppColor.primrey,
                    width: 2
                )
            ),
            child:

            isMe
            ?Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade200,
              ),

              child: Icon(Icons.add),
            )
            :  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: image != null && image!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: image == null || image!.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
          ),
          SizedBox(height: 2,),
          Text(
            isMe
            ?'Your Story'
            : name!
            , style: TextStyle(fontSize: 10),)
        ],
      ),
    );
  }
}
