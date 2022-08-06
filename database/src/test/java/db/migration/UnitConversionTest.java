package db.migration;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import db.migration.java.units.R__unit_conversions;
import net.hobbyscience.ConversionGraph;
import net.hobbyscience.SimpleInfixCalculator;
import net.hobbyscience.database.Conversion;
import net.hobbyscience.database.Unit;
import net.hobbyscience.math.Equations;

import static org.junit.jupiter.api.Assertions.*;

import java.util.HashSet;


public class UnitConversionTest {

    public static HashSet<Conversion> conversions = null;

    @BeforeAll
    private static void setup() throws Exception {
        R__unit_conversions migration = new R__unit_conversions();
        migration.init();

        conversions = new ConversionGraph(migration.baseConversions).generateConversions();

        /*
        conversions.forEach( c -> {
            System.out.println(c.toString());
        });
        */

        assertTrue( conversions.size() > 0 );
    }

    @Test
    public void test_degC_degF_and_back() throws Exception {
        double degC_val = 20.0;
        double degF_val = 68.0;
        Unit degC_unit = new Unit("Temperature","degC","","");
        Unit degF_unit = new Unit("Temperature","degF","","");


        Conversion degC_to_F = conversions.stream().filter( c -> c.getFrom().equals(degC_unit) && c.getTo().equals(degF_unit) ).findFirst().get();
        Conversion degF_to_C = conversions.stream().filter( c -> c.getFrom().equals(degF_unit) && c.getTo().equals(degC_unit) ).findFirst().get();

        var infixCtoF = degC_to_F.getMethod().getPostfix();
        var infixFtoC = degF_to_C.getMethod().getPostfix();

        double ret = SimpleInfixCalculator.calculate(infixCtoF, degC_val);
        assertEquals(degF_val,ret, 0.0001);

        ret = SimpleInfixCalculator.calculate(infixFtoC, degF_val);
        assertEquals(degC_val,ret, 0.0001);

    }

    @Test
    public void test_F_to_K_and_back() throws Exception {
        double degF_val = 40.0;
        double degK_val = 277.594;

        Unit degF_unit = new Unit("Temperature","degF","","");
        Unit degK_unit = new Unit("Temperature","K","","");

        Conversion degK_to_F = conversions.stream().filter( c -> c.getFrom().equals(degK_unit) && c.getTo().equals(degF_unit) ).findFirst().get();
        Conversion degF_to_K = conversions.stream().filter( c -> c.getFrom().equals(degF_unit) && c.getTo().equals(degK_unit) ).findFirst().get();

        System.out.println(degK_to_F.toString());
        System.out.println(degF_to_K.toString());

        var infixKtoF = degK_to_F.getMethod().getPostfix();
        var infixFtoK = degF_to_K.getMethod().getPostfix();

        double ret = SimpleInfixCalculator.calculate(infixKtoF, degK_val);
        assertEquals(degF_val,ret, 0.001);
        ret = -1;

        ret = SimpleInfixCalculator.calculate(infixFtoK, degF_val);
        assertEquals(degK_val,ret, 0.001);
    }

    @Test
    public void test_postfix_reduce() throws Exception {
        String simpleExpressionLong = "i 1000 * 0 + 1000 * 0 +";
        String simpleExpressionLongReduced = "i 1000000 * 0 +";

        String result = Equations.reduce(simpleExpressionLong);

        assertEquals(simpleExpressionLongReduced,result);

    }
}
