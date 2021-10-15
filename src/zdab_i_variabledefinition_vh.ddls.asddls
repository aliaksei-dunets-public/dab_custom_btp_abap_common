@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'DAB: Variable Definition Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

@Search.searchable: true
@UI.presentationVariant: [{
  sortOrder: [
    { by: 'variable_id' }
  ]
}]

define view entity ZDAB_I_VariableDefinition_VH
  as select from ZDAB_I_VariableDefinition
{
      @Search.defaultSearchElement: true
  key variable_id,
  
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Variable Name'
      variable_name,
      
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZDAB_I_ClassName_VH', element: 'ABAPClassName'  } }]
      variable_class_handler
}
