class Entry {
  String id;
  String title;
  String desc;
  String date;
  String emoji;

  Entry({
    required this.id,
    required this.title,
    required this.desc,
    required this.date,
    this.emoji = '😺',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'emoji': emoji,
    };
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      date: json['date'],
      emoji: json['emoji'] ?? '😺',
    );
  }
}
