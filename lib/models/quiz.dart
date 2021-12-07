///=============================================================================
/// @author sangnd
/// @date 22/09/2021
///=============================================================================

class QuizModel {
  String userId;
  String quizId;
  String quizImageUrl;
  String quizTitle;
  String quizDescription;

  QuizModel(
      {required this.userId,
      required this.quizId,
      required this.quizImageUrl,
      required this.quizDescription,
      required this.quizTitle});
}
