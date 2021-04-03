package net.hobbyscience.housedb.dao;

import org.junit.jupiter.api.Test;

import net.hobbyscience.housedb.housedb.udt.records.DataTripleRecord;

import static org.junit.jupiter.api.Assertions.*;

import java.time.OffsetDateTime;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.module.SimpleModule;

public class DataTripleTest{
    @Test
    public void testCanConvert() throws Exception {
        DataTriple dtr = new DataTriple();
        dtr.dateTime = OffsetDateTime.now();
        dtr.value = 1.0;
        dtr.quality = 3000;

        ObjectMapper om = new ObjectMapper();
        om.registerModule(new SimpleModule().addDeserializer(DataTriple.class, new DataTripleDeserializer()));
        om.registerModule(new SimpleModule().addSerializer(DataTriple.class, new DataTripleSerializer()));

        om.enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY);
        om.disable(SerializationFeature.WRITE_DATE_KEYS_AS_TIMESTAMPS);
        System.out.println(om.writeValueAsString(dtr));
        

        DataTripleRecord dtr2 = om.readValue(om.writeValueAsString(dtr),DataTripleRecord.class);
        System.out.println(dtr2.getDateTime());
        assertTrue(true);
    }
}