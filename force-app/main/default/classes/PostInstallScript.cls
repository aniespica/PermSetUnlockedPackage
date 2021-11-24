/**
 * @description       : 
 * @author            : Ana Cabrera
 * @group             : 
 * @last modified on  : 11-24-2021
 * @last modified by  : Ana Cabrera
**/
global with sharing class PostInstallScript implements InstallHandler {
    global PostInstallScript() {}
    global void onInstall(InstallContext context) {
        createDemoData();
    }

    static void deleteDemoData() {
        Database.delete([SELECT Id FROM Pokemon__c]);
        Database.delete([SELECT Id FROM Type__c]);
        Database.delete([SELECT Id FROM Weakness__c]);
    }

    static void createDemoData() {
        new LoadData(Pokemon__c.SObjectType,'PokemonData');
        new LoadData(Type__c.SObjectType,'PokemonTypeData');
        new LoadData(Weakness__c.SObjectType,'PokemonWeaknessData');
    }
}
