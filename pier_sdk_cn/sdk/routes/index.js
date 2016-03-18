var express = require('express');
var router = express.Router();

var request = require('request');
var apiUrl = require( '../config/apiUrl' );
var pierUtil = require( '../pierutil/util' );
var pierLog = require( '../pierlog' );
var https = require('https');
var crypto = require('crypto');
var fs = require('fs');

/* GET merchant  page. */
router.get('/', function(req, res, next) {
  var randomString = 'ORTest';
  for(var i=0; i<6;i++){
    randomString += Math.ceil( Math.random()*10 );
  }
  var urlPath = 'https://pierup.asuscomm.com:443/pier-merchant-cn/demo/pay/sign/MC0000001409';
  var message = {
    merchant_id: 'MC0000001409',
    no_order: randomString,
    money_order: '0.01',
    name_goods: '测试商品',
    info_order: '两只毛笔和一只铅笔',
    dt_order: '20160311164511',
    valid_order: '10080',
    api_id: '787fa484-1a3f-11e5-ba25-3a22fd90d682',
    api_secret_key: 'mk-test-787fa390-1a3f-11e5-ba25-3a22fd90d682',
    charset: 'UTF-8',
    sign_type: 'RSA'
  };
  request( {
      url: urlPath,
      method: "POST",
      json:true,
      body:message,
      headers: {
        'Content-Type': 'application/json'
      }
  }, function(err, response, body){
    res.render('index', {
      merchant_id: message.merchant_id,
      order_id: randomString,
      amount: message.money_order,
      api_id: message.api_id,
      charset: message.charset,
      name_goods: message.name_goods,
      info_order: message.info_order,
      dt_order: message.dt_order,
      sign_type: message.sign_type,
      sign: body.result.sign,
      valid_order: message.valid_order
    });
  } );

});
router.get('/checkout/orderList', function(req, res, next){
  res.render('order-list');
})

router.post('/getSignForTest', function(req, res, next){
  var urlPath = '/getDigitalSign';
  var message = req.body;
  var urlPath = 'https://121.40.19.24:8443/pier-merchant-cn/demo/pay/sign/MC0000001409?platform=3';
  var message = req.body;
  request( {
      url: urlPath,
      method: "POST",
      json:true,
      body:req.body,
      headers: {
        'Content-Type': 'application/json'
      }
  }, function(err, response, body){
    console.log( "user get sign for test ", body );
    res.send( body );
  } );
  
});


//for test callback
router.post('/test/merchant/callback', function(req, res, next){
  console.log( 'Get Merchant callback success', req.body);
  res.send({
    'code':'200',
    'message':'OK',
    'result':{}
  })
})

/*
 Forget password
 */
router.get('/user/forgetPassword', function(req, res, next) {
  console.error( 'get cookie', req.session['auth_order'] );
  res.render('resetPsd/forget-psd',{
    title:'忘记密码',
    location: 'forgetPassword'
  });
});
router.get('/user/resetPassword/:token', function(req, res, next) {
  console.log( 'reset password', req.params.token);
  console.error( 'get cookie', req.session.cookie['auth_order'] );
  res.render('resetPsd/reset-psd',{
    token:req.params.token,
    title:'忘记密码',
    location: 'forgetPassword'
  });
});
router.get('/user/resetSuccess', function(req, res, next) {
  res.render('resetPsd/reset-success',{title:'重置密码成功',location: 'forgetPassword'});
});

/*
 Forget password for mobile
 */
router.get('/user/forgetPassword', function(req, res, next) {
  console.error( 'get cookie', req.session['auth_order'] );
  res.render('mobile/resetPsd/forget-psd',{
    title:'忘记密码',
    location: 'forgetPassword'
  });
});
router.get('/user/resetPassword/:token', function(req, res, next) {
  console.log( 'reset password', req.params.token);
  console.error( 'get cookie', req.session.cookie['auth_order'] );
  res.render('mobile/resetPsd/reset-psd',{
    token:req.params.token,
    title:'忘记密码',
    location: 'forgetPassword'
  });
});
router.get('/mobile/user/resetSuccess', function(req, res, next) {
  res.render('mobile/resetPsd/reset-success',{title:'重置密码成功',location: 'forgetPassword'});
});



/**
 * user checkout login
 */
