// to represent housing
interface IHousing {
  
}

// to represent a hut
class Hut implements IHousing {
  int capacity;
  int population; // population has to be less than capacity
  
  Hut(int capacity, int population) {
    this.capacity = capacity;
    this.population = population;
  }
}

// to represent an inn
class Inn implements IHousing {
  String name;
  int capacity;
  int population; // population has to be less than capacity
  int stalls;
  
  Inn(String name, int capacity, int population, int stalls) {
    this.name = name;
    this.capacity = capacity;
    this.population = population;
    this.stalls = stalls;
  }
}

// to represent a castle
class Castle implements IHousing {
  String name;
  String familyName;
  int population;
  int carriageHouse;
  
  Castle(String name, String familyName, int population, int carriageHouse) {
    this.name = name;
    this.familyName = familyName;
    this.population = population;
    this.carriageHouse = carriageHouse;
  }
}

// to represent transportation
interface ITransportation {
  
}

// to represent a horse
class Horse implements ITransportation {
  String from;
  String to; // can only go to inn if there's room in stables. Can go to any hut/castle.
  String name;
  String color;
  
  Horse(String from, String to, String name, String color) {
    this.from = from;
    this.to = to;
    this.name = name;
    this.color = color;
  }
}

// to represent a carriage
class Carriage implements ITransportation {
  String from; // can only travel from Inns to Castles or vice versa.
  String to; // when going to Castle there must be room in the carriage house.
  int tonnage; // can only carry a limited supply of tonnage 
  
  Carriage(String from, String to, int tonnage) {
    this.from = from;
    this.to = to;
    this.tonnage = tonnage;
  }
}

//examples of travel
class ExamplesTravel {
  ExamplesTravel() {}
  
  IHousing hovel = new Hut(5, 1);
  IHousing winterfell = new Castle("Winterfell", "Stark", 500, 6);
  IHousing crossroads = new Inn("Inn At The Crossroads", 40, 20, 12);
  IHousing oakgrove = new Hut(20, 14);
  IHousing utopia = new Castle("Utopia", "Leon", 780, 8);
  IHousing independenceinn = new Inn("Independence Inn", 90, 52, 20);
  
  ITransportation horse1 = new Horse("Inn At The Crossroads", "Winterfell", "Iris", "black");
  ITransportation horse2 = new Horse("Utopia", "Independence Inn", "Luna", "brown");
  ITransportation carriage1 = new Carriage("Independence Inn", "Utopia", 5);
  ITransportation carriage2 = new Carriage("Winterfell", "Inn At The Crossroads", 12);
}
