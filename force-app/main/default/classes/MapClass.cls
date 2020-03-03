public class MapClass {
    public static Set<Id> getSetOfValue_From_Map_With_Matching_Key( Map<Id,Set<Id>> recMap,Set<Id> Key)
    {
        Set<Id> SetOfValue = new Set<Id>();
        if(Key!=null && key.size()>0){
            for(Id k:key)
            {
                if(recMap.containsKey(k))
                {
                    SetOfValue.addAll(recMap.get(k)); 
                }
            }
            if(SetOfValue.size()>0)
            {
                return SetOfValue;
            }}

        return null;

    }
    public static Set<Id> getSetOfValue_From_Map_With_Matching_Key(Map<Id,Id> recMap,Set<Id> Key)
    {
        if(Key!=null && Key.size()>0){
            Set<Id> SetOfValue = new Set<Id>();
            for(Id k:key)
            {
                if(recMap.containsKey(k))
                {
                    SetOfValue.add(recMap.get(k)); 
                }
            }
            if(SetOfValue.size()>0)
            {
                return SetOfValue;
            }
        }

        return null;


    }
    public static Set<Id> getSetOfKey_From_Map_With_Matching_Value(Map<Id,Id> recMap,Set<Id> Value)
    {
        if(Value!=null && Value.size()>0){
            Set<Id> SetOfKey = new Set<Id>();
            
                for(Id k:recMap.keySet())
                {
                 if(Value.contains(recMap.get(k)))
                 {
                     SetOfKey.add(k);
                 } 
                }
            if(SetOfKey.size()>0)
            {
                return SetOfKey;
            }
        }

        return null;


    }
    public static Set<Id> getSetOfKey_From_Map_With_Matching_Value(Map<Id,Set<Id>> recMap,Id Value)
    {
        if(Value!=null){
            Set<Id> returnedKey = new Set<Id>();
            for(Id key:recMap.keySet())
            {

                if(recMap.get(key).contains(Value))
                {
                    returnedKey.add(key);
                }

            }
            if(returnedKey.Size()>0){
                return returnedKey;  
            }
        }

        return null;
    }
    public static Id getkeyfromMapwithValue(Map<Id,Set<Id>> recMap,Id Value)
    {
        if(Value!=null){
            for(Id key:recMap.keySet())
            {
                if(recMap.get(key).contains(Value))
                {
                    return key;
                }
            }
        }
        return null;
    }

    public static Id getkeyfromMapwithValue(Map<Id,Id> recMap,Id Value)
    {
        if(Value!=null){
            String v = String.valueOf(Value);
            for(Id key:recMap.keySet())
            {
                if(String.valueOf(recMap.get(key)).equalsIgnoreCase(v))
                {
                    return key;
                }
            }
        }
        return null;
    }
    public static Set<Id> getSetOfkeyfromMapwithValueMatchingWithOurValueSet(Map<Id,Set<Id>> recMap,Set<Id> Value)
    {
        if(Value!=null && Value.size()>0){
            Set<Id> SetOfKey = new Set<Id>();
            for(Id v:Value){
                for(Id key:recMap.keySet())
                {
                    if(recMap.get(key).contains(v))
                    {
                        system.debug(key);
                        SetOfKey.add(key);
                    }  
                }
            }
            return SetOfKey;
        }

        return null;

    }



}