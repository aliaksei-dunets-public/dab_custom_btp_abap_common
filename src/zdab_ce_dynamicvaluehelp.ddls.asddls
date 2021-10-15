@EndUserText.label: 'Dynamic Value Help Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZDAB_CL_DYNAMIC_VALUE_HELP_QP'

@Search.searchable: true

define custom entity ZDAB_CE_DynamicValueHelp
{
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZDAB_I_VariableDefinition_VH', element: 'variable_id'  } }]
  key variable_id       : zdab_variable_id;
      
      @ObjectModel.text.element: ['param_value_descr']
      @Search.defaultSearchElement: true
  key param_value       : zdab_param_value;

      @Semantics.text   : true
      @Search.defaultSearchElement: true
      param_value_descr : zdab_long_name;


}
