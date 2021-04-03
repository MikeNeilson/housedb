package net.hobbyscience.housedb.dao;

import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.logging.Logger;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;

public class DataTripleDeserializer extends StdDeserializer<DataTriple>{
    public static final Logger logger = Logger.getLogger(DataTripleDeserializer.class.getName());
    public DataTripleDeserializer(){
        this(null);
    }

    public DataTripleDeserializer(Class<?> vc) {
        super(vc);        
    }

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    @Override
    public DataTriple deserialize(JsonParser jp, DeserializationContext ctxt) throws IOException{
        DataTriple dtr = new DataTriple();
        JsonNode node = jp.getCodec().readTree(jp);
        logger.info(node.toPrettyString());
        dtr.dateTime = OffsetDateTime.parse(node.get(0).asText());
        dtr.value = node.get(1).asDouble();
        dtr.quality = node.get(2).asInt();
        return dtr;
    }
}
