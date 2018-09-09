class NewsPost {
  String title;
  String content;
  String photoUrl;
  int postId;
  int authorId;
  bool favorite;

  NewsPost(this.title, this.content, this.photoUrl, this.postId, this.authorId,
      {this.favorite});
}

class NewsAuthor {
  int authorId;
  String name;
  String username;
  String avatarUrl;
  String email;

  NewsAuthor(authorId, name, username, email) {
    this.authorId = authorId;
    this.name = name;
    this.username = username;
    this.email = email;
    this.avatarUrl = "https://avatars.io/twitter/$username/small";
  }
}

class NewsFilter {
  List<int> favs = [];

  bool shouldBeFavorite;

  NewsFilter({this.favs, this.shouldBeFavorite = false});

  bool matches(NewsPost post) {
    if (shouldBeFavorite) {
      if (!favs.contains(post.postId)) {
        return false;
      }
    }

    return true;
  }
}
