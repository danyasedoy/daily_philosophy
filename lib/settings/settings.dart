abstract class Settings {
  //10.0.2.2:8080
  static const String _ipAddress = '46.19.67.69:88';
  static String registerQueryLink = 'http://$_ipAddress/register';
  static String authQueryLink = 'http://$_ipAddress/auth';
  static String articleOfTheDayLink = 'http://$_ipAddress/articleDay';
  static String likeArticleLink = 'http://$_ipAddress/like/';
  static String deleteArticleFromFavLink = 'http://$_ipAddress/remove_like/';
  static String favArticlesListLink='http://$_ipAddress/get_likes';
  static String questionOfTheDay='http://$_ipAddress/question';
  static String answer='http://$_ipAddress/answer/';
  static String userInfo='http://$_ipAddress/me';
}