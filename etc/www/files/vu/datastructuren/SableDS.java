/*

SableDS

http://www.cs.vu.nl/~mvermaat/things/vu/ds2003.xhtml

SableDS is a small interpreter for a simple mathematical language. The
language provides elements and collections datatypes and some basic
operations on collections.

To interpret commands stored in a file, start SableDS like this:
$ java SableDS filename

To print this text, start SableDS with the -info option:
$ java SableDS -info

Example of a source file:

  a = {1, 2, 3}
  b = {2, 3, 4}
  ? a + b
  / comment

Parsing code of SableDS was generated with the use of SableCC, a very
cool parser generator for Java. More information on SableCC can be
found here: http://www.sablecc.org

Supported datatypes:
* Element                   : string of digits
* Collection of elements    : {element1, element2, ..., elementn}

Supported operations:
* Union                 : collection1 + collection2
* Intersection          : collection1 * collection2
* Difference            : collection1 - collection2
* Symmetric difference  : collectino1 | collection2

Supported statements:
* Assignment            : myvar = expression
* Print expression      : ? expression
* Comment               : / some text

Parentheses are supported to override standard precedence of operators.


All sourcecode in this project written by me, Martijn Vermaat, is
licensed under the GNU General Public License. Please refer to SableCC
licensing documentation concerning the SableCC generated Java code.

Some Java helper classes were written by Laurens Bronwasser and me
for the 'Datastructuren' course 2003 at the Vrije Universiteit. With
the permission of Laurens, that code is also licensed under the GNU
General Public License.

*/


import sableds.analysis.*;
import sableds.parser.*;
import sableds.lexer.*;
import sableds.node.*;
import java.io.*;
import java.util.*;


public class SableDS extends DepthFirstAdapter {


    public static final String AUTHOR     = "Martijn Vermaat (mvermaat@cs.vu.nl)";
    public static final String VERSION    = "0.1";
    public static final String BUILD_DATE = "2003/11/26";

    public static final char PRINT_SEPARATOR = ' ';


    private Map sets;
    private State state;


    private Set getSet(Node node) {

        return (Set) sets.get(node);

    }


    private void setSet(Node node, Set set) {

        sets.put(node, set);

    }


    public void outAAssignment(AAssignment node) {

        String s = node.getIdentifier().getText();
        Identifier identifier = new Identifier(s.charAt(0));

        for (int i=1; i<s.length(); i++) {
            identifier.addChar(s.charAt(i));
        }

        state.put(identifier, getSet(node.getExpression()));

    }


    public void outAPstatement(APstatement node) {

        Set set = getSet(node.getExpression());

        if (set != null) {

            Set copy = (Set) set.clone();

            if (!copy.isEmpty()) {
                System.out.print(((NaturalNumber)copy.remove()).getAll());
                while (!copy.isEmpty()) {
                    System.out.print(PRINT_SEPARATOR);
                    System.out.print(((NaturalNumber)copy.remove()).getAll());
                }
            }
            System.out.println();

        } else {

            throw new Error("Expression was null in outAPstatement()");

        }

    }


    public void outAUnionExpression(AUnionExpression node) {

        setSet(node, Set.union(getSet(node.getTerm()), getSet(node.getExpression())));

    }


    public void outADiffExpression(ADiffExpression node) {

        setSet(node, Set.difference(getSet(node.getTerm()), getSet(node.getExpression())));

    }


    public void outASymdiffExpression(ASymdiffExpression node) {

        setSet(node, Set.symmetricDifference(getSet(node.getTerm()), getSet(node.getExpression())));

    }


    public void outATermExpression(ATermExpression node) {

        setSet(node, getSet(node.getTerm()));

    }


    public void outAIsectionTerm(AIsectionTerm node) {

        setSet(node, Set.crossSection(getSet(node.getFactor()), getSet(node.getTerm())));

    }


    public void outAFactorTerm(AFactorTerm node) {

        setSet(node, getSet(node.getFactor()));

    }


    public void outAIdentifierFactor(AIdentifierFactor node) {

        String s = node.getIdentifier().getText();
        Identifier identifier = new Identifier(s.charAt(0));

        for (int i=1; i<s.length(); i++) {
            identifier.addChar(s.charAt(i));
        }

        Set set = state.get(identifier);

        if (set != null) {

            setSet(node, set);

        } else {

            throw new RuntimeException("Identifier has not been defined: " + s);

        }

    }


    public void outAGroupingFactor(AGroupingFactor node) {

        setSet(node, getSet(node.getComplexfactor()));

    }


    public void outASetFactor(ASetFactor node) {

        setSet(node, getSet(node.getSet()));

    }


    public void outAComplexfactor(AComplexfactor node) {

        setSet(node, getSet(node.getExpression()));

    }


    public void outAFilledSet(AFilledSet node) {

        setSet(node, getSet(node.getNumbers()));

    }


