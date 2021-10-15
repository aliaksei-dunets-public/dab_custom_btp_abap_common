CLASS zdab_cl_moduleconfig_api DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_s_module.
        INCLUDE TYPE zdab_s_module_key.
        INCLUDE TYPE zdab_s_module_attr.
    TYPES: END OF ty_s_module.

    TYPES:
      BEGIN OF ty_s_param_config.
        INCLUDE TYPE zdab_s_param_config_key.
        INCLUDE TYPE zdab_s_param_config_attr.
    TYPES: END OF ty_s_param_config.

    TYPES:
      BEGIN OF ty_s_param_value.
        INCLUDE TYPE zdab_s_param_value_config_key.
        INCLUDE TYPE zdab_s_param_value_config_attr.
    TYPES: END OF ty_s_param_value.

    TYPES:
      ty_t_module       TYPE SORTED TABLE OF ty_s_module WITH UNIQUE KEY primary_key COMPONENTS module_id,
      ty_t_param_config TYPE SORTED TABLE OF ty_s_param_config WITH NON-UNIQUE KEY primary_key COMPONENTS module_id param_id,
      ty_t_param_value  TYPE SORTED TABLE OF ty_s_param_value WITH NON-UNIQUE KEY primary_key COMPONENTS module_id param_id param_condition.

    CLASS-METHODS:
      get_instance
        RETURNING VALUE(ro_instance) TYPE REF TO zdab_cl_moduleconfig_api,

      read_module_db
        IMPORTING iv_module_id     TYPE zdab_module_id
        EXPORTING es_module        TYPE ty_s_module
                  et_param_configs TYPE ty_t_param_config
                  et_param_values  TYPE ty_t_param_value
        RAISING   zdab_cx_moduleconfig,

      read_param_configs_db
        IMPORTING iv_module_id    TYPE zdab_module_id
        EXPORTING et_param_config TYPE ty_t_param_config
        RAISING   zdab_cx_moduleconfig,

      read_param_config_db
        IMPORTING iv_module_id    TYPE zdab_module_id
                  iv_param_id     TYPE zdab_param_id
        EXPORTING es_param_config TYPE ty_s_param_config
                  et_param_values TYPE ty_t_param_value
        RAISING   zdab_cx_moduleconfig,

      read_param_values_db
        IMPORTING iv_module_id    TYPE zdab_module_id
                  iv_param_id     TYPE zdab_param_id
        EXPORTING et_param_values TYPE ty_t_param_value
        RAISING   zdab_cx_moduleconfig,

      read_param_values_by_module_db
        IMPORTING iv_module_id    TYPE zdab_module_id
        EXPORTING et_param_values TYPE ty_t_param_value
        RAISING   zdab_cx_moduleconfig.

    METHODS:
      get_module
        IMPORTING iv_module_id     TYPE zdab_module_id
        EXPORTING es_module        TYPE ty_s_module
                  et_param_configs TYPE ty_t_param_config
                  et_param_values  TYPE ty_t_param_value
        RAISING   zdab_cx_moduleconfig,

      get_module_status
        IMPORTING iv_module_id     TYPE zdab_module_id
        RETURNING VALUE(rv_active) TYPE abap_bool
        RAISING   zdab_cx_moduleconfig,

      get_param_config
        IMPORTING iv_module_id    TYPE zdab_module_id
                  iv_param_id     TYPE zdab_param_id
        EXPORTING es_param_config TYPE ty_s_param_config
                  et_param_values TYPE ty_t_param_value
        RAISING   zdab_cx_moduleconfig,

      get_param_value_config
        IMPORTING iv_module_id       TYPE zdab_module_id
                  iv_param_id        TYPE zdab_param_id
                  iv_param_condition TYPE zdab_param_condition
        EXPORTING es_param_value     TYPE ty_s_param_value
        RAISING   zdab_cx_moduleconfig,

      get_param_value
        IMPORTING iv_module_id       TYPE zdab_module_id
                  iv_param_id        TYPE zdab_param_id
                  iv_param_condition TYPE zdab_param_condition
        EXPORTING rv_param_value     TYPE zdab_param_value
        RAISING   zdab_cx_moduleconfig,

      check_param_value_exist
        IMPORTING iv_module_id           TYPE zdab_module_id
                  iv_param_id            TYPE zdab_param_id
                  iv_param_value         TYPE zdab_param_value
        RETURNING VALUE(rv_value_exists) TYPE abap_bool
        RAISING   zdab_cx_moduleconfig.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA:
      go_instance TYPE REF TO zdab_cl_moduleconfig_api.

    DATA:
      mt_buffer_module TYPE ty_t_buffer_module.

    METHODS:
      get_buffer_module
        IMPORTING iv_module_id            TYPE zdab_module_id
        EXPORTING es_buffer_module        TYPE ty_s_buffer_module
                  et_buffer_param_configs TYPE ty_t_buffer_param_config
        RAISING   zdab_cx_moduleconfig,

      set_buffer_module
        IMPORTING iv_module_id TYPE zdab_module_id
        RAISING   zdab_cx_moduleconfig.

