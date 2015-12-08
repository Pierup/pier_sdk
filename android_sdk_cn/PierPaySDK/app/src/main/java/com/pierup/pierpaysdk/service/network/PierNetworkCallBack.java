package com.pierup.pierpaysdk.service.network;

import com.pierup.pierpaysdk.business.bean.PierRootBean;
import com.pierup.pierpaysdk.business.PierObject;

public interface PierNetworkCallBack {
    void onSuccess(PierRootBean bean, PierObject result);

    void onFailure(PierRootBean bean, String result, Throwable error);

    void checkErrorResponseStatus(int code, String codeMessage, String result ,Throwable error);
}
