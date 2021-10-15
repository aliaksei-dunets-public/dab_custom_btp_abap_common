CLASS zdab_cl_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    CLASS-METHODS:
      get_instance
        RETURNING VALUE(ro_instance) TYPE REF TO zdab_cl_factory.

    METHODS:
      get_variable_defin_handler
        IMPORTING iv_variable_id                   TYPE zdab_variable_id
        RETURNING VALUE(ro_variable_defin_handler) TYPE REF TO zdab_if_variable_defin_handler
        RAISING   zdab_cx_variabledefinition.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      go_instance TYPE REF TO zdab_cl_factory.
ENDCLASS.

CLASS zdab_cl_factory IMPLEMENTATION.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.

    ro_instance = go_instance.
  ENDMETHOD.


  METHOD get_variable_defin_handler.

    " Get Class handler name from configuration by Variable ID
    DATA(lv_class_handler_name) = zdab_cl_variabledefinition_api=>get_instance( )->get_variable_class_handler( iv_variable_id ).

    TRY.
        " Create instance of a class and return it
        CREATE OBJECT ro_variable_defin_handler TYPE (lv_class_handler_name)
          EXPORTING iv_variable_id = iv_variable_id.

      CATCH cx_sy_create_object_error INTO DATA(lx_sy_create_object_error).
        RAISE EXCEPTION TYPE zdab_cx_variabledefinition
          EXPORTING
            previous = lx_sy_create_object_error.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
