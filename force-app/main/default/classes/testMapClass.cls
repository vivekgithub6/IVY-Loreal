@isTest
public class testMapClass {
    private static testMethod void testmap1(){
        MapClass.getSetOfValue_From_Map_With_Matching_Key(new Map<Id,Set<Id>>(),new Set<Id>());
        MapClass.getSetOfValue_From_Map_With_Matching_Key(new Map<Id,Set<Id>>(),null);
        MapClass.getSetOfValue_From_Map_With_Matching_Key(new Map<Id,Id>(),new Set<Id>());
        MapClass.getSetOfValue_From_Map_With_Matching_Key(new Map<Id,Id>(),null);
        MapClass.getSetOfKey_From_Map_With_Matching_Value(new Map<Id,Id>(),new Set<Id>());
        MapClass.getSetOfKey_From_Map_With_Matching_Value(new Map<Id,Id>(),null);
        MapClass.getSetOfKey_From_Map_With_Matching_Value(new Map<Id,Set<Id>>(),Id.valueOf('0016F00002QYQ3wQAH'));
        MapClass.getSetOfKey_From_Map_With_Matching_Value(new Map<Id,Set<Id>>(),null);
        MapClass.getkeyfromMapwithValue(new Map<Id,Set<Id>>(),Id.valueOf('0016F00002QYQ3wQAH'));
        MapClass.getkeyfromMapwithValue(new Map<Id,Set<Id>>(),null);
        MapClass.getkeyfromMapwithValue(new Map<Id,Id>(),Id.valueOf('0016F00002QYQ3wQAH'));
        MapClass.getkeyfromMapwithValue(new Map<Id,Id>(),null);
        MapClass.getSetOfkeyfromMapwithValueMatchingWithOurValueSet(new Map<Id,Set<Id>>(),new Set<Id>());
        MapClass.getSetOfkeyfromMapwithValueMatchingWithOurValueSet(new Map<Id,Set<Id>>(),null);
    }

}