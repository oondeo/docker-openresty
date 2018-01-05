# kibana dashboards must be safeable
BasicRule wl:15 "mz:$URL_X:/kibana-int/dashboard|BODY" ;

# config in url - whitelisting
BasicRule wl:42000252 "mz:$URL:/app/components/require.config.js|URL"; 
BasicRule wl:1015 "mz:$URL_X:/logstash-|URL";



#BasicRule wl:15 ; 
#BasicRule wl:16 ;



# needed for naxsi < 0.54 - did not detect json autonmagically
BasicRule wl:1001,1205,1000,1011,1010 "mz:$URL_X:/logstash|BODY";
BasicRule wl:1000 "mz:$URL_X:/logstash|BODY|NAME";
BasicRule wl:1015 "mz:$URL_X:/logstash|URL"; 
BasicRule wl:1009 "mz:$URL_X:/logstash|BODY";


