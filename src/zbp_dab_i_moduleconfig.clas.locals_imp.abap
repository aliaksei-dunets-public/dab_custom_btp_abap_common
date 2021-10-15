CLASS lhc_paramvalueconfig DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validate_param_value FOR VALIDATE ON SAVE
      IMPORTING it_keys FOR paramvalueconfig~validateparamvalue.

ENDCLASS.

CLASS lhc_paramvalueconfig IMPLEMENTATION.

  METHOD validate_param_value.

    READ ENTITIES OF zdab_i_moduleconfig IN LOCAL MODE
      ENTITY paramvalueconfig BY \_parameterconfig
        FIELDS ( module_id
                 param_id
                 variable_id )
        WITH CORRESPONDING #( it_keys )
      RESULT DATA(lt_paramconfig)

      ENTITY paramvalueconfig
        FIELDS ( module_id
                 param_id
                 param_value )
        WITH CORRESPONDING #( it_keys )
      RESULT DATA(lt_paramvalueconfig)
      FAILED DATA(lt_failed).

    LOOP AT lt_paramconfig ASSIGNING FIELD-SYMBOL(<ls_paramconfig>).

      TRY.

          DATA(lo_variable_class_handler) = zdab_cl_factory=>get_instance( )->get_variable_defin_handler( <ls_paramconfig>-variable_id ).

          LOOP AT lt_paramvalueconfig ASSIGNING FIELD-SYMBOL(<ls_paramvalueconfig>).
            lo_variable_class_handler->validate_value( <ls_paramvalueconfig>-param_value ).
          ENDLOOP.

        CATCH zdab_cx_variabledefinition INTO DATA(lx_variabledefinition).

          APPEND VALUE #( %tky = <ls_paramconfig>-%tky ) TO failed-paramvalueconfig.

          APPEND VALUE #( %tky                    = <ls_paramvalueconfig>-%tky
                          %msg                    = new_message(
                                                      id       = lx_variabledefinition->if_t100_message~t100key-msgid
                                                      number   = lx_variabledefinition->if_t100_message~t100key-msgno
                                                      v1       = lx_variabledefinition->if_t100_dyn_msg~msgv1
                                                      v2       = lx_variabledefinition->if_t100_dyn_msg~msgv2
                                                      v3       = lx_variabledefinition->if_t100_dyn_msg~msgv3
                                                      v4       = lx_variabledefinition->if_t100_dyn_msg~msgv4
                                                      severity = if_abap_behv_message=>severity-error )
                          %element-param_value  = if_abap_behv=>mk-on
                        ) TO reported-paramvalueconfig.


      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_moduleconfig DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR moduleconfig RESULT result.

ENDCLASS.

CLASS lhc_moduleconfig IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
