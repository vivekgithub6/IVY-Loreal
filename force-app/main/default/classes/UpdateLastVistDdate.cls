/*
 * Block comments with details of changes
 */
public class UpdateLastVistDdate
{
    public static void UpdateLastVistDdate(list<ivybase__Visit__c> visitList)
    {
        map<id,date> salonVistDateMap = new Map<id,date>();
        for(ivybase__Visit__c vists:visitList ){
            if(vists.ivybase__Store__c!=null && vists.Market_ISO__c=='JPN'){
                salonVistDateMap.put(vists.ivybase__Store__c,vists.ivybase__Visit_Date__c);
            }//if close
        }//for close
        List<account> getsalons = new list<Account>();
        if(salonVistDateMap!=null){//if 2 satrted
            getsalons= [select id,Last_Vist_Date__c from account where id IN:salonVistDateMap.keyset() ];
        }//if 2 closed
        list<account> updatesalons= new list<account>();
        if(getsalons.size()>0){
            for(Account act :getsalons){
                if(salonVistDateMap!=null && salonVistDateMap.containskey(act.id) && salonVistDateMap.get(act.id)!=null){
                  act.Last_Vist_Date__c=salonVistDateMap.get(act.id);
                   updatesalons.add(act); 
                }
            }
            if(updatesalons.size()>0){
                update updatesalons;
            }
        }
    }//method close
}