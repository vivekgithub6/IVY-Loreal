global with sharing class ConversionUtility {
    //string to int
    global static Integer StringToInteger(String Str)
    {
        if(Pattern.matches('(\\+|\\-){0,1}[0-9]+',Str))
        {
            Integer result=Integer.valueOf(Str);
            system.debug(Str+'true');
            return result;
        }
        else
        {
            system.debug('false');
            return null;
        }
        
    }
    global static boolean IsInteger(String Str)
    {
        if(Pattern.matches('(\\+|\\-){0,1}[0-9]+',Str))
        {
            
            return true;
        }
        else
        {
            
            return false;
        }
        
    }
    global static boolean IsDecimal(String Str)
    {
        if(Pattern.matches('(\\+|\\-){0,1}([0-9]+)(.([0-9]{0,2})){0,1}',Str))
        {
            
            return true;
        }
        else
        {
            return false;
        }
        
    }
    global static Decimal StringToDecimal(String Str)
    {
		if(Pattern.matches('(\\+|\\-){0,1}([0-9]+)(.([0-9]{0,2})){0,1}',Str))
        {
            Decimal result=Decimal.valueOf(Str);
            system.debug(Str+'true');
            return result;
        }
        else
        {
            system.debug('fasle');
            return null;
        }
        
    }
    
    
    global static Date StringToDateConversion(String dateStr)
    {
        if(dateStr!=null && String.isEmpty(dateStr)==false){
            // date divided by /
            if(Pattern.matches('[0-9]{4}/(0[1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)  
               || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/[0-9]{4}',dateStr) 
               || Pattern.matches('(0[1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}',dateStr)//
               || Pattern.matches('[0-9]{4}/([1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) 
               || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])/([1-9]|1[0-2])/[0-9]{4}',dateStr)
               || Pattern.matches('([1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}',dateStr)//
               || Pattern.matches('[0-9]{4}/(0[1-9]|1[0-2])/([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
               || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/[0-9]{4}',dateStr)
               || Pattern.matches('(0[1-9]|1[0-2])/([1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}',dateStr)//
               || Pattern.matches('[0-9]{4}/([1-9]|1[0-2])/([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
               || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])/([1-9]|1[0-2])/[0-9]{4}',dateStr)
               || Pattern.matches('([1-9]|1[0-2])/([1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}',dateStr)//
               || Pattern.matches('[0-9]{4}/(0[1-9]|[1-2][0-9]|3[0-1])/(0[1-9]|1[0-2])',dateStr)
               || Pattern.matches('[0-9]{4}/(0[1-9]|[1-2][0-9]|3[0-1])/([1-9]|1[0-2])',dateStr)
               || Pattern.matches('[0-9]{4}/([1-9]|[1-2][0-9]|3[0-1])/(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('[0-9]{4}/([1-9]|[1-2][0-9]|3[0-1])/([1-9]|1[0-2])',dateStr)
               || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}/(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}/([1-9]|1[0-2])',dateStr) 
               || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}/(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}/([1-9]|1[0-2])',dateStr)
               || Pattern.matches('(0[1-9]|1[0-2])/[0-9]{4}/(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)
               || Pattern.matches('([1-9]|1[0-2])/[0-9]{4}/(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)
               || Pattern.matches('(0[1-9]|1[0-2])/[0-9]{4}/([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
               || Pattern.matches('([1-9]|1[0-2])/[0-9]{4}/([1-9]|[1-2][0-9]|3[0-1])',dateStr)
              )
            {
                List<String> dateList = datestr.split('/');
                //yyyy/mm/dd
                if(Pattern.matches('[0-9]{4}/(0[1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}/([1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}/(0[1-9]|1[0-2])/([1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}/([1-9]|1[0-2])/([1-9]|[1-2][0-9]|3[0-1])',dateStr))
                {
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]));
                    return dateVal;
                }
                //mm/dd/yyyy
                else if(Pattern.matches('(0[1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}',dateStr) || Pattern.matches('([1-9]|1[0-2])/(0[1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}',dateStr) || Pattern.matches('(0[1-9]|1[0-2])/([1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}',dateStr) || Pattern.matches('([1-9]|1[0-2])/([1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[2]),Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]));
                    return dateVal;                
                }
                //dd/mm/yyyy
                else if(Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/[0-9]{4}',dateStr) || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])/([1-9]|1[0-2])/[0-9]{4}',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/[0-9]{4}',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])/([1-9]|1[0-2])/[0-9]{4}',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[2]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[0]));
                    return dateVal;
                    
                }
                //YYYY/dd/MM
                else if(Pattern.matches('[0-9]{4}/(0[1-9]|[1-2][0-9]|3[0-1])/(0[1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}/(0[1-9]|[1-2][0-9]|3[0-1])/([1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}/([1-9]|[1-2][0-9]|3[0-1])/(0[1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}/([1-9]|[1-2][0-9]|3[0-1])/([1-9]|1[0-2])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[2]),Integer.valueOf(dateList[1]));
                    return dateVal;                
                }
                //dd/YYYY/MM
                else if(Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}/(0[1-9]|1[0-2])',dateStr) || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}/([1-9]|1[0-2])',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}/(0[1-9]|1[0-2])',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])/[0-9]{4}/([1-9]|1[0-2])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]),Integer.valueOf(dateList[0]));
                    return dateVal;                
                }
                //MM/YYYY/dd
                else if(Pattern.matches('(0[1-9]|1[0-2])/[0-9]{4}/(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('([1-9]|1[0-2])/[0-9]{4}/(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('(0[1-9]|1[0-2])/[0-9]{4}/([1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('([1-9]|1[0-2])/[0-9]{4}/([1-9]|[1-2][0-9]|3[0-1])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[1]),Integer.valueOf(dateList[0]),Integer.valueOf(dateList[2]));
                    return dateVal;                
                }
                else
                {
                    return null;
                }
            }
            else if(
                Pattern.matches('[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)  
                || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])-[0-9]{4}',dateStr) 
                || Pattern.matches('(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}',dateStr)//
                || Pattern.matches('[0-9]{4}-([1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) 
                || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])-([1-9]|1[0-2])-[0-9]{4}',dateStr)
                || Pattern.matches('([1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}',dateStr)//
                || Pattern.matches('[0-9]{4}-(0[1-9]|1[0-2])-([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
                || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])-[0-9]{4}',dateStr)
                || Pattern.matches('(0[1-9]|1[0-2])-([1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}',dateStr)//
                || Pattern.matches('[0-9]{4}-([1-9]|1[0-2])-([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
                || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])-([1-9]|1[0-2])-[0-9]{4}',dateStr)
                || Pattern.matches('([1-9]|1[0-2])-([1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}',dateStr)//
                || Pattern.matches('[0-9]{4}-(0[1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])',dateStr)
               || Pattern.matches('[0-9]{4}-(0[1-9]|[1-2][0-9]|3[0-1])-([1-9]|1[0-2])',dateStr)
               || Pattern.matches('[0-9]{4}-([1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('[0-9]{4}-([1-9]|[1-2][0-9]|3[0-1])-([1-9]|1[0-2])',dateStr)
               || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}-(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}-([1-9]|1[0-2])',dateStr) 
               || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}-(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}-([1-9]|1[0-2])',dateStr)
               || Pattern.matches('(0[1-9]|1[0-2])-[0-9]{4}-(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)
               || Pattern.matches('([1-9]|1[0-2])-[0-9]{4}-(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)
               || Pattern.matches('(0[1-9]|1[0-2])-[0-9]{4}-([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
               || Pattern.matches('([1-9]|1[0-2])-[0-9]{4}-([1-9]|[1-2][0-9]|3[0-1])',dateStr)
              
            )
            {
                List<String> dateList = datestr.split('-');
                if(Pattern.matches('[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}-([1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}-(0[1-9]|1[0-2])-([1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}-([1-9]|1[0-2])-([1-9]|[1-2][0-9]|3[0-1])',dateStr))
                {
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]));
                    return dateVal;
                }
                else if(Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])-[0-9]{4}',dateStr) || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])-([1-9]|1[0-2])-[0-9]{4}',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])-[0-9]{4}',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])-([1-9]|1[0-2])-[0-9]{4}',dateStr))
                {
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[2]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[0]));
                    return dateVal;
                    
                }
                else if(Pattern.matches('(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}',dateStr) || Pattern.matches('([1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}',dateStr) || Pattern.matches('(0[1-9]|1[0-2])-([1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}',dateStr) || Pattern.matches('([1-9]|1[0-2])-([1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}',dateStr))
                {
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[2]),Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]));
                    return dateVal;                
                }
                //YYYY/dd/MM
                else if(Pattern.matches('[0-9]{4}-(0[1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}-(0[1-9]|[1-2][0-9]|3[0-1])-([1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}-([1-9]|[1-2][0-9]|3[0-1])-(0[1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}-([1-9]|[1-2][0-9]|3[0-1])-([1-9]|1[0-2])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[2]),Integer.valueOf(dateList[1]));
                    return dateVal;                
                }
                //dd/YYYY/MM
                else if(Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}-(0[1-9]|1[0-2])',dateStr) || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}-([1-9]|1[0-2])',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}-(0[1-9]|1[0-2])',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1])-[0-9]{4}-([1-9]|1[0-2])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]),Integer.valueOf(dateList[0]));
                    return dateVal;                
                }
                //MM/YYYY/dd
                else if(Pattern.matches('(0[1-9]|1[0-2])-[0-9]{4}-(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('([1-9]|1[0-2])-[0-9]{4}-(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('(0[1-9]|1[0-2])-[0-9]{4}-([1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('([1-9]|1[0-2])-[0-9]{4}-([1-9]|[1-2][0-9]|3[0-1])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[1]),Integer.valueOf(dateList[0]),Integer.valueOf(dateList[2]));
                    return dateVal;                
                }
                else
                {
                    return null;
                }
            }
            else if(
                Pattern.matches('[0-9]{4}.(0[1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)  
                || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2]).[0-9]{4}',dateStr) 
                || Pattern.matches('(0[1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}',dateStr)//
                || Pattern.matches('[0-9]{4}.([1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) 
                || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1]).([1-9]|1[0-2]).[0-9]{4}',dateStr)
                || Pattern.matches('([1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}',dateStr)//
                || Pattern.matches('[0-9]{4}.(0[1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
                || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2]).[0-9]{4}',dateStr)
                || Pattern.matches('(0[1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}',dateStr)//
                || Pattern.matches('[0-9]{4}.([1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
                || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1]).([1-9]|1[0-2]).[0-9]{4}',dateStr)
                || Pattern.matches('([1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}',dateStr)//
                || Pattern.matches('[0-9]{4}.(0[1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2])',dateStr)
               || Pattern.matches('[0-9]{4}.(0[1-9]|[1-2][0-9]|3[0-1]).([1-9]|1[0-2])',dateStr)
               || Pattern.matches('[0-9]{4}.([1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('[0-9]{4}.([1-9]|[1-2][0-9]|3[0-1]).([1-9]|1[0-2])',dateStr)
               || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}.(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}.([1-9]|1[0-2])',dateStr) 
               || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}.(0[1-9]|1[0-2])',dateStr) 
               || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}.([1-9]|1[0-2])',dateStr)
               || Pattern.matches('(0[1-9]|1[0-2]).[0-9]{4}.(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)
               || Pattern.matches('([1-9]|1[0-2]).[0-9]{4}.(0[1-9]|[1-2][0-9]|3[0-1])',dateStr)
               || Pattern.matches('(0[1-9]|1[0-2]).[0-9]{4}.([1-9]|[1-2][0-9]|3[0-1])',dateStr) 
               || Pattern.matches('([1-9]|1[0-2]).[0-9]{4}.([1-9]|[1-2][0-9]|3[0-1])',dateStr)
              
            )
            {
                List<String> dateList = datestr.split('\\.');
                if(Pattern.matches('[0-9]{4}.(0[1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}.([1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}.(0[1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('[0-9]{4}.([1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1])',dateStr))
                {
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]));
                    return dateVal;
                }
                else if(Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2]).[0-9]{4}',dateStr) || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1]).([1-9]|1[0-2]).[0-9]{4}',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2]).[0-9]{4}',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1]).([1-9]|1[0-2]).[0-9]{4}',dateStr))
                {
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[2]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[0]));
                    return dateVal;
                    
                }
                else if(Pattern.matches('(0[1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}',dateStr) || Pattern.matches('([1-9]|1[0-2]).(0[1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}',dateStr) || Pattern.matches('(0[1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}',dateStr) || Pattern.matches('([1-9]|1[0-2]).([1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}',dateStr))
                {
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[2]),Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]));
                    return dateVal;                
                }
                //YYYY/dd/MM
                else if(Pattern.matches('[0-9]{4}.(0[1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}.(0[1-9]|[1-2][0-9]|3[0-1]).([1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}.([1-9]|[1-2][0-9]|3[0-1]).(0[1-9]|1[0-2])',dateStr) || Pattern.matches('[0-9]{4}.([1-9]|[1-2][0-9]|3[0-1]).([1-9]|1[0-2])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[2]),Integer.valueOf(dateList[1]));
                    return dateVal;                
                }
                //dd/YYYY/MM
                else if(Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}.(0[1-9]|1[0-2])',dateStr) || Pattern.matches('(0[1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}.([1-9]|1[0-2])',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}.(0[1-9]|1[0-2])',dateStr) || Pattern.matches('([1-9]|[1-2][0-9]|3[0-1]).[0-9]{4}.([1-9]|1[0-2])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]),Integer.valueOf(dateList[0]));
                    return dateVal;                
                }
                //MM/YYYY/dd
                else if(Pattern.matches('(0[1-9]|1[0-2]).[0-9]{4}.(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('([1-9]|1[0-2]).[0-9]{4}.(0[1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('(0[1-9]|1[0-2]).[0-9]{4}.([1-9]|[1-2][0-9]|3[0-1])',dateStr) || Pattern.matches('([1-9]|1[0-2]).[0-9]{4}.([1-9]|[1-2][0-9]|3[0-1])',dateStr))
                {
                    
                    //year , month, day
                    Date dateVal= Date.newInstance(Integer.valueOf(dateList[1]),Integer.valueOf(dateList[0]),Integer.valueOf(dateList[2]));
                    return dateVal;                
                }
                else
                {
                    return null;
                }
            }
            else
            {
                return null;
            }
        }
        else
        {
            return null;
        }
    }
    
}