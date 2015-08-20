var express = require('express');
var router = express.Router();

var request = require('request');
var apiUrl = require( '../config/apiUrl' );
var pierUtil = require( '../pierutil/util' );
var pierLog = require( '../pierlog' );

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index');
});

/*
 Forget password
 */
router.get('/user/forgetPassword', function(req, res, next) {
  console.error( 'get cookie', req.session['auth_order'] );
  res.render('resetPsd/forget-psd',{
    title:'忘记密码'
  });
});
router.get('/user/resetPassword/:token', function(req, res, next) {
  console.log( 'reset password', req.params.token);
  console.error( 'get cookie', req.session.cookie['auth_order'] );
  res.render('resetPsd/reset-psd',{
    token:req.params.token,
    title:'忘记密码'
  });
});
router.get('/user/resetSuccess', function(req, res, next) {
  res.render('resetPsd/reset-success',{title:'重置密码成功'});
});
router.post('/test/merchant/callback', function(req, res, next){
  console.log( 'Get Merchant callback success', req.body);
  res.send({
    'code':'200',
    'message':'OK',
    'result':{}
  })
})

/**
 * user checkout login
 */
router.post('/checkout/login', function(req, res, next) {
  req.session['auth_order'] = req.body;
  req.session['auth_order'].order_detail = JSON.parse(req.body.order_detail);
  console.log("get post on checkout", JSON.stringify(req.body) );
  var urlPath = '/saveOrderInfo';
  var message = {
    order_id: req.body.order_id,
    merchant_id: req.body.merchant_id,
    amount: req.body.amount,
    order_detail: JSON.stringify(req.body.order_detail)
  };
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( 'user save new order ', body );
    if( body.code == 200 ){
      res.redirect('/checkout/login');
    }else{
      res.render( 'checkout/unknownError',{ error: body.message, title: '订单错误'} );
    }
  })
});
//for page test
router.get('/checkout/unknownError',function(req, res, next){
  res.render( 'checkout/unknownError',{ error: "Test error", title: 'test' } );
})
router.get('/checkout/login', function(req, res, next) {
  var authOrder = pierUtil.checkAuthOrder( req, res );
  if( !authOrder ) return;
  authOrder.location = 'login';
  authOrder.phone = undefined;
  authOrder.password = undefined;
  authOrder.errorMsg = '';
  res.render('checkout/login', authOrder );
});

