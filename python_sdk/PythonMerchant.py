from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import urlparse

from PierSDK import MerchantSDKClient, TransactionConfig

class MerchantHandler(BaseHTTPRequestHandler):

    def pierTransaction(self, amount, auth_token, currency, order_id):
        merchant = MerchantSDKClient("MC0000014895")
        config = TransactionConfig(
            amount, 
            "5b52051a-931a-11e4-aad2-0ea81fa3d43c", 
            "mk-test-5b52041f-931a-11e4-aad2-0ea81fa3d43c", 
            auth_token, 
            currency, 
            order_id, 
            "dummy Python merchant"
        )
        result = merchant.transaction(config)
        self.wfile.write(result.__dict__)
        return
    
    def do_GET(self):
    	parsed_path = urlparse.urlparse(self.path)
    	amount, auth_token, currency, order_id = parsed_path.path.split("/")[1:]
        result = self.pierTransaction(amount, auth_token, currency, order_id)
        return

    def do_POST(self):
        length = int(self.headers['content-length'])
        postvars = urlparse.parse_qs(self.rfile.read(length), keep_blank_values=1)
        amount, auth_token, currency, order_id = \
            postvars["amount"][0], \
            postvars["auth_token"][0], \
            postvars["currency"][0], \
            postvars["order_id"][0]
        result = self.pierTransaction(amount, auth_token, currency, order_id)
        return

if __name__ == '__main__':
    server = HTTPServer(('localhost', 8080), MerchantHandler)
    print 'Starting server on port 8080...'
    server.serve_forever()