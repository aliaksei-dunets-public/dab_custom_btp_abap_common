@EndUserText.label: 'DAB: Parameter Configuration Manage'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true

@ObjectModel: {
  semanticKey: ['param_id'],
  representativeKey: 'param_id'
}

define view entity ZDAB_C_ParamConfig_M
  as projection on ZDAB_I_ParamConfig
{
  key module_id,  
  
      @ObjectModel.text.element: ['param_name']
  key param_id,
      param_name,
      param_descr,
      
      @ObjectModel.text.element: ['variable_name']
      variable_id,
      
      @ObjectModel.text.element: ['CreatedByDescr']
      created_by,
      created_at,

      _UserCreatedBy.UserDescription     as CreatedByDescr,

      _VariableDefinition.variable_name,

      // BO Associations
      _ModuleConfig : redirected to parent ZDAB_C_ModuleConfig_M,
      _ParameterValueConfig : redirected to composition child ZDAB_C_ParamValueConfig_M

}
