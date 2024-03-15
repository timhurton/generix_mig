CREATE TABLE dblink_credentials(connect_name VARCHAR(20) NOT NULL PRIMARY KEY 
                                ,host_name   VARCHAR(20) NOT NULL
                                ,username    VARCHAR(40) NOT NULL
                                ,user_password VARCHAR(40) NOT NULL
                                ,dbname        VARCHAR(40) NOT NULL
                                );
INSERT INTO dblink_credentials (connect_name
                                ,host_name
                                ,username
                                ,user_password
                                ,dbname)
VALUES ('UtilsConnection'
       ,'10.5.2.4'
       ,'dblidl'
       ,'fqpB3iUxYf9Q!6ZEhQPVSYp'
       ,'utils');
