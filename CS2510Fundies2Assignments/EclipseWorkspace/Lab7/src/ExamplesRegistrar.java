//import tester.Tester;

// to represent a list of courses

import tester.Tester;

interface ILoCourse {

}

// represents an empty list of courses
class MtLoCourse implements ILoCourse {

}

// represents a list of courses with one or more elements
class ConsLoCourse implements ILoCourse {
  String first;
  ILoCourse rest;

  ConsLoCourse(String first, ILoCourse rest) {
    this.first = first;
    this.rest = rest;
  }
}

// to represent a course
class Course {
  String name;
  Instructor prof;
  IStudent students;
  
  Course(String name, Instructor prof, IStudent students) {
    this.name = name;
    this.prof = prof;
    this.students = students;
  }
}

/*
 * // to represent one of instructor or student interface IPerson {
 * 
 * }
 */

// to represent an instructor
class Instructor implements ILoCourse {
  String name;
  ILoCourse courses;

  Instructor(String name, ILoCourse courses) {
    this.name = name;
    this.courses = courses;
  }
}

// to represent a single student or a list of students
interface IStudent {

}

// to represent an empty list of students
class MtLoStudent implements IStudent {

}

//to represent a list of students with one or more elements
class ConsLoStudent implements IStudent {
  Student student;
  IStudent rest;

  ConsLoStudent(Student student, IStudent rest) {
    this.student = student;
    this.rest = rest;
  }
}

// to represent a student
class Student {
  String name;
  int idNum;
  ILoCourse courses;

  Student(String name, int idNum, ILoCourse courses) {
    this.name = name;
    this.idNum = idNum;
    this.courses = courses;
  }
}

class ExamplesRegistrar {

  
  Course course1 = new Course("Course1", this.prof1, this.iLoStu1);
  Course course2 = new Course("Course2", this.prof2, this.iLoStu1);
  Course course3 = new Course("Course3", this.prof3, this.iLoStu1);

  ILoCourse mtLoCourse = new MtLoCourse();
  IStudent mtLoStudent = new MtLoStudent();

  ILoCourse courseList1 = new ConsLoCourse("Environmental Science", mtLoCourse);

  ILoCourse courseList2 = new ConsLoCourse("Calculus 1",
      new ConsLoCourse("Calculus 2", new ConsLoCourse("English Writing", mtLoCourse)));

  ILoCourse courseList3 = new ConsLoCourse("General Biology 1",
      new ConsLoCourse("General Biology 2", new ConsLoCourse("English Writing", mtLoCourse)));

  Student student1 = new Student("Jane", 123456, mtLoCourse);
  Student student2 = new Student("Alicia", 789101, mtLoCourse);
  Student student3 = new Student("Max", 112131, mtLoCourse);
  Student student4 = new Student("Valerie", 415161, mtLoCourse);
  Student student5 = new Student("Hari", 718192, mtLoCourse);
  Student student6 = new Student("Josh", 021222, mtLoCourse);
  Student student7 = new Student("Ashley", 324252, mtLoCourse);
  Student student8 = new Student("Devan", 627282, mtLoCourse);

  Instructor prof1 = new Instructor("Maxwell", mtLoCourse);
  Instructor prof2 = new Instructor("Anna", mtLoCourse);
  Instructor prof3 = new Instructor("James", mtLoCourse);
  Instructor prof4 = new Instructor("Sarah", mtLoCourse);
  Instructor prof5 = new Instructor("Alexander", mtLoCourse);

  IStudent iLoStu1 = new ConsLoStudent(this.student1, new ConsLoStudent(this.student2, this.mtLoStudent));
  IStudent iLoStu2 = new ConsLoStudent(this.student2, new ConsLoStudent(this.student5, this.mtLoStudent));
  IStudent iLoStu3 = new ConsLoStudent(this.student7, new ConsLoStudent(this.student1, 
      new ConsLoStudent(this.student5, this.mtLoStudent)));
  
  // test method for void
  boolean testMerge(Tester t) {
    return t.checkExpect(this.student1.void(this.course1), new Student("Jane", 123456, course1))
        && t.checkExpect(this.student2.void(this.course1), new Student("Alicia", 789101, course1))
        && t.checkExpect(this.student6.void(this.course1), new Student("Josh", 021222, course1));
}
}