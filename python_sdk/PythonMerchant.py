from flask import Flask, request
app = Flask(__name__)

import json
from PierSDK import MerchantSDKClient, TransactionConfig

def pierTransaction(amount, auth_token, currency, id_in_merchant):
	merchant = MerchantSDKClient("MC0000014895")
	config = TransactionConfig(
	    amount, 
	    "5b52051a-931a-11e4-aad2-0ea81fa3d43c", 
	    "mk-test-5b52041f-931a-11e4-aad2-0ea81fa3d43c", 
	    auth_token, 
	    currency, 
	    id_in_merchant, 
	    "dummy Python merchant"
	)
	result = merchant.transaction(config)
	return json.dumps(result.__dict__)

@app.route("/<amount>/<auth_token>/<currency>/<id_in_merchant>/")
def do_GET(amount, auth_token, currency, id_in_merchant):
	return pierTransaction(amount, auth_token, currency, id_in_merchant)

@app.route("/", methods=['POST'])
def do_POST():
	postvars = json.loads(request.data)
	amount, auth_token, currency, id_in_merchant = \
		postvars["amount"], \
		postvars["auth_token"], \
		postvars["currency"], \
		postvars["id_in_merchant"]
	return pierTransaction(amount, auth_token, currency, id_in_merchant)
 
if __name__ == "__main__":
    app.run()