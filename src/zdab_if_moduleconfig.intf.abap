INTERFACE zdab_if_moduleconfig
  PUBLIC .
  CONSTANTS:
    BEGIN OF module,
      dab_cust_ddic_object TYPE zdab_module_id VALUE 'ZDAB_CUST_DDIC_OBJECT'        ##NO_TEXT,
    END OF module,

    BEGIN OF parameter,
      uml_class_diagram_view TYPE zdab_param_id VALUE 'UML_CLASS_DIAGRAM_VIEW'      ##NO_TEXT,
    END OF parameter,

    BEGIN OF condition,
      alias              TYPE zdab_param_condition VALUE 'ALIAS'                    ##NO_TEXT,
      attributes         TYPE zdab_param_condition VALUE 'ATTRIBUTES'               ##NO_TEXT,
      constants          TYPE zdab_param_condition VALUE 'CONSTANTS'                ##NO_TEXT,
      deep_relationships TYPE zdab_param_condition VALUE 'DEEP_RELATIONSHIPS'       ##NO_TEXT,
      methods            TYPE zdab_param_condition VALUE 'METHODS'                  ##NO_TEXT,
      relationships      TYPE zdab_param_condition VALUE 'RELATIONSHIPS'            ##NO_TEXT,
      types              TYPE zdab_param_condition VALUE 'TYPES'                    ##NO_TEXT,
    END OF condition.

ENDINTERFACE.
