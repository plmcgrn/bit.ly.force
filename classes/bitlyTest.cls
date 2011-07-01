@isTest
private class bitlyTest {

    static testMethod void testShorten() {
        bitly b = new bitly();
        bitly.shorturl s = b.shorten('http://www.test.com');
    }
    
    static testMethod void testClasses(){
    	bitly.shorturl s = new bitly.shorturl();
    	bitly.longurl l = new bitly.longurl();
    }
    
    static testMethod void testParseShortUrlResponse(){
    	string xml = '<response><status_code>200</status_code><status_txt>OK</status_txt><data><url>http://bit.ly/dBPR4i</url><hash>dBPR4i</hash><global_hash>1YUB9H</global_hash><long_url>http://www.test.com</long_url><new_hash>0</new_hash></data></response>';
    	dom.document d = new dom.document();
    	d.load(xml);
    	bitly.shorturl s = bitly.parseShortUrlResponse(d);    	
    }
    
    static testMethod void testSettings(){
    	bitly__c b = bitly__c.getInstance();
    	bitly bit = new bitly();
    	
    	if(b == null){
    		bitly__c bl = new bitly__c();
    		bl.apikey__c = 'test';
    		bl.login__c = 'test';
    		insert bl;
	    	bitly.shorturl s = bit.shorten('http://test.com');    		
    	}else{
    		delete b;    		
		   	bitly.shorturl s = bit.shorten('http://test.com');    		
    	}    	
    }
}