public with sharing class LeadTriggerHandler {
    
    // コンストラクタ
    public LeadTriggerHandler() {

    }

    // オプトアウト日自動更新
    public static void handleOptOutProcess(List<SObject> newRecords, Map<Id, SObject> oldMap) {
        for (SObject sobj : newRecords) {
            Boolean isOptOut = (Boolean)sobj.get('isOptOut__c');
            Date optOutDate = (Date)sobj.get('optOutDate__c');

            if (isOptOut == false || optOutDate != null) {
                sobj.put('lastUpdateType__c', 'optOut');
            }

            // oldMap がある場合のみ update 時の処理を実行
            if (oldMap != null && oldMap.containsKey((Id)sobj.get('Id'))) {
                SObject oldSobj = oldMap.get((Id)sobj.get('Id'));
                String newAlias = ((User)sobj.getSObject('LastModifiedBy')).Alias;
                String oldAlias = ((User)oldSobj.getSObject('LastModifiedBy')).Alias;

                if (newAlias == 'IT推進部' && isOptOut == true && newAlias != oldAlias) {
                    sobj.put('lastUpdateType__c', 'optOut IT');
                }
            }
        }
    }

    // beforeInsert 用：引数が oldMap なし
    public static void handleOptOutProcess(List<SObject> newRecords) {
        handleOptOutProcess(newRecords, null);
    } 
}
