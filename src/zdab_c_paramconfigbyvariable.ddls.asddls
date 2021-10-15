@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DAB: Parameter Configuration By Variable'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

@Metadata.allowExtensions: true

@ObjectModel: {
  semanticKey: ['param_id'],
  representativeKey: 'param_id'
}

define view entity ZDAB_C_ParamConfigByVariable
  as select from ZDAB_I_ParamConfig
{

      @ObjectModel.text.element: ['module_name']
  key module_id,

      @ObjectModel.text.element: ['param_name']
  key param_id,
      param_name,
      
      variable_id,

      @ObjectModel.text.element: ['CreatedByDescr']
      created_by,
      created_at,

      _ModuleConfig.module_name,
      _UserCreatedBy.UserDescription as CreatedByDescr
}
