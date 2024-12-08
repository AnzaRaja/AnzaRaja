import tester.*;

// Bank Account Examples and Tests
class Examples {
  Account check1;
  Account savings1;

  Examples() { 
    reset(); 
  }

  // Initializes accounts to use for testing with effects.
  // We place inside reset() so we can "reuse" the accounts
  void reset() {

    // Initialize the account examples
    check1 = new Checking(1, 100, "First Checking Account", 20);
    savings1 = new Savings(4, 200, "First Savings Account", 2.5);
  }

  // Tests the exceptions we expect to be thrown when
  //   performing an "illegal" action.
  void testExceptions(Tester t) {
    reset();
    t.checkException("Test for invalid Checking withdraw",
        new RuntimeException("1000 is not available"),
        this.check1,
        "withdraw",
        1000);
  }

  
}
