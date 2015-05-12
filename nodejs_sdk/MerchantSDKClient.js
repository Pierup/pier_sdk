var request = require('request');

function MerchantSDKClient(merchant_id) {
	this.merchant_id = merchant_id
}

MerchantSDKClient.prototype.transaction = function(config, callback) {
	config.merchant_id = this.merchant_id

	var options = {
	    uri: 'http://pierup.ddns.net:8686/merchant_api/v1/transaction/pay_by_pier',
	    method: 'POST',
	    json: config
	};

	request(options, function (error, response, body) {
		if (!error) {
			callback(new SDKResult(body.code == 200, body.message, body.code, body.result))
		} else {
			callback(new SDKResult(false, error, null, null))
		}
	});
};

function SDKResult(status, message, code, result) {
	this.status = status
	this.message = message
	this.code = code
	this.result = result
}

module.exports = MerchantSDKClient;