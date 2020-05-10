class SuccessException implements Exception{
  final String message;

  SuccessException(this.message);

  @override
  String toString(){
    return message;
  }
}