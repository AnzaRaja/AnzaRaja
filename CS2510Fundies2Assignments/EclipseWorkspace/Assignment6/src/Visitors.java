import java.util.function.BiFunction;
import java.util.function.Function;
import tester.Tester;

// to represent an arithmetic expression
interface IArith {

  <R> R accept(IArithVisitor<R> visitor);

}

// to represent a Constant
class Const implements IArith {
  double num;

  Const(double num) {
    this.num = num;
  }

  public <R> R accept(IArithVisitor<R> visitor) {
    return visitor.visitConst(this);
  }
}

//to represent a UnaryFormula
class UnaryFormula implements IArith {
  Function<Double, Double> func;
  String name;
  IArith child;

  UnaryFormula(Function<Double, Double> func, String name, IArith child) {
    this.func = func;
    this.name = name;
    this.child = child;
  }

  public <R> R accept(IArithVisitor<R> visitor) {
    return visitor.visitUnaryFormula(this);
  }
}

//to represent a BinaryFormula
class BinaryFormula implements IArith {
  BiFunction<Double, Double, Double> func;
  String name;
  IArith left;
  IArith right;

  BinaryFormula(BiFunction<Double, Double, Double> func, String name, IArith left, IArith right) {
    this.func = func;
    this.name = name;
    this.left = left;
    this.right = right;
  }

  public <R> R accept(IArithVisitor<R> visitor) {
    return visitor.visitBinaryFormula(this);
  }
}

// visits an IArith and evaluates the tree to a Double answer
class EvalVisitor<R> implements IArithVisitor<Double> {

  public Double apply(IArith t) {
    return t.accept(this);
  }

  public Double visitConst(Const c) {
    return c.num;
  }

  public Double visitUnaryFormula(UnaryFormula s) {
    return s.func.apply(s.child.accept(this));
  }

  public Double visitBinaryFormula(BinaryFormula r) {
    return r.func.apply(r.left.accept(this), r.right.accept(this));
  }
}

// visits an IArith and produces a String showing the fully-parenthesized expression 
// in Racket-like prefix notation
class PrintVisitor implements IArithVisitor<String> {

  public String apply(IArith t) {
    return t.accept(this);
  }

  public String visitConst(Const c) {
    return Double.toString(c.num);
  }

  public String visitUnaryFormula(UnaryFormula s) {
    return "(" + s.name + " " + s.child.accept(this) + ")";
  }

  public String visitBinaryFormula(BinaryFormula r) {
    return "(" + r.name + " " + r.left.accept(this) + " " + r.right.accept(this) + ")";
  }
}

// visits an IArith and produces another IArith, where every BinaryFormula in the tree has switched
// its left and right fields
class MirrorVisitor implements IArithVisitor<IArith> {

  public IArith apply(IArith t) {
    return t.accept(this);
  }

  public IArith visitConst(Const c) {
    return new Const(c.num);
  }

  public IArith visitUnaryFormula(UnaryFormula s) {
    return new UnaryFormula(s.func, s.name, apply(s.child));
  }

  public IArith visitBinaryFormula(BinaryFormula r) {
    return new BinaryFormula(r.func, r.name, apply(r.right), apply(r.left));
  }
}

// visits an IArith and produces a Boolean that is true if every constant in the tree is even
class AllEvenVisitor implements IArithVisitor<Boolean> {

  public Boolean apply(IArith t) {
    return t.accept(this);
  }

  public Boolean visitConst(Const c) {
    return c.num % 2 == 0.0;
  }

  public Boolean visitUnaryFormula(UnaryFormula s) {
    return s.child.accept(this);
  }

  public Boolean visitBinaryFormula(BinaryFormula r) {
    return r.left.accept(this) && r.right.accept(this);
  }
}

// binary formula plus
class Plus implements BiFunction<Double, Double, Double> {

  public Double apply(Double t, Double u) {
    return t + u;
  }
}

// binary formula minus
class Minus implements BiFunction<Double, Double, Double> {

  public Double apply(Double t, Double u) {
    return t - u;
  }
}

// binary formula multiply
class Mul implements BiFunction<Double, Double, Double> {

  public Double apply(Double t, Double u) {
    return t * u;
  }
}

// binary formula divide
class Div implements BiFunction<Double, Double, Double> {

  public Double apply(Double t, Double u) {
    if (u > 0.0 || u < 0.0) {
      return t / u;
    }
    else {
      throw new IllegalArgumentException("cannot divide by 0");
    }
  }
}

// unary formula negate
class Neg implements Function<Double, Double> {

  public Double apply(Double t) {
    return -1 * t;
  }
}

// unary formula square
class Sqr implements Function<Double, Double> {

