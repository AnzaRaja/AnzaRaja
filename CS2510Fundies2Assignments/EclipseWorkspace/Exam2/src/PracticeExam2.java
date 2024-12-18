import java.util.ArrayList;
import java.util.Arrays;
import java.util.NoSuchElementException;
import java.util.function.Predicate;

import tester.Tester;

//checks if source contains a sub-sequence of the integers in sequence. The 
//sub-sequence should contain the same numbers as sequence in the same order.
//may assume that neither list is null.
boolean containsSequence(ArrayList<Integer>source,ArrayList<Integer>sequence){if(sequence.size()>source.size()){return false;}for(int i=0;i<=source.size();i++){boolean isSequence=true;

for(int j=0;j<=sequence.size();j++){if(!(source.get(i+j)==sequence.get(j))&&isSequence==true){isSequence=false;}}if(isSequence){return true;}}return false;}

class Deque<T> {
  Sentinel<T> header;

// Returns the number of items in this Deque (excluding the sentinel) int size();
// EFFECT: inserts the given value at the front of the Deque
  void addToHead(T value) {
  }

// EFFECT: inserts the given value at the back of the Deque
  void addToTail(T value) {
  }

// Returns the current first item of the Deque
// EFFECT: removes the current first item of the Deque
  T removeFromHead() {
    return null;
  }

// Returns the current last item of the Deque
// EFFECT: removes the current last item of the Deque
  T removeFromTail() {
    return null;
  }

// In Deque<T>
//append all the items of the given Deque onto the current 
//one and remove the items from that given Deque
  void addAll(Deque<T> that) {
    int size = that.size();

    for (int i = 0; i < size; i++) {
      this.addToTail(that.removeFromHead());
    }
  }
}

class ANode<T> {
  ANode<T> next;
  ANode<T> prev;
}

class Sentinel<T> extends ANode<T> {

}

class Node<T> extends ANode<T> {
  T data;
}

//Produces a sequence of values of type T, one at a time
interface Iterator<T> {
//Does this sequence have at least one more value? 
  boolean hasNext() {
    
  }

//Get the next value in this sequence
//EFFECT: Advance the iterator to the subsequent value 
  T next() {
    
  }
}

//an Iterator that is given another Iterator when 
//constructed and iterates over every other
// element produced by the given iterator
class EveryOtherIter<T> implements Iterator<T> {
  Iterator<T> iter;

  EveryOtherIter(Iterator<T> iter) {
    this.iter = iter;
  }

  public boolean hasNext() {
    this.iter.hasNext();
  }

  public T next() {
    if (!hasNext()) {
      throw new NoSuchElementException("No more items");
    }
    // locally store the next element to return
    T curr = this.iter.next();
    // set up the next element(consumes this element)
    if (this.hasNext()) { // wrapper
      this.iter.next();
    }
    // return the locally stored element
    return curr;
  }
}

class ExamplesArrayUtil {
  ArrayList<Integer> oneThruFour = new ArrayList<>(Arrays.asList(1, 2, 3, 4));
  ArrayList<Integer> example1 = new ArrayList<>(Arrays.asList(11, 2, 6, 4, 10, 7));
  ArrayList<Integer> example2 = new ArrayList<>(Arrays.asList(9, 8, 7, 6, 5));
  ArrayList<Integer> example3 = new ArrayList<>(Arrays.asList(1, 3, 2, 1, 2));
  ArrayList<String> str1 = new ArrayList<>(Arrays.asList("hi", "bye", "no", "yes", "fun"));
  ArrayList<String> str2 = new ArrayList<>(Arrays.asList("pink", "cat", "dog", "fly", "run"));
  ArrayList<ArrayList<String>> str3 = new ArrayList<>(Arrays.asList(str1, str2));

  void testEveryOtherIter() {
    Iterator<Integer> iter = this.oneThruFour.iterator();
    EveryOtherIter<Integer> i = new EveryOtherIter<Integer>(iter);
    t.checkExpect(i.hasNext(), true);
    t.checkExpect(i.next(), 1);
    t.checkExpect(i.hasNext(), true);
    t.checkExpect(i.next(), 3);
    t.checkExpect(i.hasNext(), false);
  }

  void testEveryNthIter() {
    EveryNthIter<Integer> i = new EveryNthIter<Integer>(this.oneThruFour, 2);
    t.checkExpect(i.hasNext(), true);
    t.checkExpect(i.next(), 1);
    t.checkExpect(i.hasNext(), true);
    t.checkExpect(i.next(), 3);
    t.checkExpect(i.hasNext(), false);
  }
}

class EveryNthIter<T> implements Iterator<T> {
  Iterable<T> iter;
  int n;

