package net.hobbyscience.housedb.jackson;

import java.util.logging.Logger;

import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.JacksonAnnotationIntrospector;

public class IgnoreJooq extends JacksonAnnotationIntrospector {
    private static final Logger logger = Logger.getLogger(IgnoreJooq.class.getName());
    /**
     *
     */
    private static final long serialVersionUID = 1L;

    @Override
    public boolean hasIgnoreMarker(final AnnotatedMember m) {        
        return m.getDeclaringClass().getName().contains("org.jooq")  || super.hasIgnoreMarker(m);
    }
}