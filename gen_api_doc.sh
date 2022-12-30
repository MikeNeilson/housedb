#!/bin/bash

doxygen
xsltproc build/docs/xml/combine.xslt build/docs/xml/index.xml > build/all.xml
saxon build/all.xml openapi_xml.xslt