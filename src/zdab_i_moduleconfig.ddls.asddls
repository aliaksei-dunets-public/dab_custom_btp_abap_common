@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'DAB: Module Configuration'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZDAB_I_ModuleConfig
  as select from zdab_c_modcf_a
  
  // BO Associations 
  composition [0..*] of ZDAB_I_ParamConfig as _ParameterConfig
  
  // Associations
  association [0..1] to ZDAB_I_User_VH as _UserCreatedBy     on $projection.created_by = _UserCreatedBy.UserID
  association [0..1] to ZDAB_I_User_VH as _UserLastChangedBy on $projection.created_by = _UserLastChangedBy.UserID

{
      @ObjectModel.text.element: ['module_name']
  key module_id,
      module_name,
      module_descr,
      module_is_active,
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,
      @Semantics.user.lastChangedBy: true
      last_changed_by,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at,
      
      // BO Associations
      _ParameterConfig,
      
      // Associations
      _UserCreatedBy,
      _UserLastChangedBy
}
