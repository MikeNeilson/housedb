
--
-- Name: create_timeseries(character varying); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION create_timeseries(ts_name character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION create_timeseries(ts_name character varying) FROM housedb_owner;
GRANT ALL ON FUNCTION create_timeseries(ts_name character varying) TO housedb_owner;
GRANT ALL ON FUNCTION create_timeseries(ts_name character varying) TO housedb_user;


--
-- Name: timeseries_values; Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON TABLE timeseries_values FROM PUBLIC;
REVOKE ALL ON TABLE timeseries_values FROM housedb_owner;
GRANT ALL ON TABLE timeseries_values TO housedb_owner;
GRANT ALL ON TABLE timeseries_values TO housedb_user;
GRANT SELECT,INSERT,REFERENCES ON TABLE timeseries_values TO PUBLIC;