package com.pierup.pierpaysdk.cn.extern;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.util.Log;

import org.apache.http.params.CoreProtocolPNames;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.UUID;


public class PierDeviceUtil {

    public static int getScreenWidth(Activity activity) {
        DisplayMetrics dm = new DisplayMetrics();
        activity.getWindowManager().getDefaultDisplay().getMetrics(dm);
        int screenWidth = dm.widthPixels;
        return screenWidth;
    }

    public static int getScreenHeight(Activity activity) {
        DisplayMetrics dm = new DisplayMetrics();
        activity.getWindowManager().getDefaultDisplay().getMetrics(dm);
        int screenWidth = dm.heightPixels;
        return screenWidth;
    }

    public static String getUUID() {
        UUID uuid = UUID.randomUUID();
        String uniqueId = uuid.toString();
        return uniqueId;
    }

    public static String getCurrentUserAgent() {
        Locale locale = Locale.CANADA;
        StringBuffer buffer = new StringBuffer();
        // Add version
        final String version = Build.VERSION.RELEASE;
        if (version.length() > 0) {
            buffer.append(version);
        } else {
            // default to "1.0"
            buffer.append("1.0");
        }
        buffer.append("; ");
        final String language = locale.getLanguage();
        if (language != null) {
            buffer.append(language.toLowerCase());
            final String country = locale.getCountry();
            if (country != null) {
                buffer.append("-");
                buffer.append(country.toLowerCase());
            }
        } else {
            // default to "en"
            buffer.append("en");
        }
        // add the model for the release build
        if ("REL".equals(Build.VERSION.CODENAME)) {
            final String model = Build.MODEL;
            if (model.length() > 0) {
                buffer.append("; ");
                buffer.append(model);
            }
        }
        final String id = Build.ID;
        if (id.length() > 0) {
            buffer.append(" Build/");
            buffer.append(id);
        }
        final String base = CoreProtocolPNames.USER_AGENT;
        ;

        return String.format(base, buffer);
    }

    public static String getMacAddress() {
        String result = "";
        String Mac = "";
        result = callCmd("busybox ifconfig", "HWaddr");

        if (result == null) {
            return "NetWork Unavailable!";
        }

        if (result.length() > 0 && result.contains("HWaddr") == true) {
            Mac = result.substring(result.indexOf("HWaddr") + 6, result.length() - 1);
            Log.i("test", "Mac:" + Mac + " Mac.length: " + Mac.length());

            if (Mac.length() > 1) {
                Mac = Mac.replaceAll(" ", "");
                result = "";
                String[] tmp = Mac.split(":");
                for (int i = 0; i < tmp.length; ++i) {
                    result += tmp[i];
                }
            }
            Log.i("test", result + " result.length: " + result.length());
        }
        return result;
    }

    public static String callCmd(String cmd, String filter) {
        String result = "";
        String line = "";
        try {
            Process proc = Runtime.getRuntime().exec(cmd);
            InputStreamReader is = new InputStreamReader(proc.getInputStream());
            BufferedReader br = new BufferedReader(is);

            while ((line = br.readLine()) != null && line.contains(filter) == false) {
                //result += line;
                Log.i("test", "line: " + line);
            }

            result = line;
            Log.i("test", "result: " + result);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static Boolean isIntentSafe(Activity activity, Intent intent) {
        PackageManager packageManager = activity.getPackageManager();
        List<ResolveInfo> activities = packageManager.queryIntentActivities(intent, 0);
        boolean isIntentSafe = activities.size() > 0;
        return isIntentSafe;
    }

    public static HashMap<String, String> installPackagesInfo(Activity activity) {
        PackageManager packageManager = activity.getPackageManager();
        List<ApplicationInfo> applicationInfos = packageManager.getInstalledApplications(0);
        HashMap<String, String> resultMap = new HashMap<String, String>();
        Iterator<ApplicationInfo> iterator = applicationInfos.iterator();
        while (iterator.hasNext()) {
            ApplicationInfo applicationInfo = iterator.next();
            String packageName = applicationInfo.packageName;// 包名
            String packageLabel = packageManager.getApplicationLabel(applicationInfo).toString();//获取label
            resultMap.put(packageLabel, packageName);
        }
        return resultMap;
    }

    public static void openAppByPackage(Activity activity, String packageName){
        Intent intent = new Intent();
        PackageManager packageManager = activity.getPackageManager();
        //"支付宝钱包" -> "com.eg.android.AlipayGphone"
        intent = packageManager.getLaunchIntentForPackage(packageName);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED | Intent.FLAG_ACTIVITY_CLEAR_TOP) ;
        activity.startActivity(intent);
    }

    // 获取设备品牌
    private static String getDeviceBrand() {
        String deviceBrand = android.os.Build.BRAND;
        return deviceBrand;
    }

    // 获取设备型号
    private static String getDeviceModel() {
        String deviceModel = android.os.Build.MODEL;
        return deviceModel;
    }

    // 获取设备相关信息
    public static HashMap<String, Object> getDeviceInfoDict() {
        HashMap<String, Object> deviceDict = new HashMap<>();
        //1. Mac Address
        deviceDict.put("mac_address", getMacAddress());

        //2. 设备品牌
        deviceDict.put("device_type", getDeviceBrand());

        //3. 经纬度
//        deviceDict.put("ld", PierLocationUtil.getInstance().getLocationDict());

        return deviceDict;
    }

//    // 获取设备Device ID
//    public static String getDeviceID() {
//        TelephonyManager telephonyManager = (TelephonyManager) UIApplication.getContext().getSystemService(UIApplication.getContext().TELEPHONY_SERVICE);
//        return telephonyManager.getDeviceId();
//    }
}
