import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.Predicate;

import tester.Tester;

//represents a generic list
interface IList<T> {
  // filter this list using the given predicate
  IList<T> filter(Predicate<T> pred);

  // map a given function onto every member of this list and return a list of the
  // results
  <U> IList<U> map(Function<T, U> converter);

  // combine the items in this list using the given function
  <U> U fold(BiFunction<T, U, U> converter, U initial);
}

//represents a generic empty list
class MtList<T> implements IList<T> {

  MtList() {
  }

  /*- TEMPLATE
  FIELDS:
  
  METHODS
  ... this.filter(Predicate<T> pred) ...                   -- IList<T>
  ... this.map(Function<T, U> converter)...                -- <U> IList<U>
  ... fold(BiFunction<T, U, U> converter, U initial) ...   -- <U> U fold
  */

  // filter this empty list using the given predicate
  public IList<T> filter(Predicate<T> pred) {
    return new MtList<T>();
  }

  // map a given function onto every member of this list and return a list of the
  // results
  public <U> IList<U> map(Function<T, U> converter) {
    return new MtList<U>();
  }

  // combine the items in this list using the given function
  public <U> U fold(BiFunction<T, U, U> converter, U initial) {
    return initial;
  }
}

//represents a generic non-empty list
class ConsList<T> implements IList<T> {
  T first;
  IList<T> rest;

  ConsList(T first, IList<T> rest) {
    this.first = first;
    this.rest = rest;
  }

  /*- TEMPLATE
  FIELDS:
  
  METHODS
  ... this.filter(Predicate<T> pred) ...                   -- IList<T>
  ... this.map(Function<T, U> converter)...                -- <U> IList<U>
  ... fold(BiFunction<T, U, U> converter, U initial) ...   -- <U> U fold
  */

  // filter this non-empty list using the given predicate
  public IList<T> filter(Predicate<T> pred) {
    if (pred.test(this.first)) {
      return new ConsList<T>(this.first, this.rest.filter(pred));
    }
    else {
      return this.rest.filter(pred);
    }
  }

  // map a given function onto every member of this list and return a list of the
  // results
  public <U> IList<U> map(Function<T, U> converter) {
    return new ConsList<U>(converter.apply(this.first), this.rest.map(converter));
  }

  // combine the items in this list using the given function
  public <U> U fold(BiFunction<T, U, U> converter, U initial) {
    return converter.apply(this.first, this.rest.fold(converter, initial));
  }
}

/*
 * // ormap public boolean ormap(Predicate<T> pred) { return
 * pred.test(this.first) || this.rest.ormap(pred); }
 */

// returns list with items that begin with the given letter
class beginsWith implements Predicate<String> {
  String s;

  beginsWith(String s) {
    this.s = s;
  }

  // does the given string begin with the given letter
  public boolean test(String t) {
    return t.substring(0, 1).equals(s);
  }
}

class ExamplesLists {

  ExamplesLists() {
  }

  IList<String> mtList = new MtList<String>();
  IList<String> list1 = new ConsList<String>("January",
      new ConsList<String>("February", new ConsList<String>("March", this.mtList)));
  IList<String> list2 = new ConsList<String>("January",
      new ConsList<String>("February", new ConsList<String>("March", new ConsList<String>("April",
          new ConsList<String>("May", new ConsList<String>("June", this.mtList))))));
  IList<String> list3 = new ConsList<String>("January",
      new ConsList<String>("February",
          new ConsList<String>("March",
              new ConsList<String>("April",
                  new ConsList<String>("May", new ConsList<String>("June",
                      new ConsList<String>("July",
                          new ConsList<String>("August",
                              new ConsList<String>("September",
                                  new ConsList<String>("October", new ConsList<String>("November",
                                      new ConsList<String>("December", this.mtList))))))))))));

  // returns a list that beginsWith the letter J
  boolean testBeginsWith(Tester t) {
    return t.checkExpect(mtList.filter(new beginsWith("J")), this.mtList)
        && t.checkExpect(list1.filter(new beginsWith("J")),
        new ConsList<String>("January", this.mtList))
        && t.checkExpect(list2.filter(new beginsWith("J")),
            new ConsList<String>("January", new ConsList<String>("June", this.mtList)))
        && t.checkExpect(list3.filter(new beginsWith("J")), new ConsList<String>("January",
            new ConsList<String>("June", new ConsList<String>("July", this.mtList))));
  }

}
