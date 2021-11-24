/**
 * @description       : 
 * @author            : Ana Cabrera
 * @group             : 
 * @last modified on  : 11-24-2021
 * @last modified by  : Ana Cabrera
**/
public with sharing class LoadData {

    public Blob csvFileBody;
    public string csvAsString;
    public String[] csvFileLines;
    public List<account> acclist;

    public LoadData(SObjectType sfobject, String csvName) {
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = :csvName LIMIT 1];
        String body = sr.Body.toString();
        String[] rows = body.split('\n');
        SObjectField[] fields = sfobject.getDescribe().fields.getMap().values();
        String[] columns = rows[0].split(',');
        String[] objFields = new String[]{};
        Map<Integer,String[]> referenceByIndex = new Map<Integer,String[]>();
        Map<String,SObjectType> sobjectByName = new Map<String,SObjectType>();
        for (String column : columns) {
            String fieldName;
            for (SObjectField field : fields) {
                DescribeFieldResult result = field.getDescribe();
                if (result.getLabel() == column) {
                    fieldName = result.getName();
                    break;
                } else if (result.getReferenceTo().size() > 0) {
                    try {
                        SObjectType[] references = result.getReferenceTo();
                        SObjectField[] rfields = references[0].getDescribe().fields.getMap().values();
                        for (SObjectField rfield : rfields) {
                            DescribeFieldResult rResult = rfield.getDescribe();
                            if (rResult.getLabel() == column) {
                                fieldName = result.getRelationshipName();
                                referenceByIndex.put(objFields.size(), new String[]{references[0].getDescribe().getName(),rResult.getName()});
                                sobjectByName.put(references[0].getDescribe().getName(), references[0]);
                                break;
                            }
                        }

                        if (fieldName != null) {
                            break;
                        } 
                    } catch (Exception e ) {
                        System.debug(result.getName());
                        System.debug(result.getReferenceTo());
                    } 
                    
                }
            }
            objFields.add(fieldName);
        }
        
        SObject[] records = new SObject[]{};
        for (Integer i=1; i < rows.size(); i++) {
            Sobject record = sfobject.newSObject();
            String[] values = rows[i].split(',');
            for (Integer j=0; j < objFields.size(); j++) {
                if (objFields[j] != null) {
                    try {
                        String[] reference = referenceByIndex.get(j);
                        if (reference != null) {
                            SObject refRecord = sobjectByName.get(reference[0]).newSObject();
                            refRecord.put(reference[1], values[j]);
                            record.putSObject(objFields[j],refRecord);
                        } else {
                            record.put(objFields[j], values[j]);
                        }
                    } catch (Exception e) {
                        System.debug(LoggingLevel.ERROR,e);
                        System.debug(objFields[j]);
                        System.debug(values[j]);
                    }
                }
            }

            records.add(record);
        }

        try {
            Database.insert(records);
        } catch (Exception e) {
            System.debug(e);
        }

    }
}
