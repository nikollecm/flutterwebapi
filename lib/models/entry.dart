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
}