  public Double apply(Double t) {
    return t * t;
  }
}

//representing a visitor that visits an IArith and produces a result of type R
interface IArithVisitor<R> extends Function<IArith, R> {
  R visitConst(Const c);

  R visitUnaryFormula(UnaryFormula s);

  R visitBinaryFormula(BinaryFormula r);
}

class ExamplesVisitor {

  IArith const1 = new Const(3);
  IArith const2 = new Const(10);
  IArith const3 = new Const(18);
  IArith const4 = new Const(14);
  IArith const5 = new Const(17);
  IArith const6 = new Const(26);
  IArith const7 = new Const(16);
  IArith const8 = new Const(1);
  IArith const9 = new Const(32);
  IArith const10 = new Const(4);

  IArith unary1 = new UnaryFormula(new Sqr(), "sqr", this.const1);
  IArith unary2 = new UnaryFormula(new Sqr(), "sqr", this.const2);
  IArith unary3 = new UnaryFormula(new Neg(), "neg", this.const3);
  IArith unary4 = new UnaryFormula(new Neg(), "neg", this.const4);

  IArith binary1 = new BinaryFormula(new Plus(), "plus", this.const1, this.const2);
  IArith unary5 = new UnaryFormula(new Neg(), "neg", this.binary1);

  IArith binary14 = new BinaryFormula(new Div(), "div", this.const9, this.unary3);
  IArith unary6 = new UnaryFormula(new Neg(), "neg", this.binary14);// errors

  IArith binary5 = new BinaryFormula(new Div(), "div", this.unary1, this.const7);
  IArith unary7 = new UnaryFormula(new Neg(), "neg", this.binary5);//

  IArith binary6 = new BinaryFormula(new Div(), "div", this.unary1, this.unary3);
  IArith unary8 = new UnaryFormula(new Neg(), "neg", this.binary6);//

  IArith binary7 = new BinaryFormula(new Div(), "div", this.unary2, this.unary4);
  IArith unary9 = new UnaryFormula(new Neg(), "neg", this.binary7);//

  IArith binary8 = new BinaryFormula(new Div(), "div", this.unary1, this.unary2);
  IArith unary10 = new UnaryFormula(new Neg(), "neg", this.binary8);//

  IArith binary9 = new BinaryFormula(new Div(), "div", this.unary3, this.unary4);
  IArith unary11 = new UnaryFormula(new Sqr(), "sqr", this.binary9);//

  IArith binary2 = new BinaryFormula(new Minus(), "minus", this.const4, this.const3);
  IArith binary3 = new BinaryFormula(new Mul(), "mul", this.const9, this.const1);
  IArith binary4 = new BinaryFormula(new Div(), "div", this.const9, this.unary3);

  IArith binary10 = new BinaryFormula(new Div(), "div", this.unary5, this.const1);// error

  IArith binary11 = new BinaryFormula(new Div(), "div", this.unary7, this.unary8);// error
  IArith binary12 = new BinaryFormula(new Div(), "div", this.unary9, this.unary10);// error
  IArith binary13 = new BinaryFormula(new Div(), "div", this.unary11, this.unary2);// error

  IArith binary15 = new BinaryFormula(new Div(), "div", this.binary11, this.binary2);
  IArith binary16 = new BinaryFormula(new Minus(), "minus", this.binary2, this.binary11);
  IArith binary17 = new BinaryFormula(new Plus(), "plus", this.binary1, this.const2);

  IArith binary18 = new BinaryFormula(new Plus(), "plus", this.unary3, this.unary4);
  IArith binary19 = new BinaryFormula(new Minus(), "minus", this.binary18, this.const1);

  // testing Plus
  boolean testPlus(Tester t) {
    return t.checkExpect(new Plus().apply(3.0, 2.0), 5.0)
        && t.checkExpect(new Plus().apply(5.9, 259.0), 264.9)
        && t.checkExpect(new Plus().apply(-67.0, -12.3), -79.3)
        && t.checkExpect(new Plus().apply(-5.9, 259.0), 253.1)
        && t.checkExpect(new Plus().apply(7.0, -2.0), 5.0);
  }

  // testing Minus
  boolean testMinus(Tester t) {
    return t.checkExpect(new Minus().apply(3.0, 2.0), 1.0)
        && t.checkExpect(new Minus().apply(5.9, 259.0), -253.1)
        && t.checkExpect(new Minus().apply(-67.0, -12.3), -54.7)
        && t.checkExpect(new Minus().apply(-5.9, 259.0), -264.9)
        && t.checkExpect(new Minus().apply(7.0, -2.0), 9.0);
  }

