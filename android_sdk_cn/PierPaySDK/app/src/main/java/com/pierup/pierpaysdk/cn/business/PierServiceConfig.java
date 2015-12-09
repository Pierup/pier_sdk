package com.pierup.pierpaysdk.cn.business;

import com.pierup.pierpaysdk.cn.extern.PierDeviceUtil;

public class PierServiceConfig {

    public static final int PLATFORM = 4;
    public static final String CLIENT_VERSION = "1.0.0";
    public static final String CHARSET  = "UTF-8";
    public static final int SUCCESS_CODE = 200;
    public static final int WARMING_CODE = 500;
    public static final int SESSION_EXPIRE = 1001;

    public static final int PIER_HTTP_PORT = 8080;
    public static final int PIER_HTTPS_PORT = 443;
    public static final int PIER_HTTP_DEFAULT_TIMEOUT = 15000;
    public static final int PIER_HTTP_UPDATE_TIMEOUT = PIER_HTTP_DEFAULT_TIMEOUT*12;

    public static final String PIER_MODEL_PACKAGE = "com.pierup.pierpaysdk.cn.business.models.";
    public static final String PIER_HANDLER_PACKAGE = "com.pierup.pierpaysdk.cn.business.serviceHandler.";

    public static final String SERVICE_HANDLER_SDK = "PierServiceHandlerSDK";
    public static final String host_production_sdk = "https://api.pierup.cn";

    public static final String api_query = "?platform="+PLATFORM+"&version="+CLIENT_VERSION;

    public enum HTTPMethodEnum {
        POST, POST_JSON, GET, UploadFile;
    }
}
