INTERFACE zdab_if_variable_defin_handler
  PUBLIC.

  CONSTANTS:
    BEGIN OF variable,
      boolean TYPE zdab_variable_id VALUE 'BOOLEAN'     ##NO_TEXT,
      int     TYPE zdab_variable_id VALUE 'INT'         ##NO_TEXT,
      string  TYPE zdab_variable_id VALUE 'STRING'      ##NO_TEXT,
    END OF variable.

  METHODS:
    validate_value
      IMPORTING iv_param_value TYPE zdab_param_value
      RAISING   zdab_cx_variabledefinition,

    get_value_help_source
      RETURNING VALUE(rt_value_help_source) TYPE zdab_cl_dynamic_value_help_qp=>ty_t_dynamic_value_help
      RAISING   zdab_cx_variabledefinition.

  DATA:
   mv_variable_id TYPE zdab_variable_id.

ENDINTERFACE.
