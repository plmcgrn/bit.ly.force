public with sharing class BitlyWidgetCon {

private string url;
private bitly b = new bitly();

public string getUrl(){return url;}
public void setUrl(string url){this.url = url;}

public pagereference shorten(){
	try{
	bitly.shorturl s = b.shorten(geturl());
	seturl(s.url);
	}catch (exception e){		
		ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
		ApexPages.addMessage(msg);
		System.Debug(LoggingLevel.DEBUG,e);
	}	
	return null;
}
}