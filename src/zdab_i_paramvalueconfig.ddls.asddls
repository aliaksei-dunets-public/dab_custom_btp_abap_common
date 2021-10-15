@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DAB: Parameter Value Configuration'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZDAB_I_ParamValueConfig
  as select from zdab_c_prmvlcf_a

  // BO Associations
  association        to parent ZDAB_I_ParamConfig as _ParameterConfig   on  $projection.module_id = _ParameterConfig.module_id
                                                                        and $projection.param_id  = _ParameterConfig.param_id

  // Associations
  association [1..1] to ZDAB_I_ModuleConfig       as _ModuleConfig      on  $projection.module_id = _ModuleConfig.module_id
  association [0..1] to ZDAB_I_User_VH            as _UserCreatedBy     on  $projection.created_by = _UserCreatedBy.UserID

{
  key module_id,
  key param_id,
  key param_condition,
      param_value,
      param_value_4_value_help,
      param_value_4_boolean,
      param_value_descr,
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,

      // BO Associations
      _ParameterConfig,

      // Associations
      _ModuleConfig,
      _UserCreatedBy
}
