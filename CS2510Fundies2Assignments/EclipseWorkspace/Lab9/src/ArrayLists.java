import java.util.ArrayList;
import java.util.Iterator;
import java.util.function.Predicate;

import tester.Tester;

// Utils class
class Utils {

  // produce a new ArrayList<T> containing all the items of the given list that
  // pass the predicate
  <T> ArrayList<T> filter(ArrayList<T> arr, Predicate<T> pred) {
    ArrayList<T> result = new ArrayList<>();

    for (T item : arr) {
      if (pred.test(item)) {
        result.add(item);
      }
    }
    return result;
  }

  // keeps all of the elements filter does not (results that are false)
  <T> ArrayList<T> filterNot(ArrayList<T> arr, Predicate<T> pred) {
    ArrayList<T> result = new ArrayList<>();

    for (T item : arr) {
      if (pred.test(item) == false) {
        result.add(item);
      }
    }
    return result;
  }

  // filters the given list according to the given boolean
  <T> ArrayList<T> customFilter(ArrayList<T> arr, Predicate<T> pred, boolean keepPassing) {
    ArrayList<T> result = new ArrayList<>();

    for (T item : arr) {
      if (pred.test(item) == keepPassing) {
        result.add(item);
      }
    }
    return result;
  }

  // modifies the given list to remove everything that fails the predicate
  <T> void removeFailing(ArrayList<T> arr, Predicate<T> pred) {
    Iterator<T> iterator = arr.iterator();

    while (iterator.hasNext()) {
      T item = iterator.next();
      if (!pred.test(item)) {
        iterator.remove();
      }
    }
  }

  // modifies the given list to remove everything that passes the predicate
  <T> void removePassing(ArrayList<T> arr, Predicate<T> pred) {
    Iterator<T> iterator = arr.iterator();

    while (iterator.hasNext()) {
      T item = iterator.next();
      if (pred.test(item)) {
        iterator.remove();
      }
    }
  }

  // modifies the given list to remove everything that passes the predicate
  <T> void customRemove(ArrayList<T> arr, Predicate<T> pred, boolean keepPassing) {
    Iterator<T> iterator = arr.iterator();

    while (iterator.hasNext()) {
      T item = iterator.next();
      if (pred.test(item) == keepPassing) {
        iterator.remove();
      }
    }
  }
  
  // Define a predicate to filter even numbers
  Predicate<Integer> isEven = num -> num % 2 == 0;
}

// Examples class
class ExamplesArray {
  
  void testFilter(Tester t) {
    ArrayList<Integer> numbers = new ArrayList<Integer>();
    numbers.add(1);
    numbers.add(2);
    numbers.add(3);
    numbers.add(4);
    numbers.add(5);
    numbers.add(6);
    numbers.add(7);
    numbers.add(8);
    numbers.add(9);
    numbers.add(10);
    t.checkExpect(filter(numbers, isEven);
    t.checkExpect(filter(numbers, isOdd);
    t.checkExpect(filterNot(numbers, isEven, false);
    t.checkExpect(filterNot(numbers, isOdd, false);
  }
  
}
