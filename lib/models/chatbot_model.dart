class ChatbotResponse {
  final String message;
  final List<String> suggestions;
  final Map<String, dynamic>? data;
  final String type; // text, image, action, etc.

  ChatbotResponse({
    required this.message,
    required this.suggestions,
    this.data,
    required this.type,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      message: json['message'],
      suggestions: List<String>.from(json['suggestions']),
      data: json['data'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'suggestions': suggestions,
      'data': data,
      'type': type,
    };
  }
}

class ChatbotSuggestion {
  final String text;
  final String type;
  final Map<String, dynamic>? data;

  ChatbotSuggestion({
    required this.text,
    required this.type,
    this.data,
  });

  factory ChatbotSuggestion.fromJson(Map<String, dynamic> json) {
    return ChatbotSuggestion(
      text: json['text'],
      type: json['type'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'data': data,
    };
  }
} 