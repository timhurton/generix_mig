# Coding Standards for the Development of SQL and PL/pgSQL

Below are the provisional coding standards that we will be using for the PostgreSQL side of the migration project. This list is not complete and will evolve over time. The standards are designed so that we all code in the same fashion, making it easier to pick up and understand each others' work. If you strongly disagree with any standard please let me know and we can discuss whether there is a better approach. Also, feel free to suggest any improvements you can think of.

We will be adopting the naming standard of the database, that is, all names will be in lowercase and separated with underscores e.g.:

> _table_name_

> _column_name_

> _proc_procedure_

> _func_function_

All commands and reserved words should be in uppercase.

Within Pl/pgSQL, different types of variables will be prefixed as follows:

> _v_current_zone_ - a general varaible

> _c_address_ - a cursor

> _r_address_ - a record

> _k_max_value_ a constant

SQL statements should be laid out using river topography, illustrated below:

SELECT a.allsts
      ,f.id
      ,z.id      
  FROM gezall a  
  LEFT OUTER JOIN facility f ON (a.codsit = f.facility_name)  
  JOIN zone z ON (z.zone_code = a.zonsts)  
ORDER BY a.allsts;



