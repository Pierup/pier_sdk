import json
import requests

class MerchantSDKClient:
   def __init__(self, merchant_id):
      self.merchant_id = merchant_id
   
   def transaction(self, config):
      params = config.__dict__
      params['merchant_id'] = self.merchant_id

      try:
         r = requests.post("http://pierup.ddns.net:8686/merchant_api/v1/transaction/pay_by_pier", json=params)
         returnJSON = json.loads(r.text)
         return SDKResult(returnJSON["code"]==200, returnJSON["message"], returnJSON["code"], returnJSON["result"])
      except requests.exceptions.RequestException as e:
         return SDKResult(False, e, None, None)

class TransactionConfig:
   def __init__(self, amount, api_id, api_secret_key, auth_token, currency, id_in_merchant, notes):
      self.platform = '1'
      self.amount = float(amount)
      self.api_id = api_id
      self.api_secret_key = api_secret_key
      self.auth_token = auth_token
      self.currency = currency
      self.id_in_merchant = id_in_merchant
      self.notes = notes

class SDKResult:
   def __init__(self, status, message, code, result):
      self.status = status
      self.message = message
      self.code = code
      self.result = result