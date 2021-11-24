/**
 * @description       : 
 * @author            : Ana Cabrera
 * @group             : 
 * @last modified on  : 11-24-2021
 * @last modified by  : Ana Cabrera
**/
@isTest
public with sharing class PostInstallScriptTest {
    @isTest
    static void createDemoDataTest() {
        Test.startTest();
        (new PostInstallScript()).onInstall(null);
        Test.stopTest();
        System.assertEquals(151, [SELECT COUNT() FROM Pokemon__c]);
        System.assertEquals(213, [SELECT COUNT() FROM Type__c]);
        System.assertEquals(452, [SELECT COUNT() FROM Weakness__c]);
    }
}
