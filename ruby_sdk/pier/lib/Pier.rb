require 'net/http'
require 'json'

class MerchantSDKClient  
    def initialize(merchant_id)
        @merchant_id = merchant_id     
    end

    def transaction(config)
        uri = URI.parse("http://pierup.asuscomm.com:8686/merchant_api/v1/transaction/pay_by_pier")
        req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
        req.body = config.to_json(@merchant_id)

        begin
            res = Net::HTTP.start(uri.hostname, uri.port) do |http|
                http.request(req)
            end
            response = JSON.parse(res.body)
            SDKResult.new(response["code"]==200, response["message"], response["code"], response["result"])
        rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, 
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
            SDKResult.new(false, e, nil, nil)
        end
    end
end

class TransactionConfig  
    def initialize(amount, api_id, api_secret_key, auth_token, currency, id_in_merchant, notes)
        @platform = '1'  
        @amount = amount  
        @api_id = api_id
        @api_secret_key = api_secret_key  
        @auth_token = auth_token
        @currency = currency
        @id_in_merchant = id_in_merchant  
        @notes = notes      
    end

    def to_json(merchant_id)
        {
            'merchant_id' => merchant_id,
            'platform' => @platform, 
            'amount' => @amount, 
            'api_id' => @api_id, 
            'api_secret_key' => @api_secret_key, 
            'auth_token' => @auth_token, 
            'currency' => @currency,
            'id_in_merchant' => @id_in_merchant,
            'notes' => @notes
        }.to_json
    end 
end

class SDKResult  
    def initialize(status, message, code, result)  
        @status = status  
        @message = message
        @code = code  
        @result = result    
    end 

    def to_json
        {
            'status' => @status,
            'message' => @message, 
            'code' => @code, 
            'result' => @result
        }.to_json
    end  
end