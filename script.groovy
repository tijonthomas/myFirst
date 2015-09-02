http://www.soapui.org/scripting---properties/tips---tricks.html

testRunner.testCase.testSuite.setPropertyValue("currentYear",Integer.toString(Calendar.getInstance().get(Calendar.YEAR)))

def domain=projectRunner.getProject().getPropertyValue("domain")
projectRunner.getProject().setPropertyValue("endpoint","http://services."+domain+".fds.com")


import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
boolean flag=true;
def node = holder.getNodeValues( "//*:Response/*:shippingContactMapper/*:e/*:shippingContact/*:address/*:contactid" )
def variable = context.expand('${#TestSuite#contactId0}');
log.info variable;
assert !Arrays.asList(node).contains(context.expand('${#TestSuite#contactId0}'));
//log.info flag
//if(flag==true){
//assert node != null	
//}

def temp = testRunner.testCase.testSuite.getPropertyValue("refcatid$i")
testRunner.testCase.setPropertyValue( "refcatid", temp )
OR
testRunner.testCase.setPropertyValue( "refcatid", context.expand('${#TestSuite#refcatid'+i+'}') )

//********************** #2
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
boolean flag=true;
def node = holder.getNodeValues( "//*:Response/*:shippingContactMapper/*:e/*:shippingContact/*:address/*:contactid" )
def variable = context.expand('${#TestSuite#contactId0}');
//log.info variable;
for(i=0;i<node.length;i++){				
	if(node[i].equals(variable)){
		log.info node[i]
	flag=false;
	break;	
	}	
}
//log.info flag
if(flag==true){
assert node != null	
}

//********************** #3

import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def node = holder.getNodeValue( "//response[1]/registrantContactInfo[1]/lastName[1]" )
assert node.equalsIgnoreCase(context.expand('${#TestSuite#RLName}'))

//********************** #setPropertyValue
	
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def userid = holder.getNodeValue( "//*:Response[1]/*:userId[1]" )
messageExchange.modelItem.testStep.testCase.testSuite.setPropertyValue( "CC.UserID", userid )
assert userid != null

//********************** #genctx

def host=testRunner.testCase.testSuite.project.getPropertyValue("endpoint")
def email=context.expand('${RandomEmailGenerator#emailAddress}')
println email
URL url = null;		
// Create a URL for the desired page
url = new URL(host+"/genctx?email="+email+"&amp;password="+"test123"+"&amp;submit=Generate");
HttpURLConnection connection = (HttpURLConnection) url.openConnection();
connection.setRequestMethod("GET");

// Get the response
DataInputStream inStream = new DataInputStream(connection.getInputStream());
String respLine = "";
String responseData="";

while ((respLine = inStream.readLine()) != null)
		responseData = responseData + respLine; 

 String[] respArray = responseData.split("&lt;input type=\"submit\" name=\"submit\" value=\"Generate\" />");
 String tmp = respArray[1];
 respArray  = tmp.split("&lt;/form>");
 tmp = respArray[0];
 respArray = tmp.split("&lt;br />");
 tmp = respArray[2];
 String UserContext = tmp;	    
 return UserContext;	 
 
//********************** #TC Name
def TC = messageExchange.modelItem.testStep.testCase.name
def time = messageExchange.modelItem.testStep.testCase.getPropertyValue( "timestamp" )
def pom = messageExchange.modelItem.testStep.testCase.getPropertyValue( "pomVersion" )

def newTC = TC.substring(0,8)+' - ' + pom.substring(1,7) +' - '+ time.substring(5,17)
//log.info newTC
messageExchange.modelItem.testStep.testCase.name = newTC

//********************** # Count Check
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def node = holder.getNodeValues( "//browseCategory/products" )
def prodCount = holder.getNodeValue( "//browseCategory/totalProducts")
def count = node.size()
log.info prodCount
log.info "count"+count
if (Integer.parseInt(prodCount)<10)
{
	assert count==Integer.parseInt(prodCount)
}
else
{
	assert count==10
}

