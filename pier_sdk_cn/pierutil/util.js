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
  },
  checkAuthOrder: function( req, res ){
    var authOrder = req.session['auth_order'];
    if( authOrder.order_id == undefined ){
      res.redirect('/');
      return false;
    }else{
      return authOrder;
    }
  },
  checkUserAuth: function( req, res ){
    var userAuth = req.session['user_auth'];
    if( userAuth.user_id == undefined ){
      res.redirect('/');
      return false;
    }else{
      return userAuth;
    }
  },
  checkPhone: function( phone, num ){
    var phoneVal = phone || '';
    var numVal = num || 11;
    var msg = '';
    if( phoneVal.length < numVal ) msg = '您输入的手机号码不正确。';
    return msg;
  },
  checkPassword: function( password ){
    var passwordVal = password || '';
    var reg = /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{6,}$/;
    var msg = '';
    if( !reg.test( passwordVal ) )  msg =  '密码必须包含一个字母和数字组成，并且至少6位。';
    return msg;
  },
  refreshToken: function( token, req ){
    req.session['user_auth'].session_token = token;
  }

}

module.exports = pierUtil;