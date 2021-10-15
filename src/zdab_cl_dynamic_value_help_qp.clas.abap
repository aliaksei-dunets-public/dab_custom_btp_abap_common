CLASS zdab_cl_dynamic_value_help_qp DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_t_dynamic_value_help TYPE STANDARD TABLE OF zdab_ce_dynamicvaluehelp WITH NON-UNIQUE KEY param_value.

    INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
    METHODS:
      fetch_data
        IMPORTING
                  it_filter       TYPE if_rap_query_filter=>tt_name_range_pairs
        EXPORTING
                  et_fetched_data TYPE ty_t_dynamic_value_help
        RAISING   zdab_cx_rap_query_provider,

      paging_response
        IMPORTING it_fetched_data            TYPE table
                  io_paging                  TYPE REF TO if_rap_query_paging
        EXPORTING ev_total_number_of_records TYPE int8
                  et_response                TYPE ty_t_dynamic_value_help,

      sorting_response
        IMPORTING it_sort_elements TYPE if_rap_query_request=>tt_sort_elements
        CHANGING  ct_response      TYPE ty_t_dynamic_value_help.

  PRIVATE SECTION.
ENDCLASS.

CLASS zdab_cl_dynamic_value_help_qp IMPLEMENTATION.

  METHOD if_rap_query_provider~select.

    DATA:
      lt_fetched_data TYPE ty_t_dynamic_value_help,
      lt_response     TYPE ty_t_dynamic_value_help.

    IF io_request->is_data_requested( ).

      " Get range tables of the filter
      TRY.
          DATA(lt_filter_ranges) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
          RAISE EXCEPTION TYPE zdab_cx_rap_query_provider
            EXPORTING
              previous = lx_no_range.
      ENDTRY.

      " Fetching Data
      fetch_data(
        EXPORTING
          it_filter       = lt_filter_ranges
        IMPORTING
          et_fetched_data = lt_fetched_data
      ).

      " Sorting of the Response
      sorting_response(
        EXPORTING
          it_sort_elements = io_request->get_sort_elements( )
        CHANGING
          ct_response      = lt_fetched_data
      ).

      " Paging of the Response
      paging_response(
        EXPORTING
          it_fetched_data            = lt_fetched_data
          io_paging                  = io_request->get_paging( )
        IMPORTING
          ev_total_number_of_records = DATA(lv_total_number_of_records)
          et_response                = lt_response
      ).

      " Set total count of the messages
      IF io_request->is_total_numb_of_rec_requested( ).
        io_response->set_total_number_of_records( lv_total_number_of_records ).
      ENDIF.

      " Set Response
      io_response->set_data( lt_response ).

    ENDIF.

  ENDMETHOD.


  METHOD fetch_data.

    DATA:
      ltr_variable_id TYPE RANGE OF zdab_variable_id,
      ltr_param_value TYPE RANGE OF zdab_param_value,
      lv_variable_id  TYPE zdab_variable_id.

    CLEAR et_fetched_data.

    LOOP AT it_filter ASSIGNING FIELD-SYMBOL(<ls_filter>).
      CASE <ls_filter>-name.
        WHEN 'VARIABLE_ID'.

          ltr_variable_id = CORRESPONDING #( <ls_filter>-range ).

          TRY.
              " Get only first entry from filter for variable ID
              lv_variable_id = <ls_filter>-range[ 1 ]-low .
            CATCH cx_sy_itab_line_not_found.
              " If variable ID is not determined -> skip fetching
              RETURN.
          ENDTRY.

        WHEN 'PARAM_VALUE'.

          ltr_param_value = CORRESPONDING #( <ls_filter>-range ).

      ENDCASE.
    ENDLOOP.

    IF lv_variable_id IS INITIAL.
      RETURN.
    ENDIF.

    TRY.

        " Value Help is not detected in the configuration -> skip fetching
        IF zdab_cl_variabledefinition_api=>get_instance( )->get_is_vh_detected( lv_variable_id ) = abap_false.
          RETURN.
        ENDIF.

        DATA(lo_variable_class_handler) = zdab_cl_factory=>get_instance( )->get_variable_defin_handler( lv_variable_id ).

        et_fetched_data = lo_variable_class_handler->get_value_help_source( ).

      CATCH zdab_cx_variabledefinition INTO DATA(lx_variabledefinition).
        RAISE EXCEPTION TYPE zdab_cx_rap_query_provider
          EXPORTING
            previous = lx_variabledefinition.
    ENDTRY.

    " Remove filtered data
    DELETE et_fetched_data
      WHERE variable_id NOT IN ltr_variable_id
         OR param_value NOT IN ltr_param_value.

    SORT et_fetched_data BY param_value.
    DELETE ADJACENT DUPLICATES FROM et_fetched_data.

  ENDMETHOD.


  METHOD paging_response.

    IF it_fetched_data IS INITIAL.
      ev_total_number_of_records = 0.
      RETURN.
    ENDIF.

    ev_total_number_of_records = lines( it_fetched_data ).

    DATA(lv_offset) = io_paging->get_offset( ).
    DATA(lv_size) = io_paging->get_page_size( ).

    DATA(lv_init) = lv_offset + 1.
    DATA(lv_limit) = lv_offset + lv_size.

    IF ev_total_number_of_records > lv_size.

      LOOP AT it_fetched_data ASSIGNING FIELD-SYMBOL(<ls_fetched_data>) FROM lv_init TO lv_limit.
        APPEND <ls_fetched_data> TO et_response.
      ENDLOOP.

    ELSE.
      et_response = CORRESPONDING #( it_fetched_data ).
    ENDIF.

  ENDMETHOD.


  METHOD sorting_response.

    CHECK ct_response IS NOT INITIAL.

    IF it_sort_elements IS NOT INITIAL.

      DATA(lt_sort_condition) = VALUE abap_sortorder_tab( FOR sort_element IN it_sort_elements
                                                            ( name = condense( to_upper( sort_element-element_name ) )
                                                              descending = sort_element-descending ) ).

      SORT ct_response BY (lt_sort_condition).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
