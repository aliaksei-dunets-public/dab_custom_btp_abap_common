CLASS zdab_cl_var_defin_handler_base DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zdab_if_variable_defin_handler.

    ALIASES:
      mv_variable_id FOR zdab_if_variable_defin_handler~mv_variable_id.

    METHODS:
      constructor
        IMPORTING iv_variable_id TYPE zdab_variable_id.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      value_true  TYPE string VALUE 'X' ##NO_TEXT,
      value_false TYPE string VALUE ''  ##NO_TEXT.

ENDCLASS.

CLASS zdab_cl_var_defin_handler_base IMPLEMENTATION.

  METHOD constructor.
    mv_variable_id = iv_variable_id.
  ENDMETHOD.

  METHOD zdab_if_variable_defin_handler~get_value_help_source.

    CASE mv_variable_id.
      WHEN zdab_if_variable_defin_handler=>variable-boolean.
        APPEND VALUE #( variable_id = mv_variable_id param_value = value_true  param_value_descr = 'Yes'(001) ) TO rt_value_help_source.
        APPEND VALUE #( variable_id = mv_variable_id param_value = value_false param_value_descr = 'No'(002) )  TO rt_value_help_source.

      WHEN OTHERS.

        RETURN.

    ENDCASE.

  ENDMETHOD.

  METHOD zdab_if_variable_defin_handler~validate_value.

    CASE mv_variable_id.
      WHEN zdab_if_variable_defin_handler=>variable-boolean.

        IF  iv_param_value <> value_true
        AND iv_param_value <> value_false.

          " 030 - Value - &1 is inconsistent for Variable ID - &2
          MESSAGE e030(zdab_cust_common) WITH iv_param_value mv_variable_id INTO DATA(lv_dummy).
          RAISE EXCEPTION TYPE zdab_cx_variabledefinition USING MESSAGE.

        ENDIF.

      WHEN OTHERS.

        RETURN.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
