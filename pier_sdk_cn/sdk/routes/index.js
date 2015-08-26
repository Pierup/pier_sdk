var express = require('express');
var router = express.Router();

var request = require('request');
var apiUrl = require( '../config/apiUrl' );
var pierUtil = require( '../pierutil/util' );
var pierLog = require( '../pierlog' );
var https = require('https');

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index');
});
router.get('/checkout/orderList', function(req, res, next){
  res.render('order-list');
})

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
router.get('/mobile/user/forgetPassword', function(req, res, next) {
  console.error( 'get cookie', req.session['auth_order'] );
  res.render('mobile/resetPsd/forget-psd',{
    title:'忘记密码',
    location: 'forgetPassword'
  });
});
router.get('/mobile/user/resetPassword/:token', function(req, res, next) {
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
  
  console.log("get post on checkout", JSON.stringify(req.body) );
  var urlPath = '/saveOrderInfo';
  var message = {
    order_id: req.body.order_id,
    merchant_id: req.body.merchant_id,
    amount: req.body.amount,
    order_detail: JSON.stringify(req.body.order_detail),
    return_url: req.body.return_url
  };
  // var userAuth = res.session['user_auth'];
 
  // req.session['user_auth'] = undefined;
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( 'user save new order ', body );
    if( body.code == 200 ){
      res.redirect('/checkout/login?merchant='+req.body.merchant_id+'&order='+req.body.order_id );
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
  if( merchant == '' || order == '' ){
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
      req.session[merchant+order].order_detail = JSON.parse(JSON.parse(body.result.order_detail)).items;
      var authOrder = pierUtil.checkAuthOrder( req, merchant+order );
      if( !authOrder ) return;
      // var userAuth = req.session['user_auth'] || undefined;
      // if( userAuth ){
      //   if( authOrder.order_detail != {} ){
      //     res.redirect( '/checkout/confirm?merchant='+merchant+'&order='+order );
      //   }else{
      //     res.redirect( '/checkout/payment?merchant='+merchant+'&order='+order );
      //   }
      //   return;
      // }
      console.log( 'user get order auth', authOrder );
      authOrder.location = 'login';
      authOrder.phone = undefined;
      authOrder.password = undefined;
      authOrder.errorMsg = '';
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
  var authOrder = pierUtil.checkAuthOrder( req, merchant+order );
  if( !authOrder ) return;
  var params = {
    phone: req.body.phone,
    password: req.body.password
  };
  var urlPath = '/checkoutLogin';
  console.log( "checkout user login params", params );
  //for check user password and phone
  authOrder.errorMsg = '';
  if( pierUtil.checkPhone(params.phone) != '' || pierUtil.checkPassword(params.password) != '' ){
    authOrder.location = 'login';
    authOrder.errorMsg = pierUtil.checkPhone(params.phone) != ''? pierUtil.checkPhone(params.phone):pierUtil.checkPassword(params.password);
    authOrder.phone = params.phone;
    authOrder.password = params.password;
    res.render('checkout/login', authOrder );
    return;
  }

  //login request
  request( pierUtil.getRequestParams( urlPath, params ), function(err, response, body){
    console.log( "user login when checkout", body );
    authOrder.errorMsg = '';
    if( body.code == 200 ){
      req.session[merchant+order].user_auth = { user_id: body.result.user_id , session_token: body.result.session_token, name: body.result.name };
      console.log('get user authOrer detail', authOrder );
      // if( pierUtil.getBinaryStatusBit( body.result.status_bit, 8 ) != 1 ){

      // }
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
  console.log("get payment on checkout", merchant+order);
  var authOrder = pierUtil.checkAuthOrder( req, merchant+order );
  if( !authOrder ) return;
  var userAuth = pierUtil.checkUserAuth( req, merchant+order );
  if( !userAuth ) return;
  authOrder.location = 'checkout';
  authOrder.title = '付款';
  authOrder.errorMsg = '';
  res.render('checkout/payment',authOrder);
});

router.get('/checkout/confirm', function(req, res, next) {
  var merchant = req.query.merchant || '';
  var order = req.query.order || '';
  if( merchant == '' || order == '' ){
    res.redirect( '/checkout/unknownError');
    return;
  }
  var authOrder = pierUtil.checkAuthOrder( req, merchant+order );
  console.log( 'checkout confirm page ', authOrder );
  if( !authOrder ) return;
  var userAuth = pierUtil.checkUserAuth( req, merchant+order );
  if( !userAuth ) return;
  console.log( 'order detail to json', authOrder.order_detail );
  authOrder.location = 'checkout';
  authOrder.title = '订单确认';
  res.render( 'checkout/confirm',authOrder );
});

router.post('/checkout/getSMS', function(req, res, next) {
  // var authOrder = pierUtil.checkAuthOrder( req, res );
  // console.log( 'checkout get sms api ', authOrder );
  // if( !authOrder ) return;
  var merchant = req.body.merchant_id;
  var order = req.body.order_id;

  var authOrder = pierUtil.checkAuthOrder( req, merchant+order );
  console.log( 'checkout get sms api ', authOrder );
  if( !authOrder ) return;
  
  var userAuth = pierUtil.checkUserAuth( req, merchant+order );
  if( !userAuth ) return;
  var urlPath = '/checkoutSMS';
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    merchant_id: authOrder.merchant_id,
    amount: authOrder.amount
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
  var authOrder = pierUtil.checkAuthOrder( req, merchant+order );
  console.log( 'checkout get pay api ', authOrder );
  if( !authOrder ) return;

  var userAuth = pierUtil.checkUserAuth( req, merchant+order );
  if( !userAuth ) return;
  var urlPath = '/checkoutPay';
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    amount: authOrder.amount,
    merchant_id: authOrder.merchant_id,
    order_id: authOrder.order_id,
    sms_code: req.body.validCode,
    pay_password: req.body.payPassword
    // api_id: authOrder.api_id,
    // api_secret_key: authOrder.api_secret_key
  };
  authOrder.errorMsg = '';
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user make payment", body );
    if( body.code == 200 ){
      pierUtil.refreshToken( body.result.session_token, req, merchant+order );
      // res.send( body );
      authOrder.location = 'checkout';
      authOrder.title = '支付成功';
      // pierUtil.clearUserAuth( req );
      // req.session.destroy();
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
      // req.session.destroy();
      pierUtil.destoryAuthOrder( merchant, order, req );
      res.render( 'checkout/payFailed', authOrder );
    }
  } );
});
router.get('/checkout/paySuccess', function(req, res, next) {
  // var authOrder = pierUtil.checkAuthOrder( req, res );
  // console.log( 'checkout get pay api ', authOrder );
  // if( !authOrder ) return;
  authOrder.location = 'checkout';
  authOrder.title = '支付成功';
  res.render('checkout/paySuccess', authOrder);
});
router.get('/checkout/payFailure', function(req, res, next) {
  // var authOrder = pierUtil.checkAuthOrder( req, res );
  // console.log( 'checkout get pay api ', authOrder );
  // if( !authOrder ) return;
  authOrder.location = 'checkout';
  authOrder.title = '支付失败';
  res.render('checkout/payFailed', authOrder);
});
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
  var userAuth = pierUtil.checkUserAuth( req, res );
  if( !userAuth ) return;
  var params = {
    title: '重置支付密码',
    username: userAuth.name,
    location: 'forgetPin'
  };
  console.log( 'for user reset pay password', params );
  res.render( 'resetPayPassword/forget-paypsd', params );
});

