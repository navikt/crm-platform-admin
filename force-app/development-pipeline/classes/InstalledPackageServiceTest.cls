@IsTest
private class InstalledPackageServiceTest {

    @IsTest
    private static void doTest() {
        MultiRequestMockSameEndpoint responses = new MultiRequestMockSameEndpoint(new List<String>{
                int_environment_query_response, uat_environment_query_response
        });
        Test.setMock(HttpCalloutMock.class, responses);

        List<UnlockedPackage__c> packages = new List<UnlockedPackage__c>();
        packages.add(new UnlockedPackage__c(
                Name = 'test-package-1',
                SubscriberPackageId__c = '0332o000000TyICAA0')
        );
        packages.add(new UnlockedPackage__c(
                Name = 'test-package-2',
                SubscriberPackageId__c = '0332o000000TyIHAA0')
        );
        packages.add(new UnlockedPackage__c(
                Name = 'test-package-3',
                SubscriberPackageId__c = '0332o000000XXXXXXX') // Doesn't exist in mock response
        );
        insert packages;

        List<Environment__c> environments = new List<Environment__c>();
        environments.add(new Environment__c(
                Name = 'Integration Sandbox',
                NamedCredential__c = 'INT',
                SortOrder__c = 0
        ));
        environments.add(new Environment__c(
                Name = 'UAT Sandbox',
                NamedCredential__c = 'UAT',
                SortOrder__c = 1
        ));
        insert environments;

        Test.startTest();
        Map<Id, Environment__c> environmentsById = new Map<Id, Environment__c>([SELECT Id FROM Environment__c]);
        new InstalledPackageService(environmentsById.keySet()).refreshInstalledPackages();
        Test.stopTest();

        List<InstalledPackage__c> intInstalledPackages = [SELECT Id FROM InstalledPackage__c WHERE Environment__r.Name = 'Integration Sandbox'];
        List<InstalledPackage__c> uatInstalledPackages = [SELECT Id FROM InstalledPackage__c WHERE Environment__r.Name = 'UAT Sandbox'];
        System.assertEquals(2, intInstalledPackages.size());
        System.assertEquals(1, uatInstalledPackages.size());
    }

    private static String int_environment_query_response =
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

    private static String uat_environment_query_response =
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

}