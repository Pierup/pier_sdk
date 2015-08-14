var apiUrl = require( '../config/apiUrl' );

var pierUtil = {
	getUrlPath: function( url ){
        return url.split( '/' )[1];
	},
	getCurrentDate: function(){
       var myDate = new Date();
       var year = myDate.getFullYear().toString(),
       month = (myDate.getMonth()+1).toString(),
       day = myDate.getDate().toString();
       month = month.length==1?'0'+month:month;
       day = day.length==1?'0'+day:day;
       return year+month+day;
	},
  getRequestParams: function( urlPath, body ){
    var accessObj = apiUrl[pierUtil.getUrlPath( urlPath )];

    var options = {
      url: apiUrl.hostName + accessObj.url,
      method: accessObj.method || "POST",
      json:true,
      body:body,
      headers: {
        'Content-Type': 'application/json'
      }
    };
    if( accessObj.method == 'GET' ){
      if( body.query ){
        for( var q in body.query ){
          options.url += '&'+q+'='+body.query[q]; 
        }
      }
    }
    return options;
  }
}

module.exports = pierUtil;