router.post('/checkout/login', function(req, res, next) {
  var urlPath = '/saveOrderInfo';
  var message = {
    order_id: req.body.order_id || null,
    merchant_id: req.body.merchant_id,
    amount: req.body.amount,
    order_detail: JSON.parse( req.body.order_detail ),
    return_url: req.body.return_url,
    api_id: req.body.api_id,
    sub_total: req.body.amount,
    shipping: 0,
    tax: 0
  };
  console.error('/checkout/login', message);
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( 'user save new order ', body );
    if( body.code == 200 ){
      res.redirect('/checkout/login?merchant='+req.body.merchant_id+'&order='+body.result.order_id+'&sign='+req.body.sign+'&sign_type='+req.body.sign_type+'&charset='+req.body.charset );
    }else{
      res.render( 'checkout/unknownError',{ error: body.message, title: '订单错误', location: 'error'} );
    }
  })
});

/**
 * user checkout login for pier-shop
 */
router.post('/checkout/loginShop', function(req, res, next) {
  var urlPath = '/saveOrderInfo';
  var message = {
    merchant_id: req.body.merchant_id,
    return_url: req.body.return_url,
    api_id: req.body.api_id,
    cart_id: req.body.cart_id
  };
  console.error('/checkout/login', message);
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( 'user save new order for pier shop', body );
    if( body.code == 200 ){
      res.redirect('/checkout/login?merchant='+req.body.merchant_id+'&order='+body.result.order_id+'&sign='+req.body.sign+'&sign_type='+req.body.sign_type+'&charset='+req.body.charset );
    }else{
      res.render( 'checkout/unknownError',{ error: body.message, title: '订单错误', location: 'error'} );
    }
  })
});

//for page test
router.get('/checkout/unknownError',function(req, res, next){
  res.render( 'checkout/unknownError',{ error: "未知错误，当前操作未成功，请稍后重试。", title: '未知错误', location: 'error' } );
})

router.get('/checkout/login', function(req, res, next) {
  var merchant = req.query.merchant || '';
  var order = req.query.order || '';
  var sign = req.query.sign || '';
  var sign_type = req.query.sign_type || '';
  var _charset = req.query.charset || '';
  if( merchant == '' || order == '' || sign == '' || sign_type == '' ){
    res.redirect( '/checkout/unknownError');
    return;
  }
  var urlPath = '/orderInfo',
  message = {
    order_id: order,
    merchant_id: merchant
  };
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( 'user get order info ', body );
    if( body.code == 200 ){
      req.session[merchant+order] = body.result;

      req.session[merchant+order].order_detail = JSON.parse(body.result.order_detail);
      req.session[merchant+order].sign = sign;
      req.session[merchant+order].sign_type = sign_type;
      req.session[merchant+order].charset = _charset;
      console.log(message);
      var authOrder = pierUtil.checkAuthOrder( req, res, merchant+order );
      if( !authOrder ) return;
      console.log( 'user get order auth', authOrder );
      authOrder.location = 'login';
      authOrder.phone = undefined;
      authOrder.password = undefined;
      authOrder.errorMsg = '';
      authOrder.directError = false;
      authOrder.location = 'login';
      authOrder.currency = 'CNY';
      res.render('checkout/login', authOrder );
    }else{
      res.render( 'checkout/unknownError',{ error: body.message, title: '订单错误', location: 'error'} );
    }
  })
});


router.post('/checkout/login_auth', function(req, res, next) {
  var merchant = req.body.merchant_id || '';
  var order = req.body.order_id || '';
  if( merchant == '' || order == '' ){
    res.redirect( '/checkout/unknownError');
    return;
  }
  var authOrder = pierUtil.checkAuthOrder( req, res, merchant+order );
  if( !authOrder ) return;
  var params = {
    phone: req.body.phone,
    password: req.body.password
  };
  var urlPath = '/checkoutLogin';
  console.log( "checkout user login params", params );
  //for check user password and phone
  authOrder.errorMsg = '';
  authOrder.directError = false;
  // if( pierUtil.checkPhone(params.phone) != '' || pierUtil.checkPassword(params.password) != '' ){
  //   authOrder.location = 'login';
  //   authOrder.errorMsg = pierUtil.checkPhone(params.phone) != ''? pierUtil.checkPhone(params.phone):pierUtil.checkPassword(params.password);
  //   authOrder.phone = params.phone;
  //   authOrder.password = params.password;
  //   res.render('checkout/login', authOrder );
  //   return;
  // }

  //login request
  request( pierUtil.getRequestParams( urlPath, params ), function(err, response, body){
    console.log( "user login when checkout", body );
    authOrder.errorMsg = '';
    if( body.code == 200 ){
      req.session[merchant+order].user_auth = { user_id: body.result.user_id , session_token: body.result.session_token, name: body.result.name };
      console.log('get user authOrer detail', authOrder );
      if( pierUtil.getBinaryStatusBit( body.result.status_bit, 4 ) != 1 ){
        authOrder.location = 'login';
        authOrder.errorMsg = '当前账户还没有申请信用';
        authOrder.phone = params.phone;
        authOrder.password = params.password;
        authOrder.directError = true;
        res.render('checkout/login', authOrder );
        return;
      }
      if( authOrder.order_detail != {} ){
        res.redirect( '/checkout/confirm?merchant='+merchant+'&order='+order)
      }else{
        res.redirect( '/checkout/payment?merchant='+merchant+'&order='+order)
      }
    }else{
      authOrder.location = 'login';
      authOrder.errorMsg = body.message;
      authOrder.phone = params.phone;
      authOrder.password = params.password;
      res.render('checkout/login', authOrder );
    }
  } );
});

