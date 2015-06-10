
﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace CSMerchant
{
	public class MvcApplication : System.Web.HttpApplication {
		
		public static void RegisterRoutes (RouteCollection routes) {
			
			routes.IgnoreRoute ("{resource}.axd/{*pathInfo}");

			routes.MapRoute (
				"Pier_GET",
				"{amount}/{auth_token}/{currency}/{id_in_merchant}",
				new { controller = "Home", action = "do_GET", id = "" }
			);

			routes.MapRoute (
				"Pier_POST",
				"{*path}",
				new { controller = "Home", action = "do_POST", id = "" }
			);

		}

		public static void RegisterGlobalFilters (GlobalFilterCollection filters) {
			filters.Add (new HandleErrorAttribute ());
		}

		protected void Application_Start () {
			AreaRegistration.RegisterAllAreas ();
			RegisterGlobalFilters (GlobalFilters.Filters);
			RegisterRoutes (RouteTable.Routes);
		}
	}
}
