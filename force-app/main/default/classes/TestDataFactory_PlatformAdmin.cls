@IsTest
public with sharing class TestDataFactory_PlatformAdmin {
    public static String int_environment_query_response =
        '{' +
        '  "status": 0,' +
        '  "result": {' +
        '    "size": 2,' +
        '    "totalSize": 2,' +
        '    "done": true,' +
        '    "queryLocator": null,' +
        '    "entityTypeName": "InstalledSubscriberPackage",' +
        '    "records": [' +
        '      {' +
        '        "attributes": {' +
        '          "type": "InstalledSubscriberPackage",' +
        '          "url": "/services/data/v48.0/tooling/sobjects/InstalledSubscriberPackage/0A32o000000VIX7CAO"' +
        '        },' +
        '        "Id": "0A32o000000VIX7CAO",' +
        '        "SubscriberPackageId": "0332o000000TyICAA0",' +
        '        "SubscriberPackage": {' +
        '          "attributes": {' +
        '            "type": "SubscriberPackage",' +
        '            "url": "/services/data/v48.0/tooling/sobjects/SubscriberPackage/0332o000000TyICAA0"' +
        '          },' +
        '          "Name": "fflib-apex-mocks"' +
        '        },' +
        '        "SubscriberPackageVersion": {' +
        '          "attributes": {' +
        '            "type": "SubscriberPackageVersion",' +
        '            "url": "/services/data/v48.0/tooling/sobjects/SubscriberPackageVersion/04t2o000001MwxDAAS"' +
        '          },' +
        '          "Id": "04t2o000001MwxDAAS",' +
        '          "Description": null,' +
        '          "IsBeta": false,' +
        '          "IsPasswordProtected": true,' +
        '          "MajorVersion": 0,' +
        '          "MinorVersion": 6,' +
        '          "PatchVersion": 0,' +
        '          "BuildNumber": 1' +
        '        }' +
        '      },' +
        '      {' +
        '        "attributes": {' +
        '          "type": "InstalledSubscriberPackage",' +
        '          "url": "/services/data/v48.0/tooling/sobjects/InstalledSubscriberPackage/0A32o000000VHvwCAG"' +
        '        },' +
        '        "Id": "0A32o000000VHvwCAG",' +
        '        "SubscriberPackageId": "0332o000000TyIHAA0",' +
        '        "SubscriberPackage": {' +
        '          "attributes": {' +
        '            "type": "SubscriberPackage",' +
        '            "url": "/services/data/v48.0/tooling/sobjects/SubscriberPackage/0332o000000TyIHAA0"' +
        '          },' +
        '          "Name": "fflib-apex-common"' +
        '        },' +
        '        "SubscriberPackageVersion": {' +
        '          "attributes": {' +
        '            "type": "SubscriberPackageVersion",' +
        '            "url": "/services/data/v48.0/tooling/sobjects/SubscriberPackageVersion/04t2o000001MwxIAAS"' +
        '          },' +
        '          "Id": "04t2o000001MwxIAAS",' +
        '          "Description": null,' +
        '          "IsBeta": false,' +
        '          "IsPasswordProtected": true,' +
        '          "MajorVersion": 0,' +
        '          "MinorVersion": 3,' +
        '          "PatchVersion": 0,' +
        '          "BuildNumber": 1' +
        '        }' +
        '      }' +
        '    ]' +
        '  }' +
        '}';

    public static String uat_environment_query_response =
        '{' +
        '  "status": 0,' +
        '  "result": {' +
        '    "size": 2,' +
        '    "totalSize": 2,' +
        '    "done": true,' +
        '    "queryLocator": null,' +
        '    "entityTypeName": "InstalledSubscriberPackage",' +
        '    "records": [' +
        '      {' +
        '        "attributes": {' +
        '          "type": "InstalledSubscriberPackage",' +
        '          "url": "/services/data/v48.0/tooling/sobjects/InstalledSubscriberPackage/0A32o000000VIX7CAO"' +
        '        },' +
        '        "Id": "0A32o000000VIX7CAO",' +
        '        "SubscriberPackageId": "0332o000000TyICAA0",' +
        '        "SubscriberPackage": {' +
        '          "attributes": {' +
        '            "type": "SubscriberPackage",' +
        '            "url": "/services/data/v48.0/tooling/sobjects/SubscriberPackage/0332o000000TyICAA0"' +
        '          },' +
        '          "Name": "fflib-apex-mocks"' +
        '        },' +
        '        "SubscriberPackageVersion": {' +
        '          "attributes": {' +
        '            "type": "SubscriberPackageVersion",' +
        '            "url": "/services/data/v48.0/tooling/sobjects/SubscriberPackageVersion/04t2o000001MwxDAAS"' +
        '          },' +
        '          "Id": "04t2o000001MwxDAAS",' +
        '          "Description": null,' +
        '          "IsBeta": false,' +
        '          "IsPasswordProtected": true,' +
        '          "MajorVersion": 0,' +
        '          "MinorVersion": 6,' +
        '          "PatchVersion": 0,' +
        '          "BuildNumber": 1' +
        '        }' +
        '      }' +
        '    ]' +
        '  }' +
        '}';
        
public static String package2Response =
'{' +
'  "status": 0,' +
'  "result": {' +
'    "size": 2,' +
'    "totalSize": 2,' +
'    "done": true,' +
'    "queryLocator": null,' +
'    "entityTypeName": "Package2",' +
'    "records": [' +
'      {' +
'        "attributes": {' +
'          "type": "Package2",' +
'          "url": "/services/data/v48.0/tooling/sobjects/Package2/0Ho2o0000008OQUCA2"' +
'        },' +
'        "Id": "0Ho2o0000008OQUCA2",' +
'        "Name": "fflib-apex-mocks",' +
'        "Package2Versions": {' +
'          "size": 1,' +
'          "totalSize": 1,' +
'          "done": true,' +
'          "queryLocator": null,' +
'          "entityTypeName": "Package2Version",' +
'          "records": [' +
'            {' +
'              "attributes": {' +
'                "type": "Package2Version",' +
'                "url": "/services/data/v48.0/tooling/sobjects/Package2Version/05i2o000000TN7NAAW"' +
'              },' +
'              "Id": "05i2o000000TN7NAAW",' +
'              "SubscriberPackageVersionId": "04t2o000001MwxDAAS",' +
'              "SubscriberPackageVersion": {' +
'                "attributes": {' +
'                  "type": "SubscriberPackageVersion",' +
'                  "url": "/services/data/v48.0/tooling/sobjects/SubscriberPackageVersion/04t2o000001MwxDAAS"' +
'                },' +
'                "Dependencies": null' +
'              }' +
'            }' +
'          ]' +
'        }' +
'      },' +
'      {' +
'        "attributes": {' +
'          "type": "Package2",' +
'          "url": "/services/data/v48.0/tooling/sobjects/Package2/0Ho2o0000008OQZCA2"' +
'        },' +
'        "Id": "0Ho2o0000008OQZCA2",' +
'        "Name": "fflib-apex-common",' +
'        "Package2Versions": {' +
'          "size": 1,' +
'          "totalSize": 1,' +
'          "done": true,' +
'          "queryLocator": null,' +
'          "entityTypeName": "Package2Version",' +
'          "records": [' +
'            {' +
'              "attributes": {' +
'                "type": "Package2Version",' +
'                "url": "/services/data/v48.0/tooling/sobjects/Package2Version/05i2o000000TN7SAAW"' +
'              },' +
'              "Id": "05i2o000000TN7SAAW",' +
'              "SubscriberPackageVersionId": "04t2o000001MwxIAAS",' +
'              "SubscriberPackageVersion": {' +
'                "attributes": {' +
'                  "type": "SubscriberPackageVersion",' +
'                  "url": "/services/data/v48.0/tooling/sobjects/SubscriberPackageVersion/04t2o000001MwxIAAS"' +
'                },' +
'                "Dependencies": {' +
'                  "ids": [' +
'                    {' +
'                      "subscriberPackageVersionId": "04t2o000001MwxDAAS"' +
'                    }' +
'                  ]' +
'                }' +
'              }' +
'            }' +
'          ]' +
'        }' +
'      }' +
'    ]' +
'  }' +
'}';

public static String package2VersionResponse =
'{' +
'  "status": 0,' +
'  "result": {' +
'    "size": 5,' +
'    "totalSize": 5,' +
'    "done": true,' +
'    "queryLocator": null,' +
'    "entityTypeName": "Package2Version",' +
'    "records": [' +
'      {' +
'        "attributes": {' +
'          "type": "Package2Version",' +
'          "url": "/services/data/v48.0/tooling/sobjects/Package2Version/05i2o000000TN7NAAW"' +
'        },' +
'        "Id": "05i2o000000TN7NAAW",' +
'        "Package2": {' +
'          "attributes": {' +
'            "type": "Package2",' +
'            "url": "/services/data/v48.0/tooling/sobjects/Package2/0Ho2o0000008OQUCA2"' +
'          },' +
'          "SubscriberPackageId": "0332o000000TyICAA0",' +
'          "Name": "fflib-apex-mocks",' +
'          "Id": "0Ho2o0000008OQUCA2"' +
'        },' +
'        "MajorVersion": 0,' +
'        "MinorVersion": 1,' +
'        "PatchVersion": 0,' +
'        "BuildNumber": 3,' +
'        "SubscriberPackageVersionId": "04t2o000001MwxDAAS"' +
'      },' +
'      {' +
'        "attributes": {' +
'          "type": "Package2Version",' +
'          "url": "/services/data/v48.0/tooling/sobjects/Package2Version/05i2o000000TN78AAG"' +
'        },' +
'        "Id": "05i2o000000TN78AAG",' +
'        "Package2": {' +
'          "attributes": {' +
'            "type": "Package2",' +
'            "url": "/services/data/v48.0/tooling/sobjects/Package2/0Ho2o0000008OQUCA2"' +
'          },' +
'          "SubscriberPackageId": "0332o000000TyICAA0",' +
'          "Name": "fflib-apex-mocks",' +
'          "Id": "0Ho2o0000008OQUCA2"' +
'        },' +
'        "MajorVersion": 0,' +
'        "MinorVersion": 1,' +
'        "PatchVersion": 0,' +
'        "BuildNumber": 1,' +
'        "SubscriberPackageVersionId": "04t2o000001MwwyAAC"' +
'      },' +
'      {' +
'        "attributes": {' +
'          "type": "Package2Version",' +
'          "url": "/services/data/v48.0/tooling/sobjects/Package2Version/05i2o000000TN7IAAW"' +
'        },' +
'        "Id": "05i2o000000TN7IAAW",' +
'        "Package2": {' +
'          "attributes": {' +
'            "type": "Package2",' +
'            "url": "/services/data/v48.0/tooling/sobjects/Package2/0Ho2o0000008OQUCA2"' +
'          },' +
'          "SubscriberPackageId": "0332o000000TyICAA0",' +
'          "Name": "fflib-apex-mocks",' +
'          "Id": "0Ho2o0000008OQUCA2"' +
'        },' +
'        "MajorVersion": 0,' +
'        "MinorVersion": 1,' +
'        "PatchVersion": 0,' +
'        "BuildNumber": 2,' +
'        "SubscriberPackageVersionId": "04t2o000001Mwx8AAC"' +
'      },' +
'      {' +
'        "attributes": {' +
'          "type": "Package2Version",' +
'          "url": "/services/data/v48.0/tooling/sobjects/Package2Version/05i2o000000TN7SAAW"' +
'        },' +
'        "Id": "05i2o000000TN7SAAW",' +
'        "Package2": {' +
'          "attributes": {' +
'            "type": "Package2",' +
'            "url": "/services/data/v48.0/tooling/sobjects/Package2/0Ho2o0000008OQZCA2"' +
'          },' +
'          "SubscriberPackageId": "0332o000000TyIHAA0",' +
'          "Name": "fflib-apex-common",' +
'          "Id": "0Ho2o0000008OQZCA2"' +
'        },' +
'        "MajorVersion": 0,' +
'        "MinorVersion": 1,' +
'        "PatchVersion": 0,' +
'        "BuildNumber": 2,' +
'        "SubscriberPackageVersionId": "04t2o000001MwxIAAS"' +
'      },' +
'      {' +
'        "attributes": {' +
'          "type": "Package2Version",' +
'          "url": "/services/data/v48.0/tooling/sobjects/Package2Version/05i2o000000TN7DAAW"' +
'        },' +
'        "Id": "05i2o000000TN7DAAW",' +
'        "Package2": {' +
'          "attributes": {' +
'            "type": "Package2",' +
'            "url": "/services/data/v48.0/tooling/sobjects/Package2/0Ho2o0000008OQZCA2"' +
'          },' +
'          "SubscriberPackageId": "0332o000000TyIHAA0",' +
'          "Name": "fflib-apex-common",' +
'          "Id": "0Ho2o0000008OQZCA2"' +
'        },' +
'        "MajorVersion": 0,' +
'        "MinorVersion": 1,' +
'        "PatchVersion": 0,' +
'        "BuildNumber": 1,' +
'        "SubscriberPackageVersionId": "04t2o000001Mwx3AAC"' +
'      }' +
'    ]' +
'  }' +
'}';
}

