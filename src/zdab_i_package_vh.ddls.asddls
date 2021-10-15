@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DAB: Package Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

@Search.searchable: true
@UI.presentationVariant: [{
  sortOrder: [
    { by: 'ABAPPackage' }
  ]
}]

define view entity ZDAB_I_Package_VH
  as select from I_CustABAPPackage
{
      @Search.defaultSearchElement: true
  key ABAPPackage,
      ABAPSoftwareComponent,
      @Search.defaultSearchElement: true
      ABAPNamespace
}
