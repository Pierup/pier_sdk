package com.pierup.pierpaysdk.business.models;

import org.json.JSONObject;

import java.util.HashMap;

import com.pierup.pierpaysdk.business.PierServiceConfig;
import com.pierup.pierpaysdk.business.PierObject;

public class PierRequest extends PierObject {
//    public int platform = 4;
//    public String version = PierServiceConfig.CLIENT_VERSION;
    public String device_token;
    public String country_code;
    public String phone;
    public HashMap<String, Object> metadata;
}
