# Coding Standards for the Development of SQL and PL/pgSQL

Below are the provisional coding standards that we will be using for the PostgreSQL side of the migration project. This list is not complete and will evolve over time. The standards are designed so that we all code in the same fashion, making it easier to pick up and understand each others' work. If you strongly disagree with any standard please let me know and we can discuss whether there is a better approach. Also, feel free to suggest any improvements you can think of.

These are guidelines that should be followed as closely as possible, but there will be cases when it is impossible to adhere to them completely, for example, on more complex join conditions it may not be practical to keep the code all on one line. In this case, feel free to go on the next line. Apply common sense in these cases, but if you are not sure, feel free to ask.

I have created a file called **samples.sql** for specific examples. The examples used in this file are all fictitious, so do not focus on the logic as such, just concentrate on the best practice aspect of it.

We will be adopting the naming standard of the database, that is, all names will be in lowercase and separated with underscores e.g.:

> _column_name_

> _func_function_

> _proc_procedure_

> _table_name_

> _vw_view_

All commands and reserved words should be in uppercase.

Within PL/pgSQL, different types of variables will be prefixed as follows:

> _v_current_zone_ - a general varaible

> _c_address_ - a cursor

> _k_max_value_ a constant

> _p_parameter_name_ a a parameter

> _r_address_ - a record

> _k_max_value_ a constant

Do not rely on implicit code where it is possible to use explicit code. Examples of this can be found in samples.sql:
Example 1 shows ORDER BY being used with explicit column_names, not their positions. Positional notation is only allowed when using set operations.

When calling a function or procedure use named parameters to ensure the right value is passed to the right parameter (see example 2).

Never use * in a select statement. Explicitly name the column, as shown in example 3.

SQL statements should be laid out using river topography, illustrated in  example 1. Here, the commands are all right-aligned and the variables are left-aligned. This is a common practice amongst sql developers and was referred to in the training that you have just completed. Note that UNIONs and ORDER BYs align with the SELECT command.

Tables should be joined using the relevant JOIN command with the join condition on the same line. I generally wrap parentheses around the ON condition to aid clarity. This means only predicates which restrict data will be found in the WHERE section of the query.

Objects should never be prefixed by a schema name. Some databases might include two or more clients, with each one on a different schema. This means we cannot hard-code schema names, and we will get around this by other means that avoid this (and also exclude the need to dynamically change each sql statement to use the correct schema).

Code should be indented by two characters where required. Good IDEs allow you to set the tab spacing to this if required, and the better ones can then convert it to characters afterwards, making subsequent reformatting easier.
Indents should be used for code within a block, loop, exception handler and  if/case statements, and should be indented further for each iteration. See example 4.
Note:
* All of these structures have a preceding and trailing line to make them stand out.
* Embedded PL/SQL blocks should have their own error handler.
* The use of block labelling for inner blocks is helpful.

Procedures and functions which are passed parameters should log their values in the 'START' call to the logging procedure as shown in example 5. Note how when the p_desc gets too long we intend the rest of the information on the next line. Also note how before running the dynamic sql in the last line, the sql being run is also logged (using p_desc), this will make your life easier if it fails.

Hopefully, you all agree that comments are a good thing, but not every comment is useful, so these need to be managed. Only add a comment if the code is not self-explanatory. The emphasis should be on the naming of the variables. See example 6. Also, comments should be treated like code and maintained as well. If you are changing some logic that includes comments, the chances are that comments will need changing too. This will avoid future ambiguity over whether the code is correct or the comments.