router.post('/user/resetPayPsd/linkBankCard', function(req, res, next) {
  var userAuth = pierUtil.checkUserAuth( req, res );
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
      pierUtil.refreshToken( body.result.session_token, req );
    }
    res.send( body );
  } );
});

router.post('/user/resetPayPsd/verifyBank', function(req, res, next) {
  var userAuth = pierUtil.checkUserAuth( req, res );
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
      pierUtil.refreshToken( body.result.session_token, req );
    }
    res.send( body );
  } );
});

router.get('/user/resetPayPassword2', function(req, res, next) {
  var userAuth = pierUtil.checkUserAuth( req, res );
  if( !userAuth ) return;
  var query = req.query.token;
  var params = {
    title: '重置支付密码',
    username: '1234',
    token: query,
    location: 'forgetPin'
  };
  console.log( 'for user reset pay password2', params );
  res.render( 'resetPayPassword/reset-paypsd', params );
});

router.post('/user/resetPayPsd/reset', function(req, res, next) {
  var userAuth = pierUtil.checkUserAuth( req, res );
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
      pierUtil.refreshToken( body.result.session_token, req );
    }
    res.send( body );
  } );
});

router.get('/user/resetPinSuccess', function(req, res, next) {
  var userAuth = pierUtil.checkUserAuth( req, res );
  if( !userAuth ) return;
  var params = {
    title: '重置支付密码',
    location: 'forgetPin'
  };
  res.render( 'resetPayPassword/resetSuccess', params );
});

module.exports = router;
