using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Web.Script.Serialization;
using Newtonsoft.Json.Linq;
using System.Net;
using System.IO;

namespace Pier
{
	public class MerchantSDKClient {

		private string merchant_id;

		public MerchantSDKClient(string merchant_id) {
			this.merchant_id = merchant_id;
		}

		public SDKResult transaction(TransactionConfig config) {

			Newtonsoft.Json.JsonSerializerSettings jss = new Newtonsoft.Json.JsonSerializerSettings();
			Newtonsoft.Json.Serialization.DefaultContractResolver dcr = new Newtonsoft.Json.Serialization.DefaultContractResolver();
			dcr.DefaultMembersSearchFlags |= System.Reflection.BindingFlags.NonPublic;
			jss.ContractResolver = dcr;
			string configJson = Newtonsoft.Json.JsonConvert.SerializeObject(config, jss);

			JObject jo = JObject.Parse(configJson);
			jo.Add("merchant_id", this.merchant_id);
			string paramsJson = jo.ToString();

			try {
				var cli = new WebClient();
				cli.Headers[HttpRequestHeader.ContentType] = "application/json";
				String response = cli.UploadString("http://pierup.asuscomm.com:8686/merchant_api/v1/transaction/pay_by_pier", paramsJson);
				JObject responseJSON = JObject.Parse(response);
				return new SDKResult(
					(int)responseJSON.GetValue ("code")==200, 
					(string)responseJSON.GetValue ("message"), 
					(string)responseJSON.GetValue ("code"),
					responseJSON.GetValue ("result").ToObject<Dictionary<string,string>>()
				);
			} catch (WebException e) {
				string responseText = null;
				if (e.Response != null) {
					var responseStream = e.Response.GetResponseStream();

					if (responseStream != null) {
						var reader = new StreamReader (responseStream);
						responseText = reader.ReadToEnd();
					}
				}

				if (responseText != null) {
					JObject responseJSON = JObject.Parse(responseText);
					return new SDKResult(
						(int)responseJSON.GetValue ("code")==200, 
						(string)responseJSON.GetValue ("message"), 
						(string)responseJSON.GetValue ("code"), 
						responseJSON.GetValue ("result").ToObject<Dictionary<string,string>>()
					);
				} else {
					return new SDKResult(false, e.ToString(), null, null);
				}
			}
		}
	}

	public class TransactionConfig {
		private string platform = "1";
		private Double amount;
		private string api_id;
		private string api_secret_key;
		private string auth_token;
		private string currency;
		private string id_in_merchant;
		private string notes;

		public TransactionConfig(Double amount, string api_id, string api_secret_key, string auth_token, string currency, string id_in_merchant, string notes) {
			this.amount = amount;
			this.api_id = api_id;
			this.api_secret_key = api_secret_key;
			this.auth_token = auth_token;
			this.currency = currency;
			this.id_in_merchant = id_in_merchant;
			this.notes = notes;
		}

		public string getAuth_token() {
			return auth_token;
		}

		public Double getAmount() {
			return amount;
		}

		public string getCurrency() {
			return currency;
		}

		public string getId_in_merchant() {
			return id_in_merchant;
		}

		public string getNotes() {
			return notes;
		}

		public string getApi_secret_key() {
			return api_secret_key;
		}

		public string getApi_id() {
			return api_id;
		}

		public string getPlatform() {
			return platform;
		}
	}

	public class SDKResult {
		private bool status;
		private string message;
		private string code;
		private Dictionary<string, string> result;

		public SDKResult(bool status, string message, string code, Dictionary<string, string> result) {
			this.status = status;
			this.message = message;
			this.code = code;
			this.result = result;
		}

		public Dictionary<string, string> getResult() {
			return result;
		}

		public void setResult(Dictionary<string, string> result) {
			this.result = result;
		}

		public string getCode() {
			return code;
		}

		public void setCode(string code) {
			this.code = code;
		}

		public bool isStatus() {
			return status;
		}

		public void setStatus(bool status) {
			this.status = status;
		}

		public String getMessage() {
			return message;
		}

		public void setMessage(string message) {
			this.message = message;
		}

	}
}
	