package net.hobbyscience.housedb.jackson;

import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.JacksonAnnotationIntrospector;

public class IgnoreJooq extends JacksonAnnotationIntrospector {
    /**
     *
     */
    private static final long serialVersionUID = 1L;

    @Override
    public boolean hasIgnoreMarker(final AnnotatedMember m) {        
        return m.getDeclaringClass().getName().contains("org.jooq")  || super.hasIgnoreMarker(m);
    }
}