class Surah {
  final int number;
  final String name;
  final String arabicName;
  final int ayahCount;
  
  Surah({
    required this.number,
    required this.name,
    required this.arabicName,
    required this.ayahCount,
  });
  
  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      arabicName: json['arabic_name'],
      ayahCount: json['ayah_count'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'arabic_name': arabicName,
      'ayah_count': ayahCount,
    };
  }
}
