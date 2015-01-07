package lab1;
/*   TwoPlusTwo 

A pretty simple Java program.


Compile:  javac TwoPlusTwo.java
Run:      java TwoPlusTwo

Notes:
- See the Readme.txt file in this directory.
- See the Formatter class for details on the printf method.
  (New to java J2SE 5.0)
*/


public class TwoPlusTwoRewrite {    // define the class (subclass of Object class)

	// one method, main, which is where the program starts

	public static void main(String [] args)
	{
		String title = "Here is a title"; 
		String subTitle = "subtitle";
		String fullTitle = title + ": " + subTitle;
		int a = 3;		// define and initialize
		int b = 3;
		int c;          // define only

		double da = 4.0;
		double db = 4.0;
		double dc;
		double dd;

		c = a + b;      // add and assign (store in) to c

		
		// a couple of print methods
		// see the java Formatter API (or any C manual!)
		// for information about formatting rules for the printf.
		// the \n means 'carriage return' (newline, left side)
		
		System.out.printf("%s \n", title);
		System.out.printf("%s \n", fullTitle);
		System.out.println( "3+ 3 = " + c );
		System.out.printf( "\na=%d b=%d -> c=%d.\n\n", a, b, c );

		// repeat for the double variables
		dc = da + db;
		dd = da/dc;
		System.out.println( "4.0 + 4.0 = " + dc );
		System.out.printf( "\nda=%.2f db=%.2f -> dc=%6.3f \n\n", da, db, dc );
		System.out.println( da + "/" + dc + "="+ dd);
		
		// first define a float variable, assign it a value.
		// note the (float) to "cast" the decimal constant
		// (which has a default type of double!)
		float fb = (float) 3.6;
		float roundFB = Math.round(fb);

		// A. we combine different types, but it converts "up" to double
		//dc = a + fb;
		//System.out.printf( "\n a=%d fb=%.2f -> dc=%6.3f \n\n", a, fb, dc );

		// B. now try to convert "down" to int...
		// c = a + fb;
		// System.out.printf( "\n a=%d fb=%.2f -> c=%d \n\n", a, fb, c );
		
		System.out.println( "round("+ fb + ") = " + roundFB);
		
	}

}
