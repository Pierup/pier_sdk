package com.pierup.pierpaysdk.cn.business.models;

import com.pierup.pierpaysdk.cn.business.PierObject;
import com.pierup.pierpaysdk.cn.service.utils.PierJSONObject;

public class PierResponse extends PierObject {
    public String code;
    public String message;
    public PierJSONObject resultJsonObject;
}
