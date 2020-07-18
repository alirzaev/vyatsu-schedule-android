class Group {
  final String id;

  final String name;

  Group(this.id, this.name);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(dynamic obj) {
    if (obj is Group) {
      return this.id == obj.id;
    } else {
      return false;
    }
  }

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}

class Faculty {
  final String name;

  final List<Group> groups;

  Faculty(this.name, this.groups);

  Faculty.fromJson(Map<String, dynamic> json)
      : name = json['faculty'],
        groups = (json['groups'] as List<dynamic>)
            .map((group) => Group.fromJson(group as Map<String, dynamic>))
            .toList();
}

class Schedule {
  final List<List<List<String>>> schedule;

  final String group;

  Schedule(this.group, this.schedule);

  Schedule.fromJson(Map<String, dynamic> json)
      : group = json['group'],
        schedule = (json['weeks'] as List<dynamic>)
            .map((week) => (week as List<dynamic>)
                .map((day) => (day as List<dynamic>)
                    .map((lesson) => (lesson as String))
                    .toList())
                .toList())
            .toList();
}
