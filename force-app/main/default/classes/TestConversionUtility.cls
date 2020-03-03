@isTest
public with sharing class TestConversionUtility {
    static testMethod void IntegerConversion() {
		system.assertEquals(true,ConversionUtility.IsInteger('-5'));
        system.assertEquals(true,ConversionUtility.IsInteger('0'));
    	system.assertEquals(false,ConversionUtility.IsInteger(''));
    	system.assertEquals(true,ConversionUtility.IsInteger('5'));
    	system.assertEquals(false,ConversionUtility.IsInteger('a'));
    	system.assertEquals(false,ConversionUtility.IsInteger('5.5'));
        system.assertEquals(false,ConversionUtility.IsInteger('5.5'));
        
        system.assertEquals(5,ConversionUtility.StringToInteger('5'));
        system.assertEquals(null,ConversionUtility.StringToInteger('5.'));
        system.assertEquals(-5,ConversionUtility.StringToInteger('-5'));
		system.assertEquals(null,ConversionUtility.StringToInteger('5.5'));
        system.assertEquals(null,ConversionUtility.StringToInteger('a'));
        system.assertEquals(null,ConversionUtility.StringToInteger('5.0'));
    }
    static testMethod void DecimalConversion() {
		system.assertEquals(true,ConversionUtility.IsDecimal('-5.5'));
        system.assertEquals(true,ConversionUtility.IsDecimal('0'));
    	system.assertEquals(true,ConversionUtility.IsDecimal('5.5'));
    	system.assertEquals(true,ConversionUtility.IsDecimal('5'));
    	system.assertEquals(false,ConversionUtility.IsDecimal('a'));
    	system.assertEquals(false,ConversionUtility.IsDecimal('5.5555'));
        
        
        system.assertEquals(5.55,ConversionUtility.StringToDecimal('5.55'));
        system.assertEquals(5,ConversionUtility.StringToDecimal('5.'));
        system.assertEquals(5,ConversionUtility.StringToDecimal('5'));
        system.assertEquals(null,ConversionUtility.StringToDecimal('aa'));
        system.assertEquals(null,ConversionUtility.StringToDecimal('5.555'));
        
        
    }
    
    static testMethod void dateConversion() { 
        //invalid
        system.assertEquals(null,ConversionUtility.StringToDateConversion('5454'));
                system.assertEquals(null,ConversionUtility.StringToDateConversion(''));
        Date d = Date.newInstance(1996,2,1);
        //year-month-day
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/02/01'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/2/01'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/02/1'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/2/1'));
         d = Date.newInstance(1996,12,25);
        // day-month-year
       system.assertEquals(d,ConversionUtility.StringToDateConversion('25/12/1996'));
		
        d = Date.newInstance(1996,2,19);
        //month-day-year
		system.assertEquals(d,ConversionUtility.StringToDateConversion('02/19/1996'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('2/19/1996'));
		//null
        system.assertEquals(null,ConversionUtility.StringToDateConversion('19/19/1996'));
        system.assertEquals(null,ConversionUtility.StringToDateConversion('19/00/1996'));  
        
        //year-day-month
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/19/02'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/19/02'));
        d=date.newInstance(1996,02,04);
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/02/04'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/2/04'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/02/4'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996/2/4'));
        
        d=date.newInstance(1996,02,04);
        system.assertEquals(d,ConversionUtility.StringToDateConversion('04/1996/02'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('4/1996/2'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('04/1996/2'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('4/1996/02'));
        
        d=date.newInstance(1996,02,19);
        system.assertEquals(d,ConversionUtility.StringToDateConversion('02/1996/19'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('02/1996/19'));        
        system.assertEquals(null,ConversionUtility.StringToDateConversion('33/1996/19'));                
                        
        //////////////////////////////////////////////////////////////////////////////////////////
        d = Date.newInstance(1996,2,1);
        //year-month-day
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-02-01'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-2-01'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-02-1'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-2-1'));
        
        // day-month-year
        system.assertEquals(d,ConversionUtility.StringToDateConversion('01-02-1996'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1-2-1996'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('01-2-1996'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1-02-1996'));
        
        d = Date.newInstance(1996,2,19);
        //month-day-year
		system.assertEquals(d,ConversionUtility.StringToDateConversion('02-19-1996'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('2-19-1996'));
		//null
        system.assertEquals(null,ConversionUtility.StringToDateConversion('19-19-1996'));
        system.assertEquals(null,ConversionUtility.StringToDateConversion('19-00-1996'));  
        
        //year-day-month
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-19-02'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-19-02'));
        d=date.newInstance(1996,02,04);
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-02-04'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-2-04'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-02-4'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996-2-4'));
        
        d=date.newInstance(1996,02,04);
        system.assertEquals(d,ConversionUtility.StringToDateConversion('04-1996-02'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('4-1996-2'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('04-1996-2'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('4-1996-02'));
        
        //mm-yyyy-dd
        d=date.newInstance(1996,02,19);

        system.assertEquals(d,ConversionUtility.StringToDateConversion('02-1996-19'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('02-1996-19'));        
        system.assertEquals(null,ConversionUtility.StringToDateConversion('33-1996-19'));                
                        
        
        /////////////////////////////////////////////////////////////////////////////////////////
        
        d = Date.newInstance(1996,2,1);
        //year-month-day
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.02.01'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.2.01'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.02.1'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.2.1'));
        
        // day-month-year
        system.assertEquals(d,ConversionUtility.StringToDateConversion('01.02.1996'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1.2.1996'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('01.2.1996'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1.02.1996'));
        
        d = Date.newInstance(1996,2,19);
        //month-day-year
		system.assertEquals(d,ConversionUtility.StringToDateConversion('02.19.1996'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('2.19.1996'));
		//null
        system.assertEquals(null,ConversionUtility.StringToDateConversion('19.19.1996'));
        system.assertEquals(null,ConversionUtility.StringToDateConversion('19.00.1996'));  
        
        //year-day-month
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.19.02'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.19.02'));
        d=date.newInstance(1996,02,04);
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.02.04'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.2.04'));
		system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.02.4'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('1996.2.4'));
        
        d=date.newInstance(1996,02,04);
        system.assertEquals(d,ConversionUtility.StringToDateConversion('04.1996.02'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('4.1996.2'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('04.1996.2'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('4.1996.02'));
        
        //mm-yyyy-dd
        d=date.newInstance(1996,02,19);
        system.assertEquals(d,ConversionUtility.StringToDateConversion('02.1996.19'));
        system.assertEquals(d,ConversionUtility.StringToDateConversion('02.1996.19'));        
        system.assertEquals(null,ConversionUtility.StringToDateConversion('33.1996.19'));                
        
    }
    
}