  // testing Multiply
  boolean testMul(Tester t) {
    return t.checkExpect(new Mul().apply(3.0, 2.0), 6.0)
        && t.checkExpect(new Mul().apply(5.9, 259.0), 1528.1000000000001)
        && t.checkExpect(new Mul().apply(-67.0, -12.3), 824.1)
        && t.checkExpect(new Mul().apply(-5.9, 259.0), -1528.1000000000001)
        && t.checkExpect(new Mul().apply(7.0, -2.0), -14.0);
  }

  // testing Divide
  boolean testDiv(Tester t) {
    return t.checkExpect(new Div().apply(3.0, 3.0), 1.0)
        && t.checkExpect(new Div().apply(-5.0, -8.0), 0.625)
        && t.checkExpect(new Div().apply(-5.0, 8.0), -0.625)
        && t.checkExpect(new Div().apply(0.0, -1.5), 0.0)
        && t.checkExpect(new Div().apply(0.0, 3.1), 0.0);
  }

  // testing Negate
  boolean testNeg(Tester t) {
    return t.checkExpect(new Neg().apply(3.0), -3.0)
        && t.checkExpect(new Neg().apply(259.0), -259.0)
        && t.checkExpect(new Neg().apply(-67.2), 67.2) && t.checkExpect(new Neg().apply(5.9), -5.9)
        && t.checkExpect(new Neg().apply(0.0), 0.0);
  }

  // testing Square
  boolean testSqr(Tester t) {
    return t.checkExpect(new Sqr().apply(3.0), 9.0)
        && t.checkExpect(new Sqr().apply(259.0), 67081.0)
        && t.checkExpect(new Sqr().apply(-67.2), 4515.84)
        && t.checkExpect(new Sqr().apply(5.9), 34.81) && t.checkExpect(new Sqr().apply(0.0), 0.0);
  }

