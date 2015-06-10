using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using Newtonsoft.Json.Linq;
using Pier;

namespace CSMerchant.Controllers
{
	public class HomeController : Controller {

		private JsonResult pierTransaction(double amount, string auth_token, string currency, string id_in_merchant) {
			MerchantSDKClient merchant = new MerchantSDKClient("MC0000014895");
			TransactionConfig config = new TransactionConfig(
				amount, 
				"5b52051a-931a-11e4-aad2-0ea81fa3d43c", 
				"mk-test-5b52041f-931a-11e4-aad2-0ea81fa3d43c", 
				auth_token, 
				currency, 
				id_in_merchant, 
				"dummy C# merchant"
			);
			SDKResult result = merchant.transaction(config);

			return Json(
				new {
					status=result.isStatus (), 
					message=result.getMessage (), 
					code=result.getCode (), 
					result=result.getResult ()
				}, 
				JsonRequestBehavior.AllowGet
			);
		}

		public ActionResult do_GET (double amount, string auth_token, string currency, string id_in_merchant) {
			return pierTransaction (amount, auth_token, currency, id_in_merchant);
		}

		[HttpPost]
		public ActionResult do_POST () {
			StreamReader stream = new StreamReader(this.Request.InputStream);
			string json = stream.ReadToEnd();
			JObject requestJSON = JObject.Parse(json);

			double amount = (double) requestJSON["amount"];
			string auth_token = (string) requestJSON["auth_token"];
			string currency = (string) requestJSON["currency"];
			string id_in_merchant = (string) requestJSON["id_in_merchant"];

			return pierTransaction (amount, auth_token, currency, id_in_merchant);
		}

		public ActionResult Index () {
			return View ();
		}
	}
}

