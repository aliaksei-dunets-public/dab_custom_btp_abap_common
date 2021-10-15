@EndUserText.label: 'DAB: Parameter Value Config Manage'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

@ObjectModel: {
  semanticKey: ['param_condition'],
  representativeKey: 'param_condition'
}

define view entity ZDAB_C_ParamValueConfig_M
  as projection on ZDAB_I_ParamValueConfig

{
  key     module_id,
  key     param_id,
  key     param_condition,
          
          @ObjectModel.text.element: ['param_value_name']
          param_value,
          param_value_4_value_help,
          param_value_4_boolean,
          param_value_descr,

          @ObjectModel.text.element: ['CreatedByDescr']
          created_by,
          created_at,

          _ParameterConfig.variable_id,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZDAB_CL_CALC_VIRTUAL_ELEMENT'
  virtual param_value_name : zdab_long_name,
          //
          ////          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZDAB_CL_CALC_VIRTUAL_ELEMENT'
          ////  virtual fc_hide_param_value_4_vh   :abap_boolean,
          //
          //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZDAB_CL_CALC_VIRTUAL_ELEMENT'
          //  virtual fc_hide_param_value_4_bool :abap_boolean,

          _UserCreatedBy.UserDescription as CreatedByDescr,

          // BO Associations
          _ModuleConfig    : redirected to ZDAB_C_ModuleConfig_M,
          _ParameterConfig : redirected to parent ZDAB_C_ParamConfig_M

}