//********* OR

count( //browseCategory/products) == ${V2/catalog/category#Response#//browseCategory[1]/totalProducts[1]}

//********************** #TStep Name with SDP
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def node = holder.getNodeValue( "//error[1]/errorDetail[1]" )
if (node!=null){
def name = messageExchange.modelItem.testStep.name
if (node.contains('http://') == true)
{
	def start = node.indexOf("http://")
	def end= node.indexOf("8080/")
	def sdp = node[start..end+3]
	newName =name[0..18]+ '-'+sdp
}
messageExchange.modelItem.testStep.name=newName
}
****************************

import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def total = holder.getNodeValue( "//response[1]/totalquantity[1]" )
def quantity = holder.getNodeValues( "//response[1]/bagitems/quantity" )
def sum=0;
for(val in quantity)
{
	sum+=Integer.parseInt(val);
//	log.info val;
}
assert Integer.parseInt(total)==sum;
****************************

import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def upcids = holder.getNodeValues( "//response[1]/bagitems/upcid" )
assert Arrays.asList(upcids).contains(context.expand('${#TestSuite#upc}'))

****************************
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def upc1 = context.expand('${#TestCase#upc1}')
def node = holder.getNodeValue( "//response/bagitems[upcid="+upc1+"]/itemsequencenumber" )
messageExchange.modelItem.testStep.testCase.setPropertyValue( "seqNo1", node )


********************************************************
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def prodids = holder.getNodeValues( "//response[1]/productids[position()<=25]" )
if(prodids.size()>0){
messageExchange.modelItem.testStep.testCase.testSuite.setPropertyValue( "multi_prodids", prodids.toString().replaceAll(" ","").replace("[","").replace("]",""))
}
//log.info "From Resp:"+prodids;
//log.info "From Prop: "+context.expand('${#TestSuite#multi_prodids}')
assert prodids != null

********************************************************
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def multi_upcs = holder.getNodeValues( "//productresponse/product/upc[availableonline='true']/skuid" )
//log.info multi_upcs.toString();
for(int i=1;i<=2;i++){
messageExchange.modelItem.testStep.testCase.testSuite.setPropertyValue( "upc$i", multi_upcs[i-1])
}
assert multi_upcs != null

********************************************************
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def nodeseq = holder.getNodeValues( "//response/bagitems[isgift='true']/itemsequencenumber" )
def nodeupc = holder.getNodeValues( "//response/bagitems[isgift='true']/upcid" )

totalgift = nodeupc.size()
for (int i=0; i< totalgift;i++){	
	messageExchange.modelItem.testStep.testCase.testSuite.setPropertyValue( "giftseq$i", nodeseq[i])
	messageExchange.modelItem.testStep.testCase.testSuite.setPropertyValue( "giftupc$i", nodeupc[i])
}

assert nodeseq != null

********************************************************
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def prodids = holder.getNodeValues( "//response[1]/productids[position()<=25]" )
if(prodids.size()>0){
messageExchange.modelItem.testStep.testCase.testSuite.setPropertyValue( "multi_prodids", prodids.toString().replaceAll(" ","").replace("[","").replace("]",""))
}
//log.info "From Resp:"+prodids;
//log.info "From Prop: "+context.expand('${#TestSuite#multi_prodids}')
assert prodids != null

********************************************************
//assert Arrays.asList(node).contains('true')

import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def node = holder.getNodeValues( "//productresponse/product/upc/availableonline" )
//log.info node.toString()

for (var in node){
	if(var.toString()!='true'){
		log.info var.toString()	
		assert false
		break
	}
}
********************************************************
import com.eviware.soapui.support.XmlHolder

def storeid = context.expand('${#TestSuite#storeid}')
def prod1 = context.expand('${#TestSuite#productid}')
def prod2 = context.expand('${#TestSuite#prodVar}')
def holder = new XmlHolder( messageExchange.responseContentAsXml )
def node1 = holder.getNodeValue( "//productresponse/product[@id="+prod1+"]/upc/storeavailability[seqNum='1']/storeId" )
def node2 = holder.getNodeValue( "//productresponse/product[@id="+prod2+"]/upc/storeavailability[seqNum='1']/storeId" )

assert node1 == storeid
assert node2 == storeid

********************************************************
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
//holder.namespaces["ns2"] = "http://schemas.macys.com/definitions/ps/v3"
def overrideUrl = holder.getNodeValues( "//*:CategoryResponse//category[categorytype='GoTo']/overrideUrl" )
def overridecatid = holder.getNodeValues( "//*:CategoryResponse//category[categorytype='GoTo']/overridecatid" )

log.info overrideUrl.toString()
log.info overridecatid.toString()

assert overrideUrl != null
********************************************************
//productresponse/product[not(review_details)]/@id
********************************************************
import com.eviware.soapui.support.XmlHolder
boolean flag=true
def holder = new XmlHolder( messageExchange.responseContentAsXml )
def node = holder.getNodeValues( "//response/promotionDetailsResponse/global" )
//log.info node.toString()
//log.info node.length

for(i=0;i<node.length;i++){
	if(node[i] != 'false'){
	flag=false
	break;
	}		
}
assert flag==true	
********************************************************
//Script-Assert [global=false||true]-credit/cards/5716
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def global = holder.getNodeValues( "//response/promotionDetailsResponse/global" )
//log.info node.toString()
assert Arrays.asList(global).contains('true')
assert Arrays.asList(global).contains('false')
********************************************************FLOAT Parsing (double)
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def total = holder.getNodeValue( "//response[1]/total[1]" )
def Guesttotal = context.expand('${#TestCase#Guesttotal}')
def Regtotal = context.expand('${#TestCase#Regtotal}')

double totalcost=  Double.parseDouble(Guesttotal) + Double.parseDouble(Regtotal)

assert Float.parseFloat(total) == totalcost.floatValue()

********************************************************
def prodPromo = holder.getNodeValues( "//*:CategoryResponse/category/product/product[badges/promotionbadge and not(badges/promotionbadge='Bonus Offer')]/@id" )
********************************************************
if(!pricingpolicy[i].equals('https://customerservice.bloomingdales.com/app/answers/detail/a_id/366/theme/popup/')){

********************************************************
Set<String> hs = new HashSet<String>();
for(val in colorwayids)
{
	assert hs.add(val)
	
}
********************************************************
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def node = holder.getNodeValues( "//brandindexresponse/brandIndex/brandURL" )
assert isValidURL(node[new Random().nextInt(node.size()-1)])
boolean isValidURL(String stringurl)
{
	boolean flag=true;
	try{
		URL url = new URL(stringurl);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
    		if(connection.getResponseCode()!=200){
//    			log.info connection.getResponseCode();
    			return false;
    		}
    		else
    		{
    		return true;
    		}
	}
	catch(Exception e)
	{
//		log.info e.toString()
		return false;
	}
}
********************************************************

assert sizeid_array[i].isInteger()
assert sizenormal_array[i]!=null
assert val.isFloat()
assert Float.parseFloat(prod_loworiginal_price)==Float.parseFloat(upc_originalprice)
if(!upc_intermediatePrice[0].equals("0.0"))
assert holder["count(//productresponse/product/productDetails/price/pricingpolicy)" ].equals("0"),"pricingpolicy tag should not be present if pricetype<=0"

List<String> bullets = Arrays.asList(holder.getNodeValues( "//productresponse/product/productDetails/summary/bullets" ))
assert bullets.indexOf(context.expand('${#TestSuite#FABRIC_CONTENT}')) < bullets.indexOf(context.expand('${#TestSuite#PRODUCT_CARE}'))&& bullets.indexOf(context.expand('${#TestSuite#PRODUCT_CARE}'))< bullets.indexOf(context.expand('${#TestSuite#COUNTRY_OF_ORIGIN}'))&&bullets.indexOf(context.expand('${#TestSuite#COUNTRY_OF_ORIGIN}')) < bullets.indexOf(context.expand('${#TestSuite#BULLET_TEXT}').split(",")[0]),"bullets values are sorted in the order of FABRIC_CONTENT, PRODUCT_CARE, COUNTRY_OF_ORIGIN , BULLET_TEXT &DISCLAIMERS"

log.info "master product= "+product.toString()

List<String> sizeidsWithoutDuplicates=new ArrayList<String>(new LinkedHashSet<String>(Arrays.asList(sizeids)));
assert sizeids as Set==sizeidsWithoutDuplicates as Set

//http://pleac.sourceforge.net/pleac_groovy/arrays.html
Extracting Unique Elements from a List
assert [ 1, 1, 2, 2, 3, 3, 3, 5 ].unique() == [ 1, 2, 3, 5 ]

Sorting an Array Numerically
assert [100, 3, 20].sort() == [3, 20, 100]
log.info ([100, 3, 20].sort().toString())

matches( //response[1]/itemsMapper[1]/sequenceNumber[1]/text(), '\d' )===true
****************************************************
def header = context.currentStep.getHttpRequest().getResponse().properties["responseHeaders"]
if (header["#status#"].toString().contains("200 OK") && product_size.toString() != 'null'){
	messageExchange.modelItem.testStep.testCase.setPropertyValue( "product_size", product_size )
	}
	
**************************************************** ENCODE/DECODE
	facetValues[i]=URLEncoder.encode(facetValues[i],"UTF-8");
	def contactId1 = holder.getNodeValue( "//response/shippingContactMapper/shippingContact[email='"+user_email+"']/contactId" )
	
***facet_Value=URLDecoder.decode(refinement_BRAND_Value.toString(),"UTF-8");
	
**************************************************** masked String
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def cardnumbers = holder.getNodeValues( "//response/billingMapper/creditcarddetails/cardnumber" )

String cardNumExpected = context.expand('${#TestSuite#b_cardnumber1}')
int cardNumExpectedLenth = cardNumExpected.toString().length()

if (cardnumbers.size() > 0 ){
	for (cardnumber in cardnumbers){
		int cardLenth = cardnumber.toString().length()		
		int start = cardLenth-4
		assert cardnumber[start..cardLenth-1].isNumber() //Asserting the last 4 disgits are Numbers
		assert cardnumber[start..cardLenth-1] == cardNumExpected[cardNumExpectedLenth-4..cardNumExpectedLenth-1]  //Asserting last 4 digits matches
		assert cardnumber[0..start-1].equals('xxxxxxxxxxxx') //Assert retrieved card masked
	}
}

**************************************************** xpath 
//response[1]/bagitems[upcid='${#TestSuite#upc1}']/quantity[1]/text()

**************************************************** log failed req
if(messageExchange.getResponseStatusCode() != 200)
{
	log.info messageExchange.getEndpoint()
}

runner.testSuite.getTestCaseByName("PSP10061-MCOM without input CatId").setDisabled(true);

//assert Double.parseDouble(all_dist[i]) <= Double.parseDouble(all_dist[i+1]),"Stores are not ordered in ascending order "

//remove properties before execution
project.removeProperty("refcatid$i" ) 
testSuite.removeProperty("refcatid$i" ) 

**************************************************** url Validation
import com.eviware.soapui.support.XmlHolder

def holder = new XmlHolder( messageExchange.responseContentAsXml )
def node = holder.getNodeValue( "//response/store/storemap" )

assert isValidURL(node)

boolean isValidURL(String stringurl)
{
	boolean flag=true;
	try{
		URL url = new URL(stringurl);
//		log.info stringurl
//		log.info url
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
    		if(connection.getResponseCode()!=200&&connection.getResponseCode()!=302){
    			log.info connection.getResponseCode();
    			return false;
    		}
    		else
    		{
    		return true;
    		}
	}
	catch(Exception e)
	{
//		log.info e.toString()
		return false;
	}
}