/*
  user payment page
 */
router.get('/checkout/payment', function(req, res, next) {
  var merchant = req.query.merchant || '';
  var order = req.query.order || '';
  if( merchant == '' || order == '' ){
    res.redirect( '/checkout/unknownError');
    return;
  }
  var authOrder = pierUtil.checkAuthOrder( req, res, merchant+order );
  if( !authOrder ) return;
  var userAuth = pierUtil.checkUserAuth( req, res, merchant+order );
  if( !userAuth ) return;

  var urlPath = '/prePay';
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token
  };
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user check prePay when make payment", body );
    // body.code = '1142';
    if( body.code == '200' ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
      authOrder.location = 'checkout';
      authOrder.title = '付款';
      authOrder.errorMsg = '';
      res.render('checkout/payment',authOrder);
    }else if( body.code == '1171' ){
      var message = {
        merchant_id: merchant,
        order_id: order,
        title: '添加银行卡',
        errorMsg: ''
      };
      res.render('linkBank/verifyPin', message );
    }else if( body.code == '1142' ){
      var message = {
        merchant_id: merchant,
        order_id: order,
        title: '设置支付密码',
        errorMsg: ''
      };
      res.render('addPin/setPin', message );
    }
  } );
});

router.get('/checkout/confirm', function(req, res, next) {
  var merchant = req.query.merchant || '';
  var order = req.query.order || '';
  if( merchant == '' || order == '' ){
    res.redirect( '/checkout/unknownError');
    return;
  }
  var authOrder = pierUtil.checkAuthOrder( req, res, merchant+order );
  console.log( 'checkout confirm page ', authOrder );
  if( !authOrder ) return;
  var userAuth = pierUtil.checkUserAuth( req, res, merchant+order );
  if( !userAuth ) return;
  
  console.log( 'order detail to json', authOrder.order_detail );
  authOrder.location = 'checkout';
  authOrder.title = '订单确认';
  res.render( 'checkout/confirm',authOrder );
});

router.post('/checkout/getSMS', function(req, res, next) {
  var merchant = req.body.merchant_id;
  var order = req.body.order_id;

  var authOrder = pierUtil.checkAuthOrderForApi( req, res, merchant+order );
  console.log( 'checkout get sms api ', authOrder );
  if( !authOrder ) return;
  
  var userAuth = pierUtil.checkUserAuthForApi( req, res, merchant+order );
  if( !userAuth ) return;
  var urlPath = '/checkoutSMS';
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    merchant_id: authOrder.merchant_id,
    order_id: order
  }
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user get sms when checkout", body );
    if( body.code == 200 ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
      res.send( body );
    }else{
      res.send( body );
    }
  } );
});
router.post('/checkout/pay', function(req, res, next) {
  var merchant = req.body.merchant_id;
  var order = req.body.order_id;
  var authOrder = pierUtil.checkAuthOrder( req, res, merchant+order );
  
  if( !authOrder ) return;

  var userAuth = pierUtil.checkUserAuth( req, res, merchant+order );
  if( !userAuth ) return;
  var urlPath = '/checkoutPay';
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    // amount: authOrder.amount,
    merchant_id: authOrder.merchant_id,
    order_id: authOrder.order_id,
    sms_code: req.body.validCode,
    pay_password: req.body.payPassword,
    sign: authOrder.sign,
    sign_type: authOrder.sign_type,
    charset: authOrder.charset
  };
  authOrder.errorMsg = '';
  console.log( 'checkout get pay api ', message );
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user make payment", body );
    if( body.code == 200 ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
      // res.send( body );
      authOrder.location = 'checkout';
      authOrder.title = '支付成功';
      pierUtil.destoryAuthOrder( merchant, order, req );
      res.render( 'checkout/paySuccess', authOrder );
    }else if( body.code == '1110' || body.code == '1111' || body.code == '2028' || body.code == '1142' ){
      authOrder.location = 'checkout';
      authOrder.title = '付款';
      authOrder.errorMsg = body.message;
      res.render('checkout/payment',authOrder);
    }else{
      authOrder.location = 'checkout';
      authOrder.title = '支付失败';
      authOrder.errorMsg = body.message;
      pierUtil.destoryAuthOrder( merchant, order, req );
      res.render( 'checkout/payFailed', authOrder );
    }
  } );
});
router.get('/checkout/paySuccess', function(req, res, next) {
  authOrder.location = 'checkout';
  authOrder.title = '支付成功';
  res.render('checkout/paySuccess', authOrder);
});
router.get('/checkout/payFailure', function(req, res, next) {
  authOrder.location = 'checkout';
  authOrder.title = '支付失败';
  res.render('checkout/payFailed', authOrder);
});
/**
 * user link bank
 */
