abstract class Settings {
  //10.0.2.2:8080
  static const String ipAddress = '46.19.67.69:88';
  static String registerQueryLink = 'http://$ipAddress/register';
  static String authQueryLink = 'http://$ipAddress/auth';
  static String articleOfTheDayLink = 'http://$ipAddress/articleDay';
  static String likeArticleLink = 'http://$ipAddress/like/';
  static String deleteArticleFromFavLink = 'http://$ipAddress/remove_like/';
  static String favArticlesListLink='http://$ipAddress/get_likes';
  static String questionOfTheDay='http://$ipAddress/question';
  static String answer='http://$ipAddress/answer/';
  static String userInfo='http://$ipAddress/me';
}