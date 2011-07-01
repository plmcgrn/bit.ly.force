global class bitly {
public class BitlyException extends Exception {}

	static final string apiurl = 'http://api.bit.ly';
	static final string format = 'xml';

	/* container object for a shorturl (api response) */
	global class shorturl{
		global integer newhash {get; set;}
		global string url {get; set;}
		global string hash {get; set;}
		global string global_hash {get; set;}
		global string long_url {get; set;} 
	}
	
	/* container object for a longurl (api response) */
	Global class longurl{
		global string short_url {get; set;}
		global string hash {get; set;}
		global string user_hash {get; set;}
		global string global_hash {get; set;}
		global string error {get; set;}
		global string long_url {get; set;}
	}

	/* helper method for sending http requests */
	private static httpresponse sendRequest(httprequest req){
		http h = new http();
		return h.send(req);
	}
	
	/* helper method for building API requests */
	private static httprequest buildRequest(string endpoint){
		bitly__c btly = bitly__c.getInstance();
		string apikey = 'R_5a5ed25ce8fcf45c058c87cbaf661d8d';
		string login = 'bitlyforce';
		
		if(btly != null){		
			string x_apikey = btly.apikey__c;
			string x_login = btly.login__c;
			endpoint += '&x_login=' + x_login + '&x_apikey=' + x_apikey;			
		}
		endpoint += '&format=xml&login=' + login + '&apikey=' + apikey;
		
		
		
		httprequest req = new httprequest();
		req.setEndpoint(apiurl + endpoint + '&format=xml&login=' + login + '&apikey=' + apikey);
		req.setMethod('GET');
		return req;		
	}

	/* helper method for URL Encoding strings */
	private static string encode(string toencode){
		return encodingutil.urlEncode(toEncode, 'UTF-8');
	}
	
	/* main method for getting a shortend URL from the bit.ly API */
	global shorturl shorten(string longurl){
		longurl = encode(longurl);	
		
		httprequest req = buildRequest('/v3/shorten?longurl=' + longurl);
		
		httpresponse res = sendRequest(req);
		if(res.getStatusCode() != 200)
			throw new BitlyException('Error shortening url: ' + res.getBody());
		
		system.debug(LoggingLevel.DEBUG,'shorten response: ' + res.getBody());
		return parseShortUrlResponse(res.getBodyDocument());
	}

	/* helper method to convert the API response into a runtime shorturl object */
	public static shorturl parseShortUrlResponse(dom.document doc){
		Dom.XMLNode root = doc.getRootElement();
		
		Dom.XMLNode[] attributes = root.getChildren();
		shorturl s = new shorturl();
		string name = '';
		string text = '';
		for(dom.xmlnode x : attributes){
			if(x.getName() == 'data'){
				List<Dom.XMLNode> dlist = x.getChildren();
				for(dom.xmlnode y : dlist){
					name = y.getName();
					text = y.getText();
					if(name == 'url')
						s.url = text;
					if(name == 'hash')
						s.hash = text;
					if(name == 'global_hash')
						s.global_hash = text;
					if(name == 'long_url')
						s.long_url = text;
					if(name == 'new_hash')
						s.newhash = integer.valueOf(text);
				}			
			}	
		}
		return s;
	}
}