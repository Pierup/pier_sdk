package com.pierup.pierpaysdk.business.serviceHandler;

import android.content.Context;

import com.pierup.pierpaysdk.business.PierServiceEnum;
import com.pierup.pierpaysdk.business.bean.PierRootBean;
import com.pierup.pierpaysdk.business.models.PierRequest;
import com.pierup.pierpaysdk.business.models.PierResponse;
import com.pierup.pierpaysdk.service.network.PierNetworkCallBack;

public abstract class PierServiceHandler {
    public Boolean ifNeedLoadingView;
    public Boolean ifNeedErrorAlert;
    public PierServiceEnum serverTag;
    public PierRootBean bean;
    public Context context;
    public abstract PierRequest serverHandlerRequest();
    public abstract void serverHandlerResponse(final PierNetworkCallBack callBack, final PierResponse result, final Throwable error);
}
