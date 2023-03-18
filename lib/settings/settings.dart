abstract class Settings {
  //10.0.2.2:8080
  static const String _ipAddress = '10.0.2.2:8080';
  static String registerQueryLink = 'http://$_ipAddress/register';
  static String authQueryLink = 'http://$_ipAddress/auth';
  static String articleOfTheDayLink = 'http://$_ipAddress/article_day';
  static String likeArticleLink = 'http://$_ipAddress/like/';
  static String deleteArticleFromFavLink = 'http://$_ipAddress/remove_like/';
  static String favArticlesListLink='http://$_ipAddress/get_likes';
}