#import('dart:html');
#import('dart:json');


// @TODO: Add G+ api
// @TODO: Add location detector
locate(pos) {
 var lat = pos.coords.latitude;
 var lng = pos.coords.longitude;
 var parsedlat=lat.toStringAsFixed(6);
 var parsedlng=lng.toStringAsFixed(6);
  //print("Latitude: " + lat);
  //print("Longitude: " + lng);
  window.localStorage.$dom_setItem("LAT",parsedlat);
  window.localStorage.$dom_setItem("LNG",parsedlng);
}

locReceived(MessageEvent e){
  var data = JSON.parse(e.data);
  print("beginning parsing");
  Element div_wrapper = new Element.tag('div');
  div_wrapper.attributes['id'] = 'wrapper';
  document.body.elements.add(div_wrapper);
  div_wrapper = document.query('#wrapper');
    var city = JSON.stringify(data['address']['city']);
    //print(city);
    window.localStorage.$dom_setItem("CITY",city);
}
dataReceived(MessageEvent e) {
  var data = JSON.parse(e.data);

  Element div_wrapper = new Element.tag('div');
  div_wrapper.attributes['id'] = 'wrapper';
  document.body.elements.add(div_wrapper);
  div_wrapper = document.query('#wrapper');

  for (var a = 0; a < data['responseData']['results'].length; a++) {
    var headline = JSON.stringify(data['responseData']['results'][a]['title']);
    var content  = JSON.stringify(data['responseData']['results'][a]['content']);

    // @HACK: for removing double quoates
    headline = headline.replaceAll(new RegExp("\"\$"), '');
    headline = headline.replaceAll(new RegExp("^\""), '');
    content  = content.replaceAll(new RegExp("\"\$"), '');
    content  = content.replaceAll(new RegExp("^\""), '');

    Element div_news = new Element.tag('div');
    div_news.attributes['id'] = 'news';
    div_wrapper.elements.add(div_news);
    div_news = document.query('#news');

    Element news_title               = new Element.tag('h3');
    news_title.innerHTML             = headline;
    div_news.elements.add(news_title);
    Element news_content             = new Element.tag('p');
    news_content.innerHTML           =  content + " " +
                                       "<a href=" + JSON.stringify(data['responseData']['results'][a]['signedRedirectUrl']) +
                                       ">" + "[Read More]" + "</a>";
    news_content.attributes['class'] = 'content';
    div_news.elements.add(news_content);
    Element hr                       = new Element.tag('hr');
    div_news.elements.add(hr);
  }
}
newsscript(){
  window.on.message.add(dataReceived);
  Element script = new Element.tag("script");
  var somenewsurl="https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=Panchkula&callback=callbackForJsonpApi";
  script.src=somenewsurl;
}
void main() {
  // listen for the postMessage from the main page

  window.navigator.geolocation.getCurrentPosition(locate);

  //window.localStorage.$dom_setItem("CITY","Chandigarh");
//  window.on.message.add(dataReceived);\
  window.on.message.add(locReceived);
  Element script = new Element.tag("script");
  //var someurl="https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=Panchkula&callback=callbackForJsonpApi";
  var somelat=window.localStorage.$dom_getItem("LAT");
  var somelng=window.localStorage.$dom_getItem("LNG");
  //var someurl="https://maps.googleapis.com/maps/api/geocode/json?latlng="+somelat+","+somelng+"&sensor=false&callback=callbackForMapsApi";
  var someurl="http://nominatim.openstreetmap.org/reverse?format=json&lat="+somelat+"&lon="+somelng+"&addressdetails=1&json_callback=callbackForMapsApi";
  script.src=someurl;
  document.body.elements.add(script);
  //beginnning news display
  /*window.on.message.add(dataReceived);
  Element newsscript = new Element.tag("newsscript");
  var somenewsurl="https://ajax.googleapis.com/ajax/services/search/news?v=1.0&q=Panchkula&callback=callbackForJsonpApi";
  newsscript.src=someurl;
*/
  //newsscript();

}