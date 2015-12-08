package com.pierup.pierpaysdk.business;

import static com.pierup.pierpaysdk.business.PierServiceConfig.HTTPMethodEnum.*;
import static com.pierup.pierpaysdk.business.PierServiceConfig.*;

/**
 * Created by wangbei on 12/7/15.
 */
public enum PierServiceEnumSDK implements PierServiceEnum {

    getProvince("/common_api_cn/v1/query/all_provinces",
            GET,
            "PierRequest",
            "PierResponse",
            SERVICE_HANDLER_SDK);


    private PierServiceConfig.HTTPMethodEnum method;
    private String url;
    private String input;
    private String output;

    private String handler;

    PierServiceEnumSDK(String url, PierServiceConfig.HTTPMethodEnum method, String input, String output, String handler) {
        this.url = url;
        this.method = method;
        this.input = input;
        this.output = output;
        this.handler = handler;
    }

    @Override
    public PierServiceConfig.HTTPMethodEnum getMethod() {
        return method;
    }

    @Override
    public String getUrl() {
        return PierServiceConfig.host_production_sdk + url;
    }

    @Override
    public String getInput() {
        return PierServiceConfig.PIER_MODEL_PACKAGE + input;
    }

    @Override
    public String getOutput() {
        return PierServiceConfig.PIER_MODEL_PACKAGE + output;
    }

    @Override
    public String getHandler() {
        return PierServiceConfig.PIER_HANDLER_PACKAGE + handler;
    }
}
