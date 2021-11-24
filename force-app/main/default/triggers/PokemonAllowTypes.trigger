/**
 * @description       : 
 * @author            : Ana Cabrera
 * @group             : 
 * @last modified on  : 11-24-2021
 * @last modified by  : Ana Cabrera
**/
trigger PokemonAllowTypes on Type__c (before insert) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            Set<String> pokeType = Pokemon_Type__mdt.getAll().keySet();

            for (Type__c type : Trigger.new) {
                System.assert(pokeType.contains(type.Name),'Pokemon type does not exist');
            }
        }
    }

}