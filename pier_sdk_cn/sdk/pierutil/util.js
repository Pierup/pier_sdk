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
  checkAuthOrder: function( req, res, orderName ){

    var authOrder = req.session[orderName] || {};
    if( authOrder.order_id == undefined ){
      console.error("order_id", authOrder);
      res.redirect('/checkout/unknownError');
      return false;
    }else{
      return authOrder;
    }
  },
  checkAuthOrderForApi: function( req, res, orderName ){
    var authOrder = req.session[orderName] || {};
    if( authOrder.order_id == undefined ){
      console.error("order_id", authOrder);
      res.send({code:'500', message: '发生错误', result: {}});
      return false;
    }else{
      return authOrder;
    }
  },
  checkUserAuth: function( req, res, orderName ){
    var userAuth = req.session[orderName].user_auth || {};
    if( userAuth.user_id == undefined ){
      res.redirect('/checkout/login');
      return false;
    }else{
      return userAuth;
    }
  },
  checkUserAuthForApi: function( req, res, orderName ){
    var userAuth = req.session[orderName].user_auth || {};
    if( userAuth.user_id == undefined ){
      res.send({code:'500', message: '发生错误', result: {}});
      return false;
    }else{
      return userAuth;
    }
  },
  checkForgetPinUserAuth: function( req, res ){
    var userAuth = req.session['forgetPinAuth'] || {};
    if( userAuth.user_id == undefined ){
      res.redirect('/checkout/login');
      return false;
    }else{
      return userAuth;
    }
  },
  checkUserAuthForLogin: function(){
    var userAuth = req.session['user_auth'];
    if( userAuth.user_id == undefined ){
      return false;
    }else return true;
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
  refreshToken: function( token, req, orderName ){
    req.session[orderName].user_auth.session_token = token;
  },
  clearUserAuth: function( req ){
    req.session['userAuth'] = {};
  },
  getBinaryStatusBit: function (num, pos){
      if( isNaN(num) ) return;
      if( isNaN(pos) ) return parseInt(num,10).toString(2);
      else {
        var length = (parseInt(num,10).toString(2)).length;
        if( length < pos ) return 'error';
        return parseInt(num,10).toString(2).substr((length - pos),1);
      }
  },
  getAuthOrder: function( merchant, order, req ){
    return req.session[merchant+order];
  },
  // saveAuthOrder: function( )
  destoryAuthOrder: function( merchant, order, req ){
    req.session[merchant+order] = {};
    return;
  }


}

module.exports = pierUtil;