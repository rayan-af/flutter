import 'package:cloud_functions/cloud_functions.dart';

class AIAgentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Sends a message to the AI Assistant Genkit flow and returns the response.
  Future<String> sendMessageToAgent(String message) async {
    try {
      final callable = _functions.httpsCallable('chatWithAgent');
      final result = await callable.call<String>(message);
      return result.data;
    } on FirebaseFunctionsException catch (e) {
      print('Failed to call AI Agent: ${e.code} - ${e.message}');
      throw Exception('AI Agent is currently unavailable.');
    } catch (e) {
      print('Unknown error calling AI Agent: $e');
      throw Exception('An unexpected error occurred.');
    }
  }
}
