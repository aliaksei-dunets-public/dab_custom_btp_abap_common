@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'DAB: Variable Definition CDS View'
define root view entity ZDAB_I_VariableDefinition
  as select from zdab_c_vardef_a

  association [0..1] to ZDAB_I_User_VH as _UserCreatedBy     on $projection.created_by = _UserCreatedBy.UserID
  association [0..1] to ZDAB_I_User_VH as _UserLastChangedBy on $projection.created_by = _UserLastChangedBy.UserID

{
  key variable_id,
      variable_name,
      variable_class_handler,
      is_vh_detected,
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

      _UserCreatedBy,
      _UserLastChangedBy
}
