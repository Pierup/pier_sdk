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
router.get('/user/forgetPassword', function(req, res, next) {
  res.render('resetPsd/forget-psd',{
    title:'忘记密码'
  });
});
router.get('/user/resetPassword/:token', function(req, res, next) {
  console.log( 'reset password', req.params.token);
  res.render('resetPsd/reset-psd',{
      token:req.params.token,
      title:'忘记密码'
  });
});
router.get('/user/resetSuccess', function(req, res, next) {
  res.render('resetPsd/reset-success');
});

router.post('/checkout/login/:order_id', function(req, res, next) {
  console.log("get post on checkout", req.body);
  req.body.order_id = req.params.order_id;
  req.body.location = 'login';
  res.render('checkout/login',req.body);
});
/*
  user payment page
 */
router.get('/checkout/payment/:order_id', function(req, res, next) {
  console.log("get payment on checkout", req.body);
  req.body.order_id = req.params.order_id;
  req.body.location = 'checkout';
  res.render('checkout/payment',req.body);
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
      console.log( "aaaaaaaaaaa", body );
      res.render('register/applySuccess',body );
    }else{
      body.title = '申请信用失败';
      res.render('register/applyFailure',body );
    }
  } );
});
router.get('/user/applySuccess', function(req, res, next) {
  console.log("user register start");
  res.render('register/applySuccess',{title:'申请信用成功'});
});
router.get('/user/applyFailure', function(req, res, next) {
  console.log("user register start");
  res.render('register/registerFailure',{title:'申请信用失败'});
});



module.exports = router;
