// to represent information about statues
class Statue {
  String name;
  String artist;
  int year;
  double weight; // in pounds
  boolean whole;
  
  // the constructor
  Statue(String name, String artist, int year, double weight, boolean whole) {
    this.name = name;
    this.artist = artist;
    this.year = year;
    this.weight = weight;
    this.whole = whole;
  }
}

// examples of statues
class ExamplesStatue {
  ExamplesStatue(){}
  
  Statue statueOfLiberty = new Statue("Statue Of Liberty", "Bartholdi", 1886, 450000, true);
  Statue venusDeMilo = new Statue("Venus de Milo", "Alexandros of Antioch", -115, 1984.16, false);  
}