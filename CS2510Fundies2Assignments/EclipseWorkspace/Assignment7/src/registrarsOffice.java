import java.util.function.Predicate;

import tester.Tester;

// represents a course
class Course {
  String name;
  Instructor prof;
  IList<Student> students;

  Course(String name, Instructor prof) {
    this.name = name;
    this.prof = prof;
    this.students = new MtList<Student>();
    prof.courses = new ConsList<Course>(this, prof.courses);
  }

  // adds a Student in the given list of students for this Course
  void enrollHelp(Student s) {
    this.students = new ConsList<Student>(s, this.students);
  }

  // is this student in the list of students
  boolean studentInCourse(Student s) {
    return this.students.containsComparator(new ContainsStudent(), s);
  }
}

// represents an instructor
class Instructor {
  String name;
  IList<Course> courses;

  Instructor(String name) {
    this.name = name;
    this.courses = new MtList<Course>();
  }

  // determines whether the given Student is in more than one of this Instructor’s
  // Courses
  boolean dejavu(Student s) {
    return this.courses.dejavuHelper(new StudentCoursePred(s), 0);
  }
}

// represents a student
class Student {
  String name;
  int id;
  IList<Course> courses;

  Student(String name, int id) {
    this.name = name;
    this.id = id;
    this.courses = new MtList<Course>();
  }

  // enrolls a Student in the given Course
  void enroll(Course c) {
    this.courses = new ConsList<Course>(c, this.courses);
    c.enrollHelp(this);
  }

  // determines whether the given Student is in any of the same classes as this
  // Student
  boolean classmates(Student s) {
    return this.courses.classmatesHelper(new StudentCoursePred(s), 1);
  }

  // is this student the same as given student
  boolean sameStudent(Student s) {
    return this.id == s.id;
  }

}

// to represent an IList
interface IList<T> {

  // generic contains method for predicate
  boolean contains(Predicate<T> pred);

  // does this student appear in the course list
  boolean classmatesHelper(Predicate<T> t, int num);

  // generic contains method for comparator
  boolean containsComparator(IComparator<T> comp, T t);

  // does a student appear more than once in this instructors list of courses
  boolean dejavuHelper(Predicate<T> t, int num);

}

// to represent an empty generic list
class MtList<T> implements IList<T> {
  MtList() {
  }

  // generic contains method for predicate
  public boolean contains(Predicate<T> pred) {
    return false;
  }

  // generic contains method for comparator
  public boolean containsComparator(IComparator<T> comp, T t) {
    return false;
  }

  // does this student appear in the course list
  public boolean classmatesHelper(Predicate<T> t, int num) {
    return (num <= 0);
  }

  // does a student appear more than once in this instructors list of courses
  public boolean dejavuHelper(Predicate<T> t, int num) {
    return (num >= 2);
  }

}

// to represent a Cons generic list
class ConsList<T> implements IList<T> {
  T first;
  IList<T> rest;

  ConsList(T first, IList<T> rest) {
    this.first = first;
    this.rest = rest;
  }

  // generic contains method for predicate
  public boolean contains(Predicate<T> pred) {
    if (pred.test(this.first)) {
      return true;
    }
    else {
      return this.rest.contains(pred);
    }
  }

  // generic contains method for comparator
  public boolean containsComparator(IComparator<T> comp, T t) {
    return comp.compare2(this.first, t) || this.rest.containsComparator(comp, t);
  }

  // does this student appear in the course list
  public boolean classmatesHelper(Predicate<T> t, int num) {
    if (t.test(this.first)) {
      return this.rest.classmatesHelper(t, num - 1);
    }
    else {
      return this.rest.classmatesHelper(t, num);
    }
  }

  // does a student appear more than once in this instructors list of courses
  public boolean dejavuHelper(Predicate<T> t, int num) {
    if (t.test(this.first)) {
      return this.rest.dejavuHelper(t, num + 1);
    }
    else {
      return this.rest.dejavuHelper(t, num);
    }
  }

}

/*// to represent an IPred of type <T>
interface IPred<T> {

  // apply method
  boolean apply(T t);
}*/

// to represent an IComparotor of type <T>
interface IComparator<T> {

  // compare two items
  boolean compare2(T t1, T t2);
}

// is this the same student
class ContainsStudent implements IComparator<Student> {

  // checks if this student is in the list of students of a course
  public boolean compare2(Student stu1, Student stu2) {
    return stu1.sameStudent(stu2);
  }
}

// to represent a StudentCoursePred
class StudentCoursePred implements Predicate<Course> {
  Student student;

  StudentCoursePred(Student s) {
    this.student = s;
  }

  // is this student in the course
  public boolean test(Course c) {
    return c.studentInCourse(student);
  }

}

//examples for the class that represents courses
class ExamplesCourse {

  Student jane = new Student("Jane", 123456);
  Student alicia = new Student("Alicia", 789101);
  Student max = new Student("Max", 112131);
  Student valerie = new Student("Valerie", 415161);
  Student hari = new Student("Hari", 718192);
  Student josh = new Student("Josh", 021222);
  Student ashley = new Student("Ashley", 324252);
  Student devan = new Student("Devan", 627282);
  Student alex = new Student("Alex", 930313);
  Student will = new Student("Will", 233343);

  Instructor ferd = new Instructor("Ferdinand");
  Instructor lerner = new Instructor("Lerner");
  Instructor park = new Instructor("Park");
  Instructor razzaq = new Instructor("Razzaq");
  Instructor xiao = new Instructor("Xiao");
  Instructor smith = new Instructor("Smith");
  Instructor miller = new Instructor("Miller");

  // empty list of course and student
  IList<Course> mtCourse = new MtList<Course>();
  IList<Student> mtStudent = new MtList<Student>();

