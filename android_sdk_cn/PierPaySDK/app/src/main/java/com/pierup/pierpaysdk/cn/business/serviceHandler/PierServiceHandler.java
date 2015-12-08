package com.pierup.pierpaysdk.cn.business.serviceHandler;

import android.content.Context;

import com.pierup.pierpaysdk.cn.business.PierServiceEnum;
import com.pierup.pierpaysdk.cn.business.bean.PierRootBean;
import com.pierup.pierpaysdk.cn.business.models.PierRequest;
import com.pierup.pierpaysdk.cn.business.models.PierResponse;
import com.pierup.pierpaysdk.cn.service.network.PierNetworkCallBack;

public abstract class PierServiceHandler {
    public Boolean ifNeedLoadingView;
    public Boolean ifNeedErrorAlert;
    public PierServiceEnum serverTag;
    public PierRootBean bean;
    public Context context;
    public abstract PierRequest serverHandlerRequest();
    public abstract void serverHandlerResponse(final PierNetworkCallBack callBack, final PierResponse result, final Throwable error);
}
