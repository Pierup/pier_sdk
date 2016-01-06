var express = require('express');
var router = express.Router();

var request = require('request');
var apiUrl = require( '../config/apiUrl' );
var pierUtil = require( '../pierutil/util' );
var pierLog = require( '../pierlog' );


/**
 * user checkout login for post
 */
router.all('/crd/*', function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, No-Cache, Content-Type");
    // res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
    res.header("Content-Type", "application/json;charset=utf-8");
    next();
});
router.post('/crd/getBannerData', function(req, res, next) {
  var _amount = req.body.amount;
  var _currency = req.body.currency;
	
  var response = {
  	col1: '<img src="http://pierup.cn/images/sdk-logo.png" class="pier-banner-logo" style="width:40px;height:40px;border-radius:8px;"/>',
  	col2: '<span style="font-size:24px;font-weight:800;margin-left:10px;">品而付</span>',
  	col3: '<p style="font-size:20px;margin-left:20px;">使用<span style="color:#7b37a6;font-weight:800;">“品而付”</span>支付，每月分期手续费低至<span style="color:#7b37a6;font-weight:800;">'+_amount*0.01+'元</span></p>'
  }
  res.send(response);
});

module.exports = router;