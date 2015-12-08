package com.pierup.pierpaysdk.cn.business.models;

import java.util.HashMap;

import com.pierup.pierpaysdk.cn.business.PierObject;

public class PierRequest extends PierObject {
//    public int platform = 4;
//    public String version = PierServiceConfig.CLIENT_VERSION;
    public String device_token;
    public String country_code;
    public String phone;
    public HashMap<String, Object> metadata;
}
