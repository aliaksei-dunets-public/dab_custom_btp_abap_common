@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DAB: Parameter Config Field Control'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZDAB_I_ParamConfig_FieldContrl
  as select from ZDAB_I_ParamConfig
{
  key module_id,
  key param_id,
      variable_id,

      // Hiding field with Value Help
      case _VariableDefinition.is_vh_detected
        when 'X' then ''
        else 'X'
      end                                as fc_hide_param_value_4_vh,

      // Hiding field with Value Help
      _VariableDefinition.is_vh_detected as fc_hide_param_value,

      _VariableDefinition
}