  EveryNthIter(Iterable<T> iterable, int n) {
    this.iter = iterable.iterator();
    this.n = n;
  }

  public boolean hasNext() {
    this.iter.hasNext();
  }

  public T next() {
    if (!hasNext()) {
      throw new NoSuchElementException("No more items");
    }
    // locally store the next element to return
    T curr = this.iter.next();
    // set up the next element(consumes this element)
    for (int i = 1; i < n && this.hasNext(); i++) {
      this.iter.next();
    }
    // return the locally stored element
    return curr;
  }
}

//implement an Iterator for an ArrayList
class ArrayListIterator<T> implements Iterator<T> {
  // the list of items that this iterator iterates over
  ArrayList<T> items;
  // the index of the next item to be returned
  int nextIdx;

  // Construct an iterator for a given ArrayList
  ArrayListIterator(ArrayList<T> items) {
    this.items = items;
    this.nextIdx = 0;
  }

  public boolean hasNext() {
    return this.nextIdx < this.items.size();
  }

  public T next() {
    if (!this.hasNext()) {
      throw new NoSuchElementException("there are no more items!");
    }
    T answer = this.items.get(this.nextIdx);
    this.nextIdx = this.nextIdx + 1;
    return answer;
  }

  public void remove() {
    throw new UnsupportedOperationException("Don't do this!");
  }
}

//implement an Iterator for an IList
class IListIterator<T> implements Iterator<T> {
  IList<T> items;

  IListIterator(IList<T> items) {
    this.items = items;
  }

  public boolean hasNext() {
    return this.items.isCons();
  }

  public T next() {
    if (!this.hasNext()) {
      throw new NoSuchElementException("there are no more items!");
    }
    ConsList<T> itemsAsCons = this.items.asCons();
    T answer = itemsAsCons.first;
    this.items = itemsAsCons.rest;
    return answer;
  }

  public void remove() {
    throw new UnsupportedOperationException("Don't do this!");
  }
}

//Higher-order Iterators
//Represents the subsequence of the first, third, fifth, etc. items 
//from a given sequence
class EveryOtherIter<T> implements Iterator<T> {
  Iterator<T> source;

  EveryOtherIter(Iterator<T> source) {
    this.source = source;
  }

  public boolean hasNext() {
    // this sequence has a next item if the source does
    return this.source.hasNext();
  }

public T next() {
 if (!this.hasNext()) {
   throw new NoSuchElementException("there are no more items!");
 }// gets the answer, and advances the source
 T answer = this.source.next(); 
 // We need to have the source "skip" the next value
 if (this.source.hasNext() {
   this.source.next(); // get the next value and ignore it
 }return answer;

}

  public void remove() {
    // We can remove an item if our source can remove the item
    this.source.remove(); // so just delegate to the source
  }

}

//product of every integer in the list but the number at the index
  ArrayList<Integer> productOfEverythingExcept(ArrayList<Integer> input) {
    ArrayList<Integer> answer = new ArrayList<>();

    ArrayList<Integer> forward = new ArrayList<>();
    ArrayList<Integer> backward = new ArrayList<>();

    int productSoFar = 1;

    for (int fr = 0; fr < input.size(); fr++) {
      forward.add(productSoFar);

      productSoFar *= input.get(fr);
    }
    for (int bk = input.size() - 1; bk >= 0; bk--) {
      backward.add(0, productSoFar);

      productSoFar *= input.get(bk);
    }
    int product = 1;
    for (int i = 0; i < input.size(); i++) {
      product = forward.get(i) * backward.get(i);
      answer.add(product);
    }
    return answer;
  }
}

class limitPred<T> implements Predicate<T> {
  ArrayList<Predicate<T>> predicates;
  int limit;

  limitPred(ArrayList<Predicate<T>> predicates, int limit) {
    this.predicates = predicates;
    this.limit = limit;
  }

 //Design a class that implements the Predicate<T> interface 
 //from java.util.function. This class’s constructor takes in 
 //anArrayList<Predicate<T>> and an Integer limit. Its test 
 //method returns true only if the amount of predicates in 
 //the list that return true is above the limit value.
  public boolean test(T t) {
    int counter = 0;

    for (Predicate<T> pred : predicates) {
      if (pred.test(t)) {
        counter += 1;
      }
    }
    return counter > limit;
  }
}

class ArrayUtil {
  public void removeThese(ArrayList<T> list, int a, int b) {
    if (!(a <= b) && !(a == 0)) {
      throw new IllegalArgumentException("Invalid range");
    }
    for(int i = b; i >= a; i--) {
      list.remove(i);
    }
  }
}