  // testing EvalVisitor<R> method
  boolean testEvalVisitor(Tester t) {
    return t.checkExpect(new EvalVisitor<>().apply(this.const1), 3.0)
        && t.checkExpect(new EvalVisitor<>().apply(this.const2), 10.0)
        && t.checkExpect(new EvalVisitor<>().apply(this.const3), 18.0)
        && t.checkExpect(new EvalVisitor<>().apply(this.unary1), 9.0)
        && t.checkExpect(new EvalVisitor<>().apply(this.unary3), -18.0)
        && t.checkExpect(new EvalVisitor<>().apply(this.unary6), 1.7777777777777777)
        && t.checkExpect(new EvalVisitor<>().apply(this.unary7), -0.5625)
        && t.checkExpect(new EvalVisitor<>().apply(this.unary11), 1.6530612244897962)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary3), 96.0)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary4), -1.7777777777777777)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary1), 13.0)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary5), 0.5625)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary6), -0.5)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary7), -7.142857142857143)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary8), 0.09)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary9), 1.2857142857142858)
        && t.checkExpect(new EvalVisitor<>().apply(this.binary13), 0.016530612244897963);
  }

  // testing PrintVisitor method
  boolean testPrintVisitor(Tester t) {
    return t.checkExpect(new PrintVisitor().apply(this.const1), "3.0")
        && t.checkExpect(new PrintVisitor().apply(this.const2), "10.0")
        && t.checkExpect(new PrintVisitor().apply(this.const3), "18.0")
        && t.checkExpect(new PrintVisitor().apply(this.unary1), "(sqr 3.0)")
        && t.checkExpect(new PrintVisitor().apply(this.unary3), "(neg 18.0)")
        && t.checkExpect(new PrintVisitor().apply(this.unary6), "(neg (div 32.0 (neg 18.0)))")
        && t.checkExpect(new PrintVisitor().apply(this.unary7), "(neg (div (sqr 3.0) 16.0))")
        && t.checkExpect(new PrintVisitor().apply(this.unary11),
            "(sqr (div (neg 18.0) (neg 14.0)))")
        && t.checkExpect(new PrintVisitor().apply(this.binary3), "(mul 32.0 3.0)")
        && t.checkExpect(new PrintVisitor().apply(this.binary1), "(plus 3.0 10.0)")
        && t.checkExpect(new PrintVisitor().apply(this.binary5), "(div (sqr 3.0) 16.0)")
        && t.checkExpect(new PrintVisitor().apply(this.binary6), "(div (sqr 3.0) (neg 18.0))")
        && t.checkExpect(new PrintVisitor().apply(this.binary7), "(div (sqr 10.0) (neg 14.0))")
        && t.checkExpect(new PrintVisitor().apply(this.binary8), "(div (sqr 3.0) (sqr 10.0))")
        && t.checkExpect(new PrintVisitor().apply(this.binary9), "(div (neg 18.0) (neg 14.0))")
        && t.checkExpect(new PrintVisitor().apply(this.binary13),
            "(div (sqr (div (neg 18.0) (neg 14.0))) (sqr 10.0))")
        && t.checkExpect(new PrintVisitor().apply(this.binary17), "(plus (plus 3.0 10.0) 10.0)")
        && t.checkExpect(new PrintVisitor().apply(this.binary19),
            "(minus (plus (neg 18.0) (neg 14.0)) 3.0)");
  }

  // testing MirrorVisitor method
  boolean testMirrorVisitor(Tester t) {
    return t.checkExpect(new MirrorVisitor().apply(this.const1), this.const1)
        && t.checkExpect(new MirrorVisitor().apply(this.const2), this.const2)
        && t.checkExpect(new MirrorVisitor().apply(this.const3), this.const3)
        && t.checkExpect(new MirrorVisitor().apply(this.unary1), this.unary1)
        && t.checkExpect(new MirrorVisitor().apply(this.unary3), this.unary3)

        && t.checkExpect(new MirrorVisitor().apply(this.unary6),
            new UnaryFormula(new Neg(), "neg",
                new BinaryFormula(new Div(), "div", this.unary3, this.const9)))

        && t.checkExpect(new MirrorVisitor().apply(this.unary7),
            new UnaryFormula(new Neg(), "neg",
                new BinaryFormula(new Div(), "div", this.const7, this.unary1)))

        && t.checkExpect(new MirrorVisitor().apply(this.unary11),
            new UnaryFormula(new Sqr(), "sqr",
                new BinaryFormula(new Div(), "div", this.unary4, this.unary3)))

        && t.checkExpect(new MirrorVisitor().apply(this.binary3),
            new BinaryFormula(new Mul(), "mul", this.const1, this.const9))
        && t.checkExpect(new MirrorVisitor().apply(this.binary4),
            new BinaryFormula(new Div(), "div", this.unary3, this.const9))
        && t.checkExpect(new MirrorVisitor().apply(this.binary1),
            new BinaryFormula(new Plus(), "plus", this.const2, this.const1))
        && t.checkExpect(new MirrorVisitor().apply(this.binary5),
            new BinaryFormula(new Div(), "div", this.const7, this.unary1))
        && t.checkExpect(new MirrorVisitor().apply(this.binary6),
            new BinaryFormula(new Div(), "div", this.unary3, this.unary1))
        && t.checkExpect(new MirrorVisitor().apply(this.binary7),
            new BinaryFormula(new Div(), "div", this.unary4, this.unary2))
        && t.checkExpect(new MirrorVisitor().apply(this.binary8),
            new BinaryFormula(new Div(), "div", this.unary2, this.unary1))
        && t.checkExpect(new MirrorVisitor().apply(this.binary9),
            new BinaryFormula(new Div(), "div", this.unary4, this.unary3))
        && t.checkExpect(new MirrorVisitor().apply(this.binary13),
            new BinaryFormula(new Div(), "div", this.unary2, new UnaryFormula(new Sqr(), "sqr",
                new BinaryFormula(new Div(), "div", this.unary4, this.unary3))));
  }

  // testing AllEvenVisitor method
  boolean testAllEvenVisitor(Tester t) {
    return t.checkExpect(new AllEvenVisitor().apply(this.const1), false)
        && t.checkExpect(new AllEvenVisitor().apply(this.const2), true)
        && t.checkExpect(new AllEvenVisitor().apply(this.const3), true)
        && t.checkExpect(new AllEvenVisitor().apply(this.unary1), false)
        && t.checkExpect(new AllEvenVisitor().apply(this.unary3), true)
        && t.checkExpect(new AllEvenVisitor().apply(this.unary6), true)
        && t.checkExpect(new AllEvenVisitor().apply(this.unary7), false)
        && t.checkExpect(new AllEvenVisitor().apply(this.unary11), true)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary3), false)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary4), true)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary1), false)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary5), false)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary6), false)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary7), true)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary8), false)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary9), true)
        && t.checkExpect(new AllEvenVisitor().apply(this.binary13), true);
  }

  // test method for illegal argument exception
  boolean testcheckException(Tester t) {
    return t.checkException(new IllegalArgumentException("cannot divide by 0"), new Div(), "apply",
        2.3, 0.0)
        && t.checkException(new IllegalArgumentException("cannot divide by 0"), new Div(), "apply",
            -2.3, 0.0)
        && t.checkException(new IllegalArgumentException("cannot divide by 0"), new Div(), "apply",
            0.01, 0.0);
  }
}
