class Users {
  final String image;
  final String name;
  final String chat;
  final String lastTime;
  final int countMessage;

  Users({
    required this.image,
    required this.name,
    required this.chat,
    required this.countMessage,
    required this.lastTime,
  });
  factory Users.fromMap(Map<String, dynamic> data) {
    return Users(
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      chat: data['lastMessage'] ?? '',
      lastTime: data['lastTime'] ?? '',
      countMessage: data['countMessage'] ?? 0,
    );
  }
}
