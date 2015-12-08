package com.pierup.pierpaysdk.business.models;

import com.pierup.pierpaysdk.business.PierObject;
import com.pierup.pierpaysdk.service.utils.PierJSONObject;

public class PierResponse extends PierObject {
    public String code;
    public String message;
    public PierJSONObject resultJsonObject;
}
