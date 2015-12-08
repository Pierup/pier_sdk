package com.pierup.pierpaysdk.cn;

import android.app.Application;
import android.content.Context;

public class UIApplication extends Application {
    private static Context context;

    public static Context getContext() {
        return context;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        context = getApplicationContext();
    }
}
