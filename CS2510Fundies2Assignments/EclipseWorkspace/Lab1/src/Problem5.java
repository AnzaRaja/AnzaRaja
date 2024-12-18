
// to represent an ancestor tree
interface IAT { }

// to represent an unknown member of an ancestor tree
class Unknown implements IAT {
  Unknown() {
  }

  // Will return false if name is not found
  public boolean findName(String name) {
    return false;
  }
}

// to represent a person with the person's ancestor tree
class Person implements IAT {
  String name;
  IAT mom;
  IAT dad;

  Person(String name, IAT mom, IAT dad) {
    this.name = name;
    this.mom = mom;
    this.dad = dad;
  }

  // Will return true if given name matches Person's name or will traverse mom and
  // dad
  public boolean findName(String name) {
    return this.name.equals(name) || this.mom.findName(name) || this.dad.findName(name);
  }
}

// examples and tests for the class hierarchy that represents 
// ancestor trees

import tester.Tester;

class ExamplesAncestors {
  ExamplesAncestors() {
  }

  IAT unknown = new Unknown();
  IAT mary = new Person("Mary", this.unknown, this.unknown);
  IAT robert = new Person("Robert", this.unknown, this.unknown);
  IAT john = new Person("John", this.unknown, this.unknown);

  IAT jane = new Person("Jane", this.mary, this.robert);

  IAT dan = new Person("Dan", this.jane, this.john);

  boolean testFindName(Tester t) {
    return t.checkExpect(unknown.findName("maggie"), false)
        && t.checkExpect(unknown.findName(""), false) && t.checkExpect(mary.findName("Mary"), true)
        && t.checkExpect(dan.findName("Jane"), true) && t.checkExpect("Dan", false);

  }
}