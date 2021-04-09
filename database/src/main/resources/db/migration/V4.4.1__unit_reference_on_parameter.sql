-- bootstrap a small amount of data here due to history of project
insert into housedb.units(unit,system,description) values
    ('%','EN_SI','percentage of 100'),
    ('in','EN','small lenght (inches)'),
    ('degC','SI','measure of temperature')
;


alter table housedb.parameters 
    add constraint units_fkey
    foreign key (units)
    references housedb.units(unit);
