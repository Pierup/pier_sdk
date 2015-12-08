package com.pierup.pierpaysdk;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import com.pierup.pierpaysdk.business.PierObject;
import com.pierup.pierpaysdk.business.models.PierPayOrder;
import com.pierup.pierpaysdk.utils.h5.PierH5Activity;

/**
 * Created by wangbei on 12/7/15.
 */
public class PierPaySDK {

    public  final static String PAY_KEY = "com.pierup.pierpaysdk";

    public static void startPierPayAction(Context context, PierPayOrder payOrder) {
        Intent intent = new Intent(context, PierBaseActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable(PAY_KEY, payOrder);
        intent.putExtras(bundle);
        context.startActivity(intent);
    }

    public static void startPierPayAction(Context context, String url) {
        Intent intent = new Intent(context, PierH5Activity.class);
        Bundle bundle = new Bundle();
        bundle.putString("url", url);
        intent.putExtras(bundle);
        context.startActivity(intent);
    }
}
