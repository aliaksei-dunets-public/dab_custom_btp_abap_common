@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DAB: User Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Search.searchable: true

define view entity ZDAB_I_User_VH
  as select from I_User
{
      @ObjectModel.text.element: ['UserDescription']
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.8 }
  key UserID,
      @Semantics.text: true
      @Search: { defaultSearchElement: true, fuzzinessThreshold: 0.8 }
      UserDescription
}
where
  UserID like 'C%'
