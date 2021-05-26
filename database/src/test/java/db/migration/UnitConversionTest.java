package db.migration;

import org.junit.jupiter.api.Test;

import db.migration.java.units.R__unit_conversions;
import net.hobbyscience.SimpleInfixCalculator;
import net.hobbyscience.database.Conversion;
import net.hobbyscience.database.Unit;
import net.hobbyscience.math.Equations;

import static org.junit.jupiter.api.Assertions.*;


public class UnitConversionTest {

    @Test
    public void test_can_generate_list_of_units() throws Exception{
        R__unit_conversions migration = new R__unit_conversions();
        migration.init();

        var conversions = migration.generateConversions();

        assertTrue( conversions.size() > 0 );
    }

    @Test
    public void smoketest_degC_degF_and_back() throws Exception {
        double degC_val = 20.0;
        double degF_val = 68.0;
        Unit degC_unit = new Unit("Temperature","degC","","");
        Unit degF_unit = new Unit("Temperature","degF","","");

        R__unit_conversions migration = new R__unit_conversions();
        migration.init();

        var conversions = migration.generateConversions();
        Conversion degC_to_F = conversions.stream().filter( c -> c.getFrom().equals(degC_unit) && c.getTo().equals(degF_unit) ).findFirst().get();
        Conversion degF_to_C = conversions.stream().filter( c -> c.getFrom().equals(degF_unit) && c.getTo().equals(degC_unit) ).findFirst().get();

        var infixCtoF = degC_to_F.getMethod().getPostfix();
        var infixFtoC = degF_to_C.getMethod().getPostfix();

        double ret = SimpleInfixCalculator.calculate(infixCtoF, degC_val);
        assertEquals(degF_val,ret, 0.0001);

        ret = SimpleInfixCalculator.calculate(infixFtoC, degF_val);
        assertEquals(degC_val,ret, 0.0001);

    }
}
