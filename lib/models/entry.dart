class Entry {
  String id;
  String title;
  String desc;
  String date;

  Entry({
    required this.id,
    required this.title,
    required this.desc,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'desc': desc, 'date': date};
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      date: json['date'],
    );
  }
}
