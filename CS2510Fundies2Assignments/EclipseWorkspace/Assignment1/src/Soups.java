// to represent Soup
interface ISoup {
}

// to represent a type of broth
class Broth implements ISoup {
  String type;
  
  Broth(String type) {
    this.type = type;
  }
}

// to represent an ingredient
class Ingredient implements ISoup {
  ISoup more;
  String name;
  
  Ingredient(ISoup more, String name) {
    this.more = more;
    this.name = name;
  }
}

//  examples of Soup
class ExamplesSoup { 
  ExamplesSoup() {}
  
  Broth chickenBroth = new Broth("chicken");
  Broth vanillaBroth = new Broth("vanilla");
  Ingredient carrots = new Ingredient(chickenBroth, "carrots");
  Ingredient celery = new Ingredient(carrots, "celery");
  ISoup yummy = new Ingredient(celery, "noodles");
  Ingredient horseradish = new Ingredient(vanillaBroth, "horseradish");
  Ingredient hotDogs = new Ingredient(horseradish, "hot dogs");
  ISoup noThankYou = new Ingredient(hotDogs, "plum sauce");
  
}