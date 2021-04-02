package net.hobbyscience.housedb.dao;

import java.io.IOException;
import java.time.format.DateTimeFormatter;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;

import net.hobbyscience.housedb.housedb.udt.records.DataTripleRecord;

public class DataTripleSerializer extends StdSerializer<DataTriple>{

    /**
     *
     */
    private static final long serialVersionUID = 1L;

    public DataTripleSerializer(){
        this(null);        
    }

    public DataTripleSerializer(Class<DataTriple> t){
        super(t);
    }

    @Override
    public void serialize(DataTriple value, JsonGenerator gen, SerializerProvider provider) throws IOException {          
          gen.writeStartArray();        
          gen.writeString(value.dateTime.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME));
          gen.writeNumber(value.value);
          gen.writeNumber(value.quality);
          gen.writeEndArray();
    }
    
}
