-- Copyright 2022 Michael Neilson
-- Licensed Under MIT License. https://github.com/MikeNeilson/housedb/LICENSE.md

-- bootstrap a small amount of data here due to history of project
insert into housedb.units(unit,unitClass,system,description) values
    ('%','Percentage','EN_SI','percentage of 100'),
    ('in','Length','EN','small lenght (inches)'),
    ('degC','Temperature','SI','measure of temperature'),
    ('raw','none','EN_SI','no units or not yet set')
;


alter table housedb.parameters 
    add constraint units_fkey
    foreign key (units)
    references housedb.units(unit);