router.post('/checkout/login_auth', function(req, res, next) {
  var authOrder = pierUtil.checkAuthOrder( req, res );
  if( !authOrder ) return;
  var params = req.body;
  var urlPath = '/checkoutLogin';
  console.log( "checkout user login params", params );
  if( pierUtil.checkPhone(params.phone) != '' || pierUtil.checkPassword(params.password) != '' ){
    authOrder.location = 'login';
    authOrder.errorMsg = pierUtil.checkPhone(params.phone) != ''? pierUtil.checkPhone(params.phone):pierUtil.checkPassword(params.password);
    authOrder.phone = params.phone;
    authOrder.password = params.password;
    res.render('checkout/login', authOrder );
    return;
  }
  //check password and phone 
  request( pierUtil.getRequestParams( urlPath, req.body ), function(err, response, body){
    console.log( "user login when checkout", body );
    if( body.code == 200 ){
      req.session['user_auth'] = { user_id: body.result.user_id , session_token: body.result.session_token, name: body.result.name };
      console.log('get user authOrer detail', authOrder );
      if( authOrder.order_detail != {} ){
        res.redirect( '/checkout/confirm')
      }else{
        res.redirect( '/checkout/payment')
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
  console.log("get payment on checkout");
  var authOrder = pierUtil.checkAuthOrder( req, res );
  if( !authOrder ) return;
  authOrder.location = 'checkout';
  authOrder.title = '付款';
  res.render('checkout/payment',authOrder);
});
router.get('/checkout/confirm', function(req, res, next) {
  var authOrder = pierUtil.checkAuthOrder( req, res );
  console.log( 'checkout confirm page ', authOrder );
  if( !authOrder ) return;
  console.log( 'order detail to json', authOrder.order_detail );
  authOrder.location = 'confirm';
  authOrder.title = '订单确认';
  res.render( 'checkout/confirm',authOrder );
});

router.post('/checkout/getSMS', function(req, res, next) {
  var authOrder = pierUtil.checkAuthOrder( req, res );
  console.log( 'checkout get sms api ', authOrder );
  if( !authOrder ) return;
  
  var userAuth = pierUtil.checkUserAuth( req, res );
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
      pierUtil.refreshToken( body.result.session_token, req );
      res.send( body );
    }else{
      res.send( body );
    }
  } );
});
router.post('/checkout/pay', function(req, res, next) {
  var authOrder = pierUtil.checkAuthOrder( req, res );
  console.log( 'checkout get pay api ', authOrder );
  if( !authOrder ) return;
  var userAuth = pierUtil.checkUserAuth( req, res );
  if( !userAuth ) return;
  var urlPath = '/checkoutPay';
  var message = {
    user_id: userAuth.user_id,
    session_token: userAuth.session_token,
    amount: authOrder.amount,
    merchant_id: authOrder.merchant_id,
    order_id: authOrder.order_id,
    sms_code: req.body.validCode,
    pay_password: req.body.payPassword,
    api_id: authOrder.api_id,
    api_secret_key: authOrder.api_secret_key
  };
  request( pierUtil.getRequestParams( urlPath, message ), function(err, response, body){
    console.log( "user make payment", body );
    if( body.code == 200 ){
      pierUtil.refreshToken( body.result.session_token, req );
      // res.send( body );
      authOrder.location = 'paySuccess';
      authOrder.title = '支付成功';
      res.render( 'checkout/paySuccess', authOrder );
    }else if( body.code == 1110 || body.code == 1111 || body.code == 2028 || body.code == 1142 ){
      authOrder.location = 'checkout';
      authOrder.title = '付款';
      authOrder.errorMsg = body.message;
      res.render('checkout/payment',authOrder);
    }else{
      authOrder.location = 'payFailure';
      authOrder.title = '支付失败';
      authOrder.errorMsg = body.message;
      res.render( 'checkout/payFailed', authOrder );
    }
  } );
});
router.get('/checkout/paySuccess', function(req, res, next) {
  var authOrder = pierUtil.checkAuthOrder( req, res );
  console.log( 'checkout get pay api ', authOrder );
  if( !authOrder ) return;
  authOrder.location = 'paySuccess';
  authOrder.title = '支付成功';
  res.render('checkout/paySuccess', authOrder);
});
router.get('/checkout/payFailure', function(req, res, next) {
  var authOrder = pierUtil.checkAuthOrder( req, res );
  console.log( 'checkout get pay api ', authOrder );
  if( !authOrder ) return;
  authOrder.location = 'payFailure';
  authOrder.title = '支付失败';
  res.render('checkout/payFailed', authOrder);
});

/**
 * user register flow
 */
router.get('/user/register', function(req, res, next) {
  console.log("user register start");
  res.render('register/register',{title:'用户注册'});
});
router.post('/user/apply', function(req, res, next) {
  console.log( "user apply credit", req.body );
  var urlPath = '/regApplyCredit';
  request( pierUtil.getRequestParams( urlPath, req.body ), function(err, response, body){
    console.log( "get apply credit response body", body );
    if( body.code == 200 ){
      body.title = '申请信用成功';
      res.render('register/applySuccess',body );
    }else{
      body.title = '申请信用失败';
      res.render('register/applyFailure',body );
    }
  } );
});
router.get('/user/applySuccess', function(req, res, next) {
  res.render('register/applySuccess',{title:'申请信用成功'});
});
router.get('/user/applyFailure', function(req, res, next) {
  res.render('register/applyFailure',{title:'申请信用失败'});
});

/**
 * user forget pay password
 */
router.get('/user/resetPayPassword', function(req, res, next) {
  var userAuth = pierUtil.checkUserAuth( req, res );
  if( !userAuth ) return;
  var params = {
    title: '重置支付密码',
    username: userAuth.name
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
    // bank_card_id: req.body.bank_card_id,
    code: req.body.code
    // linked_phone: req.body.linked_phone
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
    token: query
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
  };
  res.render( 'resetPayPassword/resetSuccess', params );
});

module.exports = router;