    public void outAEmptySet(AEmptySet node) {

        setSet(node, new Set());

    }


    public void outANumberNumbers(ANumberNumbers node) {

        String s = node.getNumber().getText();
        NaturalNumber number = new NaturalNumber();

        for (int i=0; i<s.length(); i++) {
            number.addChar(s.charAt(i));
        }

        setSet(node, new Set().add(number));

    }


    public void outANumbersNumbers(ANumbersNumbers node) {

        String s = node.getNumber().getText();
        NaturalNumber number = new NaturalNumber();

        for (int i=0; i<s.length(); i++) {
            number.addChar(s.charAt(i));
        }

        setSet(node, getSet(node.getNumbers()).add(number));

    }


    private void start(String[] arguments) {

        boolean info = false;
        String file = null;

        for (int i=0; i<arguments.length; ++i) {
            info = info || arguments[i].equals("-info");
            if (!arguments[i].startsWith("-")) {
                file = arguments[i];
            }
        }

        if (info) {

            printInfo();

        } else {

            printVersion();

            if (file != null) {

                FileReader f = null;

                try {
                    f = new FileReader(new File(file));
                } catch (FileNotFoundException e) {
                    System.out.println("Could not open file '" + file + "':" + e);
                }

                if (f != null) {

                    state = new State();
                    sets = new HashMap();

                    try {

                        Lexer l = new Lexer(new PushbackReader (new BufferedReader(f)));
                        Parser p = new Parser(l);

                        Start tree = p.parse();

                        tree.apply(this);

                    } catch (ParserException e) {

                        System.out.println("Syntax error at " + e.getToken().getText() + ":");
                        System.out.println(e.getMessage());

                    } catch (Exception e) {

                        System.out.println(e.getMessage());

                    }

                }

            }

        }

    }


    private void printVersion() {

        System.out.println("------------------------------------------------------------------------");
        System.out.println(" SableDS version " + VERSION + " (" + BUILD_DATE + ")");
        System.out.println(" " + AUTHOR);
        System.out.println();
        System.out.println(" Use -info option for more info.");
        System.out.println("------------------------------------------------------------------------");
        System.out.println();

    }


    private void printInfo() {

        System.out.println();
        System.out.println(" SableDS");
        System.out.println();
        System.out.println(" http://www.cs.vu.nl/~mvermaat/things/vu/ds2003.xhtml");
        System.out.println();
        System.out.println(" SableDS is a small interpreter for a simple mathematical language. The");
        System.out.println(" language provides elements and collections datatypes and some basic");
        System.out.println(" operations on collections.");
        System.out.println();
        System.out.println(" To interpret commands stored in a file, start SableDS like this:");
        System.out.println(" $ java SableDS filename");
        System.out.println();
        System.out.println(" To print this text, start SableDS with the -info option:");
        System.out.println(" $ java SableDS -info");
        System.out.println();
        System.out.println(" Example of a source file:");
        System.out.println();
        System.out.println("   a = {1, 2, 3}");
        System.out.println("   b = {2, 3, 4}");
        System.out.println("   ? a + b");
        System.out.println("   / comment");
        System.out.println();
        System.out.println(" Parsing code of SableDS was generated with the use of SableCC, a very");
        System.out.println(" cool parser generator for Java. More information on SableCC can be");
        System.out.println(" found here: http://www.sablecc.org");
        System.out.println();
        System.out.println(" Supported datatypes:");
        System.out.println(" * Element                   : string of digits");
        System.out.println(" * Collection of elements    : {element1, element2, ..., elementn}");
        System.out.println();
        System.out.println(" Supported operations:");
        System.out.println(" * Union                 : collection1 + collection2");
        System.out.println(" * Intersection          : collection1 * collection2");
        System.out.println(" * Difference            : collection1 - collection2");
        System.out.println(" * Symmetric difference  : collectino1 | collection2");
        System.out.println();
        System.out.println(" Supported statements:");
        System.out.println(" * Assignment            : myvar = expression");
        System.out.println(" * Print expression      : ? expression");
        System.out.println(" * Comment               : / some text");
        System.out.println();
        System.out.println(" Parentheses are supported to override standard precedence of operators.");
        System.out.println();
        System.out.println(" All sourcecode in this project written by me, Martijn Vermaat, is");
        System.out.println(" licensed under the GNU General Public License. Please refer to SableCC");
        System.out.println(" licensing documentation concerning the SableCC generated Java code.");
        System.out.println();
        System.out.println(" Some Java helper classes were written by Laurens Bronwasser and me");
        System.out.println(" for the 'Datastructuren' course 2003 at the Vrije Universiteit. With");
        System.out.println(" the permission of Laurens, that code is also licensed under the GNU");
        System.out.println(" General Public License.");

    }


    public static void main(String[] arguments) {

        new SableDS().start(arguments);

    }


}
