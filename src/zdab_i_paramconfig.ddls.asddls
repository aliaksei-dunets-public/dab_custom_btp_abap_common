@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DAB: Parameter Configuration'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZDAB_I_ParamConfig
  as select from zdab_c_prmcf_a

  // BO Associations
  association        to parent ZDAB_I_ModuleConfig as _ModuleConfig       on $projection.module_id = _ModuleConfig.module_id
  composition [0..*] of ZDAB_I_ParamValueConfig    as _ParameterValueConfig

  // Associations
  association [1..1] to ZDAB_I_VariableDefinition  as _VariableDefinition on $projection.variable_id = _VariableDefinition.variable_id
  association [0..1] to ZDAB_I_User_VH             as _UserCreatedBy      on $projection.created_by = _UserCreatedBy.UserID

{
  key module_id,
  key param_id,
      param_name,
      param_descr,
      variable_id,
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,

      // BO Associations
      _ModuleConfig,
      _ParameterValueConfig,

      // Associations
      _VariableDefinition,
      _UserCreatedBy
}
