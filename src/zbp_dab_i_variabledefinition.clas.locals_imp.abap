CLASS lhc_zdab_i_variabledefinition DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR variabledefiniton RESULT result.
    METHODS validateclasshandler FOR VALIDATE ON SAVE
      IMPORTING keys FOR variabledefiniton~validateclasshandler.

    METHODS validatemandatoryfields FOR VALIDATE ON SAVE
      IMPORTING keys FOR variabledefiniton~validatemandatoryfields.

    METHODS get_instance_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR variabledefiniton RESULT result.

ENDCLASS.

CLASS lhc_zdab_i_variabledefinition IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validatemandatoryfields.

    READ ENTITIES OF zdab_i_variabledefinition IN LOCAL MODE
      ENTITY variabledefiniton
        FIELDS ( variable_name )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_variables)
      FAILED DATA(lt_read_failed).

    failed = CORRESPONDING #( DEEP lt_read_failed ).

    LOOP AT lt_variables ASSIGNING FIELD-SYMBOL(<ls_variables>).

      IF <ls_variables>-variable_name IS INITIAL.
        APPEND VALUE #( %tky = <ls_variables>-%tky ) TO failed-variabledefiniton.

        APPEND VALUE #( %tky                    = <ls_variables>-%tky
                        %msg                    = NEW zdab_cx_variabledefinition(
                                                    textid   = zdab_cx_variabledefinition=>missed_manadatory_field
                                                    severity = if_abap_behv_message=>severity-error )
                        %element-variable_name  = if_abap_behv=>mk-on
                      ) TO reported-variabledefiniton.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateclasshandler.

    CONSTANTS lc_variable_defin_interface TYPE string VALUE 'ZDAB_IF_VARIABLE_DEFIN_HANDLER' ##NO_TEXT.

    READ ENTITIES OF zdab_i_variabledefinition IN LOCAL MODE
      ENTITY variabledefiniton
        FIELDS ( variable_class_handler )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_variables)
      FAILED DATA(lt_read_failed).

    failed = CORRESPONDING #( DEEP lt_read_failed ).

    LOOP AT lt_variables ASSIGNING FIELD-SYMBOL(<ls_variables>).

      IF <ls_variables>-variable_class_handler IS INITIAL.
        APPEND VALUE #( %tky = <ls_variables>-%tky ) TO failed-variabledefiniton.

        APPEND VALUE #( %tky                            = <ls_variables>-%tky
                        %msg                            =  NEW zdab_cx_variabledefinition(
                                                            textid   = zdab_cx_variabledefinition=>missed_manadatory_field
                                                            severity = if_abap_behv_message=>severity-error )
                        %element-variable_class_handler = if_abap_behv=>mk-on
                      ) TO reported-variabledefiniton.

      ELSE.

        DATA(lt_interfaces) = xco_cp_abap_repository=>object->clas->for( <ls_variables>-variable_class_handler )->definition->content( )->get_interfaces( ).

        IF NOT line_exists( lt_interfaces[ table_line->name = lc_variable_defin_interface ] ).

          APPEND VALUE #( %tky = <ls_variables>-%tky ) TO failed-variabledefiniton.

          APPEND VALUE #( %tky                            = <ls_variables>-%tky
                          %msg                            =  NEW zdab_cx_variabledefinition(
                                                              textid   = zdab_cx_variabledefinition=>class_handler_invalid
                                                              severity = if_abap_behv_message=>severity-error
                                                              v1       = CONV #( <ls_variables>-variable_class_handler ) )
                          %element-variable_class_handler = if_abap_behv=>mk-on
                        ) TO reported-variabledefiniton.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.
    RETURN.

*    READ ENTITIES OF ZDAB_I_VariableDefinition IN LOCAL MODE
*      ENTITY VariableDefiniton
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_variables)
*      FAILED DATA(lt_read_failed).
*
*    result = VALUE #( FOR ls_variable IN lt_variables
*                      ( %tky = ls_variable-%tky
*
*                        " Dynamic Feature Control Implementation for fields
*                        %field-variable_name = COND #( WHEN ls_variable-is_vh_detected = abap_true
*                                                       THEN if_abap_behv=>fc-f-mandatory
*                                                       ELSE if_abap_behv=>fc-f-unrestricted )

*                           * Dynamic Feature Control Implementation for actions acceptTravel and rejectTravel
*                            %action-acceptTravel  = COND #( WHEN ls_travel-OverallStatus = 'A'
*                                                            THEN if_abap_behv=>fc-o-disabled
*                                                            ELSE if_abap_behv=>fc-o-enabled )
*                            %action-rejectTravel  = COND #( WHEN ls_travel-OverallStatus = 'X'
*                                                            THEN if_abap_behv=>fc-o-disabled
*                                                            ELSE if_abap_behv=>fc-o-enabled )
*             * Dynamic Feature Control Implementation for create-by-association for booking entity
*                            %assoc-_Booking       = COND #( WHEN ls_travel-OverallStatus = 'X'
*                                                            THEN if_abap_behv=>fc-o-disabled
*                                                            ELSE if_abap_behv=>fc-o-enabled )
*    ) ).

  ENDMETHOD.

ENDCLASS.
