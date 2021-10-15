CLASS zdab_cl_variabledefinition_api DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    CLASS-METHODS:
      get_instance
        RETURNING VALUE(ro_instance) TYPE REF TO zdab_cl_variabledefinition_api,

      read_variable_details_from_db
        IMPORTING iv_variable_id             TYPE zdab_variable_id
        RETURNING VALUE(rs_variable_details) TYPE zdab_s_variable
        RAISING   zdab_cx_variabledefinition,

      read_variables_details_from_db
        IMPORTING it_variable_ids             TYPE zdab_t_variable_key
        RETURNING VALUE(rt_variables_details) TYPE zdab_t_variable,

      read_variables_by_class
        IMPORTING iv_variable_class_handler   TYPE zdab_class_name
        RETURNING VALUE(rt_variables_details) TYPE zdab_t_variable.

    METHODS:
      check_variable_exist
        IMPORTING iv_variable_id  TYPE zdab_variable_id
        RETURNING VALUE(rv_exist) TYPE abap_boolean,
      get_variable_details
        IMPORTING iv_variable_id             TYPE zdab_variable_id
        RETURNING VALUE(rs_variable_details) TYPE zdab_s_variable
        RAISING   zdab_cx_variabledefinition,
      get_variable_name
        IMPORTING iv_variable_id          TYPE zdab_variable_id
        RETURNING VALUE(rv_variable_name) TYPE zdab_short_name
        RAISING   zdab_cx_variabledefinition,
      get_variable_class_handler
        IMPORTING iv_variable_id                   TYPE zdab_variable_id
        RETURNING VALUE(rv_variable_class_handler) TYPE zdab_class_name
        RAISING   zdab_cx_variabledefinition,
      get_is_vh_detected
        IMPORTING iv_variable_id        TYPE zdab_variable_id
        RETURNING VALUE(rv_vh_detected) TYPE abap_boolean
        RAISING   zdab_cx_variabledefinition,
      get_variables_details
        IMPORTING it_variable_ids             TYPE zdab_t_variable_key
        RETURNING VALUE(rt_variables_details) TYPE zdab_t_variable.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
        go_instance TYPE REF TO zdab_cl_variabledefinition_api.

    DATA:
      mt_variable_data TYPE zdab_t_variable.

    METHODS:
      get_variable
        IMPORTING iv_variable_id             TYPE zdab_variable_id
        RETURNING VALUE(rs_variable_details) TYPE zdab_s_variable
        RAISING   zdab_cx_variabledefinition.

ENDCLASS.

CLASS zdab_cl_variabledefinition_api IMPLEMENTATION.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.

    ro_instance = go_instance.
  ENDMETHOD.

  METHOD check_variable_exist.

    TRY.
        " Get variable ID from buffer and then from DB. If it doesn't exist -> raise exception
        get_variable( iv_variable_id ).
        rv_exist = abap_true.
      CATCH zdab_cx_variabledefinition.
        rv_exist = abap_false.
    ENDTRY.

  ENDMETHOD.

  METHOD get_variable_class_handler.
    rv_variable_class_handler = get_variable( iv_variable_id )-variable_class_handler.
  ENDMETHOD.


  METHOD get_variable_name.
    rv_variable_name = get_variable( iv_variable_id )-variable_name.
  ENDMETHOD.

  METHOD read_variable_details_from_db.

    CHECK iv_variable_id IS NOT INITIAL.

    SELECT SINGLE variable_id,
                  variable_name,
                  variable_class_handler,
                  is_vh_detected
      FROM zdab_c_vardef_a
        WHERE variable_id = @iv_variable_id
      INTO @rs_variable_details.

    IF sy-subrc <> 0.
      " 013 - Variable Definition has not been found for ID - &1
      MESSAGE e013(zdab_cust_common) WITH iv_variable_id INTO DATA(lv_dummy).
      RAISE EXCEPTION TYPE zdab_cx_variabledefinition USING MESSAGE.
    ENDIF.

  ENDMETHOD.

  METHOD get_variable_details.
    rs_variable_details = get_variable( iv_variable_id ).
  ENDMETHOD.

  METHOD read_variables_details_from_db.

    CHECK it_variable_ids IS NOT INITIAL.

    SELECT variable_id,
           variable_name,
           variable_class_handler
      FROM zdab_c_vardef_a
        FOR ALL ENTRIES IN @it_variable_ids
          WHERE variable_id = @it_variable_ids-variable_id
      INTO TABLE @rt_variables_details.

  ENDMETHOD.

  METHOD get_variable.

    IF iv_variable_id IS INITIAL.
      " 012 - Variable ID is missed
      MESSAGE e012(zdab_cust_common) INTO DATA(lv_dummy).
      RAISE EXCEPTION TYPE zdab_cx_variabledefinition USING MESSAGE.
    ENDIF.

    TRY.
        rs_variable_details = mt_variable_data[ KEY primary_key COMPONENTS variable_id = iv_variable_id ].
      CATCH cx_sy_itab_line_not_found.
        rs_variable_details = read_variable_details_from_db( iv_variable_id = iv_variable_id ).

        " Save variable into buffer
        APPEND rs_variable_details TO mt_variable_data.
    ENDTRY.

  ENDMETHOD.

  METHOD read_variables_by_class.

    CHECK iv_variable_class_handler IS NOT INITIAL.

    SELECT variable_id,
           variable_name,
           variable_class_handler
      FROM zdab_c_vardef_a
          WHERE variable_class_handler = @iv_variable_class_handler
      INTO TABLE @rt_variables_details.

  ENDMETHOD.

  METHOD get_is_vh_detected.
    rv_vh_detected = get_variable( iv_variable_id )-is_vh_detected.
  ENDMETHOD.

  METHOD get_variables_details.

    DATA:
      ls_variable_details          TYPE zdab_s_variable,
      lt_not_buffered_variable_ids TYPE zdab_t_variable_key.

    LOOP AT it_variable_ids ASSIGNING FIELD-SYMBOL(<ls_variable_ids>).

      " Read variables from buffer
      TRY.
          ls_variable_details = mt_variable_data[ KEY primary_key COMPONENTS variable_id = <ls_variable_ids>-variable_id ].

          " Add variable to exporting
          APPEND ls_variable_details TO rt_variables_details.

        CATCH cx_sy_itab_line_not_found.
          APPEND <ls_variable_ids> TO lt_not_buffered_variable_ids.
      ENDTRY.

    ENDLOOP.

    DATA(lt_not_buffered_variables) = read_variables_details_from_db( it_variable_ids = lt_not_buffered_variable_ids ).

    IF lt_not_buffered_variables IS NOT INITIAL.

      " Add variables to exporting
      APPEND LINES OF lt_not_buffered_variables TO rt_variables_details.

      " Save variable into buffer
      APPEND LINES OF lt_not_buffered_variables TO mt_variable_data.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
