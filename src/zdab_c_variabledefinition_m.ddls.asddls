@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'DAB: Variable Definition Manage'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

@Metadata.allowExtensions: true

@ObjectModel: {
  semanticKey: ['variable_id'],
  representativeKey: 'variable_id'
}

define root view entity ZDAB_C_VariableDefinition_M
  provider contract transactional_query
  as projection on ZDAB_I_VariableDefinition

  association [0..*] to ZDAB_C_ParamConfigByVariable as _ParameterConfig on $projection.variable_id = _ParameterConfig.variable_id
{
  key variable_id,
      variable_name,
      variable_class_handler,
      is_vh_detected,
      @ObjectModel.text.element: ['CreatedByDescr']
      created_by,
      created_at,
      @ObjectModel.text.element: ['LastChangedByDescr']
      last_changed_by,
      last_changed_at,
      local_last_changed_by,
      local_last_changed_at,

      _UserCreatedBy.UserDescription     as CreatedByDescr,
      _UserLastChangedBy.UserDescription as LastChangedByDescr,

      _ParameterConfig

}