  IList<Student> csStudents = new ConsList<Student>(this.jane,
      new ConsList<Student>(this.alicia,
          new ConsList<Student>(this.max, new ConsList<Student>(this.valerie,
              new ConsList<Student>(this.hari, new MtList<Student>())))));

  IList<Student> starterCsStudents = new ConsList<Student>(this.devan,
      new ConsList<Student>(this.alex, new ConsList<Student>(this.jane, new MtList<Student>())));

  IList<Student> businessStudents = new ConsList<Student>(this.josh,
      new ConsList<Student>(this.ashley, new MtList<Student>()));

  IList<Student> busStudents = new ConsList<Student>(this.will, new MtList<Student>());

  // cs classes
  Course fundies1 = new Course("Fundies1", this.razzaq);
  Course oodRaz = new Course("Object Oriented Design", this.razzaq);
  Course oodPark = new Course("Object Oriented Design", this.park);
  Course fundies2 = new Course("Fundies2", this.lerner);
  Course algo = new Course("Algorithms", this.park);
  Course digitalDesign = new Course("Digital design", this.ferd);

  IList<Course> csClasses = new ConsList<Course>(this.fundies2,
      new ConsList<Course>(this.algo, new ConsList<Course>(this.digitalDesign, this.mtCourse)));

  IList<Course> starterCsClasses = new ConsList<Course>(this.fundies1,
      new ConsList<Course>(this.oodRaz, this.mtCourse));

  // business classes
  Course acct1201 = new Course("Financial Accounting", this.xiao);
  Course acct1203 = new Course("Financial Accounting 2", this.xiao);

  Course intb = new Course("International Business", this.smith);
  Course busCalc = new Course("Business Calc", this.miller);

  IList<Course> businessClasses = new ConsList<Course>(this.acct1201,
      new ConsList<Course>(this.acct1203, new ConsList<Course>(this.intb, this.mtCourse)));
  IList<Course> busClass = new ConsList<Course>(this.busCalc, this.mtCourse);

  IList<Course> businessClassesXiao = new ConsList<Course>(this.acct1201,
      new ConsList<Course>(this.acct1203, this.mtCourse));

  IList<Course> businessClassesSmith = new ConsList<Course>(this.acct1201,
      new ConsList<Course>(this.acct1203, new ConsList<Course>(this.intb, this.mtCourse)));

  // EFFECT: Sets up the initial conditions for our tests, by re-initializing
  void initTestConditions() {
    // Jane
    this.jane.enroll(this.fundies1);
    this.jane.enroll(this.oodRaz);
    this.jane.enroll(this.digitalDesign);
    this.jane.enroll(this.acct1203);
    // Alicia
    this.alicia.enroll(this.fundies1);
    this.alicia.enroll(this.oodRaz);
    this.alicia.enroll(this.digitalDesign);
    this.alicia.enroll(this.acct1203);
    // Max
    this.max.enroll(this.fundies1);
    this.max.enroll(this.oodPark);
    this.max.enroll(this.digitalDesign);
    this.max.enroll(this.acct1201);
    // Valerie
    this.valerie.enroll(this.fundies1);
    this.valerie.enroll(this.oodRaz);
    this.valerie.enroll(this.digitalDesign);
    this.valerie.enroll(this.acct1203);
    // Hari
    this.hari.enroll(this.fundies1);
    this.hari.enroll(this.oodPark);
    this.hari.enroll(this.digitalDesign);
    this.hari.enroll(this.busCalc);
    // Josh
    this.josh.enroll(this.fundies2);
    this.josh.enroll(this.oodRaz);
    this.josh.enroll(this.algo);
    this.josh.enroll(this.intb);
    // Ashley
    this.ashley.enroll(this.fundies2);
    this.ashley.enroll(this.oodPark);
    this.ashley.enroll(this.algo);
    this.ashley.enroll(this.intb);
    // Devan
    this.devan.enroll(this.acct1201);
    this.devan.enroll(this.acct1203);
    this.devan.enroll(this.algo);
    this.devan.enroll(this.intb);
    // Alex
    this.alex.enroll(this.acct1201);
    this.alex.enroll(this.acct1203);
    this.alex.enroll(this.fundies1);
    this.alex.enroll(this.oodRaz);
  }

  // tests for classmates
  boolean testClassmates(Tester t) {
    this.initTestConditions();
    return t.checkExpect(this.jane.classmates(this.alicia), true)
        && t.checkExpect(this.jane.classmates(this.max), true)
        && t.checkExpect(this.ashley.classmates(this.josh), true)
        && t.checkExpect(this.ashley.classmates(this.jane), false)
        && t.checkExpect(this.josh.classmates(this.hari), false)
        && t.checkExpect(this.josh.classmates(this.max), false)
        && t.checkExpect(this.valerie.classmates(this.ashley), false)
        && t.checkExpect(this.valerie.classmates(this.devan), true)
        && t.checkExpect(this.alex.classmates(this.josh), true);
  }

  // tests for dejavu
  boolean testDejavu(Tester t) {
    this.initTestConditions();
    return t.checkExpect(this.park.dejavu(this.ashley), true)
        && t.checkExpect(this.xiao.dejavu(this.devan), true)
        && t.checkExpect(this.xiao.dejavu(this.alex), true)
        && t.checkExpect(this.razzaq.dejavu(this.alex), true)
        && t.checkExpect(this.razzaq.dejavu(this.jane), true)
        && t.checkExpect(this.lerner.dejavu(this.ashley), false)
        && t.checkExpect(this.xiao.dejavu(this.jane), false)
        && t.checkExpect(this.park.dejavu(this.devan), false);
  }
}
