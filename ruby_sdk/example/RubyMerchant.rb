require 'sinatra'
require 'Pier'

def pierTransaction(params)
	merchant = MerchantSDKClient.new("MC0000014895")
	config = TransactionConfig.new(
		params['amount'], 
		"5b52051a-931a-11e4-aad2-0ea81fa3d43c", 
		"mk-test-5b52041f-931a-11e4-aad2-0ea81fa3d43c", 
		params['auth_token'], 
		params['currency'], 
		params['id_in_merchant'], 
		"dummy Ruby merchant"
	)
	result = merchant.transaction(config)
	return result.to_json
end

get '/:amount/:auth_token/:currency/:id_in_merchant' do
	pierTransaction(params)
end
 
post '/' do
  	pierTransaction(params)
end
