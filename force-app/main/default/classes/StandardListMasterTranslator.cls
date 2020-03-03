public with sharing class StandardListMasterTranslator {
public static Map<String,String> getListTypeWithListId(List<ivybase__Standard_List_Master__c > stdRecList) {
      
        Map<String,String> listTypeWithListIdMap = new Map<String,String>();
        if (stdRecList != null && stdRecList.size() > 0) {
            for (ivybase__Standard_List_Master__c slm :stdRecList) {
                listTypeWithListIdMap.put(slm.ivybase__List_Name__c, slm.Name);
            }            
        }
        return listTypeWithListIdMap;
    }
    public static RExAPIResponseDomain.ResponseInfo objectToProductLevelInfo(List< ivybase__Standard_List_Master__c > prodRecList, String errorCode) {
       
        RExAPIResponseDomain.ResponseInfo prodList = new RExAPIResponseDomain.ResponseInfo();
        prodList.Master = 'ProductLevel';
        prodList.Field = new List<String> {'LevelId','LevelName','ParentId','Sequence'};
        if(prodRecList != null && errorCode == null) {
            Map<String, Integer> productSequence = getRecordIdwithSeqNumber(prodRecList);
            prodList.Data = objectToProdInfo(prodRecList, productSequence );
        } else {
            prodList.Data = new List<List<String>>();
        }
        prodList.ErrorCode = errorCode == null ? '0' : errorCode; 
        prodList.Next = '0';
        return prodList;
    }
    public static Map<String,Integer> getRecordIdwithSeqNumber(List<ivybase__Standard_List_Master__c> channelRecList) {
       
        Map<String, String> parentIdwithChildMap = new Map<String,String>();
        Map<String, Integer> recordIdwithSequenceNumber = new Map<String, Integer>();
        
        for (ivybase__Standard_List_Master__c channel :channelRecList) {
            
            if (channel.ivybase__Parent_Id__c != null) {
                parentIdwithChildMap.put(channel.ivybase__Parent_Id__c,channel.Id);
            } else if (channel.ivybase__Parent_Id__c == null) {
                parentIdwithChildMap.put('EmptyParent',channel.Id);
            }               
        }
        String tempParentId = 'EmptyParent';
        Integer seq = 1;
        for (Integer i = 0; i < parentIdwithChildMap.size(); i++) {
            if (parentIdwithChildMap.ContainsKey(tempParentId)) {
                recordIdwithSequenceNumber.put(parentIdwithChildMap.get(tempParentId), seq);
                tempParentId = parentIdwithChildMap.get(tempParentId);
                seq++;
            }
        }
        return recordIdwithSequenceNumber;
    }
    public static List<List<String>> objectToProdInfo(List<ivybase__Standard_List_Master__c> prodList, Map<String, Integer> prodSequence ) {
        Map<integer, List<String>> squenceWithProductOrder = new Map<integer, List<String>>();
        List<List<String>> prodTempList = new List<List<String>>();
        
        List<List<String>> productLevelList = new List<List<String>>();
        
        for (ivybase__Standard_List_Master__c prod :prodList) {
            List<String> prodTemp = new List<String>();
            prodTemp.add(prod.Name);//id
            prodTemp.add(prod.ivybase__List_Name__c);//name
            if(prod.ivybase__Parent_Id__c != NULL) {
                prodTemp.add(prod.ivybase__Parent_Id__r.Name);//Parentid
            } else {
                prodTemp.add('0');//Parentid blank
            }
            if (prodSequence  != null && prodSequence.size() > 0 && prodSequence.containsKey(prod.Id)) {
                prodTemp.add(String.valueOf(prodSequence.get(prod.Id)));//Sequence
                squenceWithProductOrder.put(prodSequence.get(prod.Id), prodTemp);
            } else {
                prodTemp.add('');//Sequence
                prodTempList.add(prodTemp);
            }
        }
        if (prodTempList.size() > 0) {
            productLevelList.addAll(prodTempList);
        }
        if (squenceWithProductOrder.size() > 0) {
            List<Integer> sequenceNumber = new List<Integer>();
            sequenceNumber.addAll(squenceWithProductOrder.keySet());
            sequenceNumber.sort();
            for (Integer keyV :sequenceNumber) {
                productLevelList.add(squenceWithProductOrder.get(keyV));
            }
        }
        return productLevelList;
    }
}