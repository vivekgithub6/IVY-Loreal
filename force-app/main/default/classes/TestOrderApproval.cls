@isTest
public class TestOrderApproval {
public static testmethod void test1()
{
    set<Id> OrderIds = new set<Id>();
    List<Id> getSignatureLink = new List<Id>();
    List<String> imageUrlSet = new List<String>();
    OrderApprovalQueuable o = new OrderApprovalQueuable( OrderIds, getSignatureLink, imageUrlSet);
	system.enqueueJob(o);
    
}
}