ENDCLASS.

CLASS zdab_cl_moduleconfig_api IMPLEMENTATION.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.

    ro_instance = go_instance.
  ENDMETHOD.

  METHOD get_module.

    get_buffer_module(
      EXPORTING
        iv_module_id     = iv_module_id
      IMPORTING
        es_buffer_module = DATA(ls_buffer_module)
    ).

    IF es_module IS SUPPLIED.
      es_module = CORRESPONDING #( ls_buffer_module ).
    ENDIF.

    IF et_param_configs IS SUPPLIED.
      et_param_configs = CORRESPONDING #( ls_buffer_module-param_configs ).
    ENDIF.

    IF et_param_values IS SUPPLIED.
      LOOP AT ls_buffer_module-param_configs ASSIGNING FIELD-SYMBOL(<ls_param_configs>).
        INSERT LINES OF <ls_param_configs>-param_values INTO TABLE et_param_values.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD get_module_status.

    get_buffer_module(
      EXPORTING
        iv_module_id     = iv_module_id
      IMPORTING
        es_buffer_module = DATA(ls_buffer_module)
    ).

    rv_active = ls_buffer_module-module_is_active.

  ENDMETHOD.

  METHOD get_param_config.

    get_buffer_module(
      EXPORTING
        iv_module_id            = iv_module_id
      IMPORTING
        et_buffer_param_configs = DATA(lt_buffer_param_config)
    ).

    IF iv_param_id IS INITIAL.
      "052 - Module Config API: Parameter ID is not specified
      MESSAGE e052(zdab_cust_common) INTO DATA(lv_dummy).
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    TRY.
        DATA(ls_buffer_param_config) = lt_buffer_param_config[ KEY primary_key COMPONENTS module_id = iv_module_id param_id = iv_param_id ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lx_sy_itab_line_not_found).
    ENDTRY.

    IF es_param_config IS SUPPLIED.
      es_param_config = CORRESPONDING #( ls_buffer_param_config ).
    ENDIF.

    IF et_param_values IS SUPPLIED.
      et_param_values = CORRESPONDING #( ls_buffer_param_config-param_values ).
    ENDIF.

  ENDMETHOD.

  METHOD get_param_value_config.

    get_param_config(
      EXPORTING
        iv_module_id    = iv_module_id
        iv_param_id     = iv_param_id
      IMPORTING
        et_param_values = DATA(lt_param_values)
    ).

    TRY.
        es_param_value = lt_param_values[ KEY primary_key COMPONENTS module_id = iv_module_id param_id = iv_param_id param_condition = iv_param_condition ].
      CATCH cx_sy_itab_line_not_found.
        " 054 - Module Config API: Parameter ID &1 and Condition &2 has not been found
        MESSAGE e054(zdab_cust_common) WITH iv_param_id iv_param_condition INTO DATA(lv_dummy).
        RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDTRY.

  ENDMETHOD.

  METHOD get_param_value.

    get_param_value_config(
      EXPORTING
        iv_module_id       = iv_module_id
        iv_param_id        = iv_param_id
        iv_param_condition = iv_param_condition
      IMPORTING
        es_param_value     = DATA(ls_paran_value)
    ).

    rv_param_value = ls_paran_value-param_value.

  ENDMETHOD.

  METHOD check_param_value_exist.

    get_param_config(
      EXPORTING
        iv_module_id    = iv_module_id
        iv_param_id     = iv_param_id
      IMPORTING
        et_param_values = DATA(lt_param_values)
    ).

    IF line_exists( lt_param_values[ module_id = iv_module_id param_id = iv_param_id param_value = iv_param_value ] ).
      rv_value_exists = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD read_module_db.

    DATA: lv_dummy TYPE string.

    IF iv_module_id IS INITIAL.
      "050 - Module Config API: Module ID is not specified
      MESSAGE e050(zdab_cust_common) INTO lv_dummy.
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    SELECT SINGLE module_id,
                  module_name,
                  module_descr,
                  module_is_active
      FROM zdab_c_modcf_a
        WHERE module_id = @iv_module_id
      INTO @es_module.

    IF sy-subrc <> 0.
      " 051 - Module Config API: Module ID &1 has not been found
      MESSAGE e051(zdab_cust_common) WITH iv_module_id INTO lv_dummy.
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    IF et_param_configs IS SUPPLIED.
      read_param_configs_db(
        EXPORTING
          iv_module_id    = iv_module_id
        IMPORTING
          et_param_config = et_param_configs
      ).
    ENDIF.

    IF  et_param_configs IS NOT INITIAL
    AND et_param_values IS SUPPLIED.
      read_param_values_by_module_db(
        EXPORTING
          iv_module_id    = iv_module_id
        IMPORTING
          et_param_values = et_param_values
      ).
    ENDIF.

  ENDMETHOD.

  METHOD read_param_config_db.

    DATA: lv_dummy TYPE string.

    IF iv_module_id IS INITIAL.
      "050 - Module Config API: Module ID is not specified
      MESSAGE e050(zdab_cust_common) INTO lv_dummy.
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    IF iv_param_id IS INITIAL.
      "052 - Module Config API: Parameter ID is not specified
      MESSAGE e052(zdab_cust_common) INTO lv_dummy.
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    SELECT SINGLE module_id,
                  param_id,
                  param_name,
                  param_descr,
                  variable_id
      FROM zdab_c_prmcf_a
        WHERE module_id = @iv_module_id
          AND param_id  = @iv_param_id
      INTO @es_param_config.

    IF sy-subrc <> 0.
      " 053 - Module Config API: Module ID &1 and Parameter ID &2 has not been found
      MESSAGE e053(zdab_cust_common) WITH iv_module_id iv_param_id INTO lv_dummy.
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    read_param_values_db(
      EXPORTING
        iv_module_id    = iv_module_id
        iv_param_id     = iv_param_id
      IMPORTING
        et_param_values = et_param_values
    ).

  ENDMETHOD.

  METHOD read_param_configs_db.

    IF iv_module_id IS INITIAL.
      "050 - Module Config API: Module ID is not specified
      MESSAGE e050(zdab_cust_common) INTO DATA(lv_dummy).
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    SELECT module_id,
           param_id,
           param_name,
           param_descr,
           variable_id
      FROM zdab_c_prmcf_a
        WHERE module_id = @iv_module_id
      ORDER BY PRIMARY KEY
      INTO TABLE @et_param_config.

  ENDMETHOD.

  METHOD read_param_values_db.

    DATA: lv_dummy TYPE string.

    IF iv_module_id IS INITIAL.
      "050 - Module Config API: Module ID is not specified
      MESSAGE e050(zdab_cust_common) INTO lv_dummy.
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    IF iv_param_id IS INITIAL.
      "052 - Module Config API: Parameter ID is not specified
      MESSAGE e052(zdab_cust_common) INTO lv_dummy.
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    SELECT module_id,
           param_id,
           param_condition,
           param_value,
           param_value_4_value_help,
           param_value_4_boolean,
           param_value_descr
      FROM zdab_c_prmvlcf_a
        WHERE module_id = @iv_module_id
          AND param_id  = @iv_param_id
      ORDER BY PRIMARY KEY
      INTO TABLE @et_param_values.

  ENDMETHOD.

  METHOD read_param_values_by_module_db.

    IF iv_module_id IS INITIAL.
      "050 - Module Config API: Module ID is not specified
      MESSAGE e050(zdab_cust_common) INTO DATA(lv_dummy).
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    SELECT module_id,
           param_id,
           param_condition,
           param_value,
           param_value_4_value_help,
           param_value_4_boolean,
           param_value_descr
      FROM zdab_c_prmvlcf_a
        WHERE module_id = @iv_module_id
      ORDER BY PRIMARY KEY
      INTO TABLE @et_param_values.

  ENDMETHOD.

  METHOD get_buffer_module.

    DATA: lv_dummy TYPE string.

    IF iv_module_id IS INITIAL.
      "050 - Module Config API: Module ID is not specified
      MESSAGE e050(zdab_cust_common) INTO lv_dummy.
      RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDIF.

    IF NOT line_exists( mt_buffer_module[ KEY primary_key COMPONENTS module_id = iv_module_id ] ).
      set_buffer_module( iv_module_id ).
    ENDIF.

    TRY.
        es_buffer_module = mt_buffer_module[ KEY primary_key COMPONENTS module_id = iv_module_id ].
      CATCH cx_sy_itab_line_not_found.
        " 051 - Module Config API: Module ID &1 has not been found
        MESSAGE e051(zdab_cust_common) WITH iv_module_id INTO lv_dummy.
        RAISE EXCEPTION TYPE zdab_cx_moduleconfig USING MESSAGE.
    ENDTRY.

    IF et_buffer_param_configs IS SUPPLIED.
      et_buffer_param_configs = CORRESPONDING #( es_buffer_module-param_configs ).
    ENDIF.

  ENDMETHOD.

  METHOD set_buffer_module.

    DATA:
      ls_buffer_module       TYPE ty_s_buffer_module,
      ls_buffer_param_config TYPE ty_s_buffer_param_config,
      ls_buffer_param_value  TYPE ty_s_buffer_param_value.

    read_module_db(
      EXPORTING
        iv_module_id     = iv_module_id
      IMPORTING
        es_module        = DATA(ls_module)
        et_param_configs = DATA(lt_param_configs)
        et_param_values  = DATA(lt_param_values)
    ).

    " Parse DB data to Buffer format
    ls_buffer_module = CORRESPONDING #( ls_module ).

    LOOP AT lt_param_configs ASSIGNING FIELD-SYMBOL(<ls_param_configs>)
      WHERE module_id = ls_module-module_id.

      CLEAR ls_buffer_param_config.

      ls_buffer_param_config = CORRESPONDING #( <ls_param_configs> ).

      LOOP AT lt_param_values ASSIGNING FIELD-SYMBOL(<ls_param_values>)
        WHERE module_id = <ls_param_configs>-module_id
          AND param_id  = <ls_param_configs>-param_id.

        CLEAR ls_buffer_param_value.

        ls_buffer_param_value = CORRESPONDING #( <ls_param_values> ).

        INSERT ls_buffer_param_value INTO TABLE ls_buffer_param_config-param_values.

      ENDLOOP.

      INSERT ls_buffer_param_config INTO TABLE ls_buffer_module-param_configs.

    ENDLOOP.

    INSERT ls_buffer_module INTO TABLE mt_buffer_module.

  ENDMETHOD.

ENDCLASS.
