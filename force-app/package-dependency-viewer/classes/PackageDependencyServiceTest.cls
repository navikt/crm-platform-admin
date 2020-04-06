@IsTest
private class PackageDependencyServiceTest {

    @IsTest static void testGetDependencies() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(new List<String>{
                package2Response, package2VersionResponse
        });
        Test.setMock(HttpCalloutMock.class, responses);

        Test.startTest();
        List<PackageDependencyService.SimplePackageVersion> packageVersions = new PackageDependencyService().getDependenciesForLatestReleasedVersions();
        Test.stopTest();

        // Assert that the response is correctly parsed and returned in the correct order
        System.assertEquals(2, packageVersions.size());
        System.assertEquals('fflib-apex-mocks', packageVersions[0].packageName);
        System.assertEquals('fflib-apex-common', packageVersions[1].packageName);
    }

    @IsTest static void testUpdatePackageRecords() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(new List<String>{
                package2Response, package2VersionResponse
        });
        Test.setMock(HttpCalloutMock.class, responses);

        List<UPM_UnlockedPackage__c> packages = new List<UPM_UnlockedPackage__c>();

        UPM_UnlockedPackage__c package1 = new UPM_UnlockedPackage__c();
        package1.Name = 'test-package-1';
        package1.SubscriberPackageId__c = '0332o000000TyICAA0';
        packages.add(package1);

        UPM_UnlockedPackage__c package2 = new UPM_UnlockedPackage__c();
        package2.Name = 'test-package-2';
        package2.SubscriberPackageId__c = '0332o000000TyIHAA0';
        packages.add(package2);

        UPM_UnlockedPackage__c package3 = new UPM_UnlockedPackage__c();
        package3.Name = 'test-package-3';
        package3.SubscriberPackageId__c = '0332o000000XXXXXXX'; // Doesn't exist in mock response
        packages.add(package3);

        insert packages;

        Test.startTest();
        PackageUpdateService.updateUnlockedPackageLatestReleasedFields();
        Test.stopTest();

        packages = [
                SELECT Id, LatestReleasedSubscriberPackageVersionId__c, LatestReleasedVersionInstallOrder__c
                FROM UPM_UnlockedPackage__c
                ORDER BY Name ASC
        ];


        System.assertEquals(3, packages.size());

        System.assertEquals('04t2o000001MwxDAAS', packages[0].LatestReleasedSubscriberPackageVersionId__c);
        System.assertEquals('04t2o000001MwxIAAS', packages[1].LatestReleasedSubscriberPackageVersionId__c);
        System.assertEquals(null, packages[2].LatestReleasedSubscriberPackageVersionId__c);

        System.assertEquals(0, packages[0].LatestReleasedVersionInstallOrder__c);
        System.assertEquals(1, packages[1].LatestReleasedVersionInstallOrder__c);
        System.assertEquals(null, packages[2].LatestReleasedVersionInstallOrder__c);
    }

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

