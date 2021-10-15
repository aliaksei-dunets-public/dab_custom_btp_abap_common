@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DAB: Class Name'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

@Search.searchable: true
@UI.presentationVariant: [{
  sortOrder: [
    { by: 'ABAPClassName' }
  ]
}]

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZDAB_I_ClassName_VH
  as select distinct from I_CustABAPObjDirectoryEntry
{
      @EndUserText.label: 'Class'
      @Search.defaultSearchElement: true
  key ABAPObject as ABAPClassName,

      @Consumption.valueHelpDefinition: [{
        entity : { name: 'ZDAB_I_Package_VH', element: 'ABAPPackage' },
        additionalBinding: [{ element: 'ABAPSoftwareComponent', localElement: 'ABAPSoftwareComponent' }]
      }]
      @Search.defaultSearchElement: true
      ABAPPackage,
      ABAPSoftwareComponent,

      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZDAB_I_User_VH', element: 'UserID'  } }]
      ABAPObjectResponsibleUser
}
where
      ABAPObjectType      = 'CLAS'
  and ABAPObjectIsDeleted is initial
