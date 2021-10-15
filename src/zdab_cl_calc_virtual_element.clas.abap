CLASS zdab_cl_calc_virtual_element DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zdab_cl_calc_virtual_element IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA lt_original_data TYPE STANDARD TABLE OF zdab_c_paramvalueconfig_m WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<ls_original_data>).

      TRY.

          " Value Help is not detected in the configuration -> skip fetching
          IF zdab_cl_variabledefinition_api=>get_instance( )->get_is_vh_detected( <ls_original_data>-variable_id ) = abap_false.
            RETURN.
          ENDIF.

          DATA(lo_variable_class_handler) = zdab_cl_factory=>get_instance( )->get_variable_defin_handler( <ls_original_data>-variable_id ).

          DATA(lt_value_help_source) = lo_variable_class_handler->get_value_help_source( ).

          TRY.
              <ls_original_data>-param_value_name = lt_value_help_source[ variable_id = <ls_original_data>-variable_id
                                                                          param_value = <ls_original_data>-param_value ]-param_value_descr.
            CATCH cx_sy_itab_line_not_found.
              CONTINUE.
          ENDTRY.


        CATCH zdab_cx_variabledefinition INTO DATA(lx_variabledefinition).
          CONTINUE.
      ENDTRY.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    CASE iv_entity.
      WHEN 'ZDAB_C_PARAMVALUECONFIG_M'.

        LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<ls_requested_calc_elements>).
          CASE <ls_requested_calc_elements>.
            WHEN 'PARAM_VALUE_NAME'.

              INSERT CONV #( 'PARAM_VALUE' ) INTO TABLE et_requested_orig_elements.
              INSERT CONV #( 'VARIABLE_ID' ) INTO TABLE et_requested_orig_elements.

          ENDCASE.
        ENDLOOP.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