router.get('/checkout/linkBank', function( req, res, next){
  res.render('linkBank/verifyPin', {title: '添加银行卡',merchant_id:'001',order_id:'002', errorMsg: ''});
})
router.post('/checkout/verifyPinPost', function( req, res, next){
  var merchant = req.body.merchant_id;
  var order = req.body.order_id;
  var password = req.body.payPassword;
  var authOrder = pierUtil.checkAuthOrder( req, res, merchant+order );
  if( !authOrder ) return;

  var userAuth = pierUtil.checkUserAuth( req, res, merchant+order );
  if( !userAuth ) return;

  var urlPath = '/checkPayPassword',
  message = {
      user_id: userAuth.user_id,
      session_token: userAuth.session_token,
      password: password
  };
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log("user check pay password success", body );
    if( body.code == '200' ){
      var message = {
        merchant_id: merchant,
        order_id: order,
        title: '添加银行卡',
        errorMsg: '',
        username: userAuth.name
      };
      res.render( 'linkBank/linkBank', message );
    }else{
      var message = {
        merchant_id: merchant,
        order_id: order,
        title: '添加银行卡',
        errorMsg: body.message,
        username: userAuth.name
      };
      res.render('linkBank/verifyPin', message );
    }
  } );
})
router.post('/checkout/linkBankPost', function(req, res, next) {
  var merchant = req.body.merchant_id,
  order = req.body.order_id;
  var userAuth = pierUtil.checkUserAuthForApi( req, res, merchant+order );
  if( !userAuth ) return;
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    bank_id: req.body.bank_id,
    card_num: req.body.card_num,
    linked_phone: req.body.linked_phone
  };
  console.log( 'get link bank account session_token', message );
  var urlPath = '/regLinkBankCard';
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user link bank account success", body );
    if( body.result.session_token ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
    }
    res.send( body );
  } );
});
router.post( '/checkout/verifyBankPost', function( req, res, next ) {
  var merchant = req.body.merchant_id,
  order = req.body.order_id;
  var userAuth = pierUtil.checkUserAuth( req, res, merchant+order );
  if( !userAuth ) return;
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    bank_card_id: req.body.bank_card_id,
    code: req.body.code
  };
  var urlPath = '/regVerifyBank';
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user verify bank account success", body );
    if( body.result.session_token ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
    }
    res.send( body );
  } );
});
/**
 * user Set pin when checkout
 */
router.post( '/checkout/SetPin', function( req, res, next ){
  var merchant = req.body.merchant_id,
  order = req.body.order_id,
  password = req.body.password;
  var userAuth = pierUtil.checkUserAuthForApi( req, res, merchant+order );
  if( !userAuth ) return;
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    password: password
  };
  var urlPath = '/regSetPayPsd';
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user add Pin success", body );
    if( body.result.session_token ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
    }
    if( body.code == '200' ){
      var message = {
        title: '添加银行卡',
        merchant_id: merchant,
        order_id: order,
        username: userAuth.name
      };
      res.render('addPin/linkBank', message );
      return;
    }else{
      var message = {
        title: '设置支付密码',
        merchant_id: merchant,
        order_id: order,
        errorMsg: body.message
      };
      res.render('addPin/setPin', message );
      return;
    }
  } );
} )
/**
 * user register flow
 */
