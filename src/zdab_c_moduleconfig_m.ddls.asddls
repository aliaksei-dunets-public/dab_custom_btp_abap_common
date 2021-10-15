@EndUserText.label: 'DAB: Module Configuration Manage'
@AccessControl.authorizationCheck: #CHECK

@Metadata.allowExtensions: true

@ObjectModel: {
  semanticKey: ['module_id'],
  representativeKey: 'module_id'
}

define root view entity ZDAB_C_ModuleConfig_M
  provider contract transactional_query
  as projection on ZDAB_I_ModuleConfig
{

      @ObjectModel.text.element: ['module_name']
  key module_id,
      module_name,
      module_descr,
      module_is_active,

      @ObjectModel.text.element: ['CreatedByDescr']
      created_by,
      created_at,
      @ObjectModel.text.element: ['LastChangedByDescr']
      last_changed_by,
      last_changed_at,
      local_last_changed_by,
      local_last_changed_at,

      _UserCreatedBy.UserDescription                      as CreatedByDescr,
      _UserLastChangedBy.UserDescription                  as LastChangedByDescr,

      /* Associations */
      _ParameterConfig : redirected to composition child ZDAB_C_ParamConfig_M,
      _UserCreatedBy,
      _UserLastChangedBy
}
