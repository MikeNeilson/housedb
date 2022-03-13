-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

CREATE UNIQUE INDEX location_names_lower on housedb.locations( lower(name) );
CREATE UNIQUE INDEX parameter_names_lower on housedb.parameters( lower(name) );
CREATE UNIQUE INDEX type_names_lower on housedb.types( lower(name) );
CREATE UNIQUE INDEX interval_names_lower on housedb.intervals( lower(name) );