global class PostResponse {
    global PostResponse(){
        responseList=new List<PostResponseObject>();
    }
    global PostResponseObject[] responseList;
    global class PostResponseObject{
        global String Response;
        global String ErrorMsg;
        global PostResponseObject(String resp,String Error){
            Response=resp;
            ErrorMsg=Error;
        }
        global PostResponseObject(){
            
        }
    }
}