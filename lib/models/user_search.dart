class UserSearch {
  final String username;

  UserSearch({required this.username});

  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(username: json['username']);
  }
}
