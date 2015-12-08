package com.pierup.pierpaysdk.business;

public class PierServiceConfig {
    /** 版本号 */
    public static final String  CLIENT_VERSION = "1.0.0";
    public static final String CHARSET  = "UTF-8";
    public static final int SUCCESS_CODE = 200;
    public static final int WARMING_CODE = 500;
    public static final int SESSION_EXPIRE = 1001;
    public static final int DEVICE_TOKEN_EXPIRE = 1002;
    public static final int PASSWORD_ERROR = 1030;
    public static final int ACCOUNT_LOCKED = 2009;


    public static final int PLATFORM = 4;
    public static final int PIER_HTTP_PORT = 8080;
    public static final int PIER_HTTPS_PORT = 443;
    public static final int PIER_HTTP_DEFAULT_TIMEOUT = 15000;
    public static final int PIER_HTTP_UPDATE_TIMEOUT = PIER_HTTP_DEFAULT_TIMEOUT*12;

    public static final String PIER_MODEL_PACKAGE = "com.pierup.pierpaysdk.business.models.";
    public static final String PIER_HANDLER_PACKAGE = "com.pierup.pierpaysdk.business.serviceHandler.";

    public static final String SERVICE_HANDLER_USER = "PierServiceHandlerUser";
    public static final String SERVICE_HANDLER_COMMON = "PierServiceHandlerCommon";
    public static final String SERVICE_HANDLER_CUSTOM = "PierServiceHandlerCustom";
    public static final String SERVICE_HANDLER_MERCHANT = "PierServiceHandlerMerchant";
    public static final String SERVICE_HANDLER_INSTALLMENT = "PierServiceHandlerInstallment";
    public static final String SERVICE_HANDLER_STATEMENT = "PierServiceHandlerStatement";

    public static final String SERVICE_HANDLER_SDK = "PierServiceHandlerSDK";
    public static final String host_production_sdk = "https://api.pierup.cn";

//    public static final String host_production_common = "https://pierup.asuscomm.com:443";
//    public static final String host_production_user = "https://pierup.asuscomm.com:443";
//    public static final String host_production_merchant = "https://pierup.asuscomm.com:443";

//    public static final String host_production_common = "https://api.pierup.cn";
//    public static final String host_production_user = "https://api.pierup.cn";
//    public static final String host_production_merchant = "https://api.pierup.cn";

//
//    public static final String pier_shop_home_url = "http://pierup.asuscomm.com:6060/pierShop";
//    public static final String pier_payment_url = "http://pierup.asuscomm.com:4000/mobile/pierSDK";

//      public static final String pier_shop_home_url = "http://192.168.1.12:6060/pierShop";
//      public static final String pier_payment_url = "http://192.168.1.12:6060/mobile/pierSDK";

    public static final String pier_shop_home_url = "http://www.pierup.cn:6060/pierShop";
    public static final String pier_payment_url = "http://www.pierup.cn:6060/mobile/pierSDK";

    public static final String PIER_SCHEME_SHOP = "piershop";
    public static final String PIER_SCHEME_PAY = "pierpay";
    public static final String PIER_SCHEME_TEL = "tel";

    public static final String api_query = "?platform="+PLATFORM+"&version="+CLIENT_VERSION;


    public enum HTTPMethodEnum {
        POST, POST_JSON, GET, UploadFile;
    }

}
