public class DreamListService {
    //Routes related accounts
    public static list<Account> getDreamList(id ResourceId){
        List<Account> dreamListAccounts = new List<Account>();
        List< Account > accRouteList = AccountService.getAllRetailerMaster_List_from_Route();
        System.debug('Accounts:::'+accRouteList);
        for(Account acc : accRouteList ){
            if(acc.Is_Dream_List__c == true){
                dreamListAccounts.add(acc);
            }
        }
        System.debug('dreamListAccounts::'+dreamListAccounts);
        return dreamListAccounts;
    }
    //Resource related accounts
       public static list<Account> getConquest(){
        List<Account> ConquestList = new List<Account>();
        List< Account > accList = AccountService.getAllRetailerMaster_List_for_Resource();
        System.debug('Conqyests:::'+accList);
        for(Account acc : accList ){
            if(acc.Is_Conquest__c == true){
                ConquestList.add(acc);
            }
        }
        return ConquestList;
    }

}