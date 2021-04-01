package net.hobbyscience.housedb.dao;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.time.ZonedDateTime;
import java.util.Date;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

public class DataTripleTest{
    @Test
    public void testCanConvert() throws Exception {
        DataTriple dt = new DataTriple();
        dt.dateTime = new Date();
        dt.value = 1.2;
        dt.quality = 0;
       
        ObjectMapper om = new ObjectMapper();
        om.enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY);
        om.disable(SerializationFeature.WRITE_DATE_KEYS_AS_TIMESTAMPS);
        System.out.println(om.writeValueAsString(dt));
        

        DataTriple dt2 = om.readValue(om.writeValueAsString(dt),DataTriple.class);
        System.out.println(dt2.dateTime);
    }
}