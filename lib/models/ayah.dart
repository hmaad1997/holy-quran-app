class Ayah {
  final int number;
  final int surahNumber;
  final String text;
  final String translation;
  
  Ayah({
    required this.number,
    required this.surahNumber,
    required this.text,
    this.translation = '',
  });
  
  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'],
      surahNumber: json['surah_number'],
      text: json['text'],
      translation: json['translation'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'surah_number': surahNumber,
      'text': text,
      'translation': translation,
    };
  }
}
