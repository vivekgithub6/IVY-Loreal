public with sharing class EncodingAndDecodingUtil {
    
    public static String encodeString(String encoding){
        
        String encodedString;
        if(String.isNotBlank(encoding)){
        
            encodedString = EncodingUtil.urlEncode(encoding, 'UTF-8');
        }
        return encodedString;
    }
    
    public static String decodeString(String decoding){
        
        String decodedString;
        if(String.isNotBlank(decoding)){
            
            decodedString = EncodingUtil.urlDecode(decoding, 'UTF-8');
        }
       return decodedString;
    }
}