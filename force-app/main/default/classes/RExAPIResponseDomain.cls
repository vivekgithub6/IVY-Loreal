global with sharing class RExAPIResponseDomain {
    
    global class MultipleResponseInfo {
        global List<ResponseInfo> Tables;        
    }
    
    global class ResponseInfo {
        global String Master;
        global List<String> Field; 
        global List<List<String>> Data;
        global String ErrorCode;
        global String Next;
    }
}