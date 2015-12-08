package com.pierup.pierpaysdk.cn.business.serviceHandler;

import com.pierup.pierpaysdk.cn.business.PierServiceEnumSDK;
import com.pierup.pierpaysdk.cn.business.bean.PierSDKBean;
import com.pierup.pierpaysdk.cn.business.models.PierRequest;
import com.pierup.pierpaysdk.cn.business.models.PierResponse;
import com.pierup.pierpaysdk.cn.service.network.PierNetworkCallBack;

/**
 * Created by wangbei on 12/7/15.
 */
public class PierServiceHandlerSDK extends PierServiceHandler {

    @Override
    public PierRequest serverHandlerRequest() {
        PierRequest requestObject = null;
        PierSDKBean sdkBean = (PierSDKBean) this.bean;
        PierServiceEnumSDK enumSDK = (PierServiceEnumSDK) serverTag;
        switch (enumSDK) {
            case getProvince:
                requestObject = new PierRequest();
                break;
        }
        return requestObject;
    }

    @Override
    public void serverHandlerResponse(PierNetworkCallBack callBack, PierResponse result, Throwable error) {
        PierServiceEnumSDK enumSDK = (PierServiceEnumSDK) serverTag;
        switch (enumSDK) {
            case getProvince:
                break;
        }
        callBack.onSuccess(PierServiceHandlerSDK.this.bean, result);
    }
}
