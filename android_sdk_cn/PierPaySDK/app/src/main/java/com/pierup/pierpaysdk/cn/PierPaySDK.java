package com.pierup.pierpaysdk.cn;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.pierup.pierpaysdk.cn.widget.h5.PierH5Activity;

/**
 * Created by wangbei on 12/7/15.
 */
public class PierPaySDK {

    public  final static String PAY_KEY = "com.pierup.pierpaysdk.cn";

    public static void startPierPayAction(Context context, String url) {
        Intent intent = new Intent(context, PierH5Activity.class);
        Bundle bundle = new Bundle();
        bundle.putString("url", url);
        intent.putExtras(bundle);
        context.startActivity(intent);
    }

    public static void startPierPayAction(Context context) {
        Intent intent = new Intent(context, PierBaseActivity.class);
        context.startActivity(intent);
    }
}