router.get('/user/register', function(req, res, next) {
  console.log("user register start");
  res.render('register/register',{title:'用户注册',location:'register'});
});
router.post('/user/apply', function(req, res, next) {
  console.log( "user apply credit", req.body );
  var urlPath = '/regApplyCredit';
  request( pierUtil.getRequestParams( urlPath, req.body ), function(err, response, body){
    console.log( "get apply credit response body", body );
    body.location = 'register';
    if( body.code == 200 ){
      req.session['user_auth'] = { user_id: req.body.user_id , session_token: body.result.session_token, name: body.result.name };
      body.title = '申请信用成功';
      res.render('register/applySuccess',body );
    }else{
      body.title = '申请信用失败';
      if( body.code == '1160' ) body.message = '很抱歉，您未满18周岁，无法申请品而信用的信用额度。您可以下载手机APP，通过“立即还款”中向账户充值后进行消费。';
      res.render('register/applyFailure',body );
    }
  } );
});
router.get('/user/applySuccess', function(req, res, next) {
  res.render('register/applySuccess',{title:'申请信用成功', location: 'register'});
});
router.get('/user/applyFailure', function(req, res, next) {
  res.render('register/applyFailure',{title:'申请信用失败', location: 'register'});
});

/**
 * user forget pay password
 */
router.get('/user/resetPayPassword', function(req, res, next) {
  var merchant = req.query.merchant || '';
  var order = req.query.order || '';
  if( merchant == '' || order == '' ){
    res.redirect( '/checkout/unknownError');
    return;
  }
  var authOrder = pierUtil.checkAuthOrder( req, res, merchant+order );
  console.log( 'checkout confirm page ', authOrder );
  if( !authOrder ) return;
  var userAuth = pierUtil.checkUserAuth( req, res, merchant+order );
  if( !userAuth ) return;
  req.session['forgetPinAuth'] = { merchant_id: merchant , order_id: order };
  
  var params = {
    title: '重置支付密码',
    username: userAuth.name,
    location: 'forgetPin'
  };
  console.log( 'for user reset pay password', params );
  res.render( 'resetPayPassword/forget-paypsd', params );
});

router.post('/user/resetPayPsd/linkBankCard', function(req, res, next) {
  var forgetPinAuth = req.session['forgetPinAuth'];
  var merchant = forgetPinAuth.merchant_id,
  order = forgetPinAuth.order_id;
  var userAuth = pierUtil.checkUserAuthForApi( req, res, merchant+order );
  if( !userAuth ) return;
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    bank_id: req.body.bank_id,
    card_num: req.body.card_num,
    linked_phone: req.body.linked_phone,
    id_number: req.body.id_number
  };
  console.log( 'get link bank account session_token', message );
  var urlPath = '/forgetPaymentPassword';
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user link bank account success", body );
    if( body.result.session_token ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
    }
    res.send( body );
  } );
});

router.post('/user/resetPayPsd/verifyBank', function(req, res, next) {
  var forgetPinAuth = req.session['forgetPinAuth'];
  var merchant = forgetPinAuth.merchant_id,
  order = forgetPinAuth.order_id;
  var userAuth = pierUtil.checkUserAuthForApi( req, res, merchant+order );
  if( !userAuth ) return;
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    code: req.body.code
  };
  var urlPath = '/forgetPaymentPasswordValidate';
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user verify bank account success", body );
    if( body.result.session_token ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
    }
    res.send( body );
  } );
});

router.get('/user/resetPayPassword2', function(req, res, next) {
  var forgetPinAuth = req.session['forgetPinAuth'];
  var merchant = forgetPinAuth.merchant_id,
  order = forgetPinAuth.order_id;
  var userAuth = pierUtil.checkUserAuth( req, res, merchant+order );
  if( !userAuth ) return;
  var query = req.query.token;
  var params = {
    title: '重置支付密码',
    username: userAuth.name,
    token: query,
    location: 'forgetPin'
  };
  console.log( 'for user reset pay password2', params );
  res.render( 'resetPayPassword/reset-paypsd', params );
});

router.post('/user/resetPayPsd/reset', function(req, res, next) {
  var forgetPinAuth = req.session['forgetPinAuth'];
  var merchant = forgetPinAuth.merchant_id,
  order = forgetPinAuth.order_id;
  var userAuth = pierUtil.checkUserAuthForApi( req, res, merchant+order );
  if( !userAuth ) return;
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    new_payment_password: req.body.new_payment_password,
    payment_password_token: req.body.payment_password_token
  };
  var urlPath = '/forgetPaymentPasswordReset';
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user reset pay password success", body );
    if( body.result.session_token ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
    }
    res.send( body );
  } );
});

router.get('/user/resetPinSuccess', function(req, res, next) {
  var forgetPinAuth = req.session['forgetPinAuth'];
  var merchant = forgetPinAuth.merchant_id,
  order = forgetPinAuth.order_id;
  var userAuth = pierUtil.checkUserAuth( req, res, merchant+order );
  if( !userAuth ) return;
  var params = {
    title: '重置支付密码',
    location: 'forgetPin',
    merchant_id: merchant,
    order_id: order
  };
  res.render( 'resetPayPassword/resetSuccess', params );
});

module.exports = router;
