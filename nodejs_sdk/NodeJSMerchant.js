var express = require('express');
var bodyParser = require("body-parser");

var MerchantSDKClient = require('./MerchantSDKClient.js');
var TransactionConfig = require('./TransactionConfig.js');

var app = express();
app.use(bodyParser.urlencoded({ extended: true }));

var PierTransaction = function(params, res) {
	var merchant = new MerchantSDKClient("MC0000014895");
	var config = new TransactionConfig(
		params.amount, 
		'5b52051a-931a-11e4-aad2-0ea81fa3d43c', 
		'mk-test-5b52041f-931a-11e4-aad2-0ea81fa3d43c', 
		params.auth_token, 
		params.currency, 
		params.order_id, 
		'dummy Node.js merchant'
	);
	merchant.transaction(config, function(result){
		res.send(result);
	});
}

app.get('/:amount/:auth_token/:currency/:order_id', function(req, res){
	PierTransaction(req.params, res);
});

app.post('/', function(req, res){
	PierTransaction(req.body, res);
});

app.listen(8080, function(){
	console.log('Starting server on port 8080...')
});