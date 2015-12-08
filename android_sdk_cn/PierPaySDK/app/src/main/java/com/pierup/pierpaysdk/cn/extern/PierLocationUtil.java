package com.pierup.pierpaysdk.cn.extern;

import android.content.Context;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;

import java.util.HashMap;

public class PierLocationUtil {
    private static PierLocationUtil s_LocationUtil;
    private static LocationManager manager;
    private static double latitude=0.0;
    private static double longitude =0.0;

    public static synchronized void initSharedLocation(Context context) {
        if (s_LocationUtil == null) {
            s_LocationUtil = new PierLocationUtil(context);
        }
    }

    public static synchronized PierLocationUtil getInstance() {
        return s_LocationUtil;
    }

    public PierLocationUtil(Context context) {
        manager = (LocationManager) context.getSystemService(context.LOCATION_SERVICE);//获取手机位置信息

        //获取的条件
        Criteria criteria = new Criteria();
        criteria.setAccuracy(Criteria.ACCURACY_FINE);//获取精准位置
        criteria.setCostAllowed(false);//允许产生开销
        criteria.setPowerRequirement(Criteria.POWER_LOW);//消耗大的话，获取的频率高
        criteria.setSpeedRequired(true);//手机位置移动
        criteria.setAltitudeRequired(false);//海拔

        //获取最佳provider: 手机或者模拟器上均为gps
        String bestProvider = manager.getBestProvider(criteria, true);//使用GPS卫星
        //parameter: 1. provider 2. 每隔多少时间获取一次  3.每隔多少米  4.监听器触发回调函数
        manager.requestLocationUpdates(LocationManager.PASSIVE_PROVIDER, 10*60, 50, new MyLocationListener());
    }

    /**
     * 1、GPS_PROVIDER：在室内，GPS定位基本没用，很难定位的到
     * 2、NETWORK_PROVIDER：目前大部分Android手机没有安装google官方的location manager库，大陆网络也不允许，即没有服务器来做这个事情，自然该方法基本上没法实现定位
     * 3、PASSIVE_PROVIDER：被动定位方式，当其他应用使用定位更新了定位信息，系统会保存下来，该应用接收到消息后直接读取就可以了（目前使用方式）
     * 3、可借助第三方定位（如高德或百度）
     */
    private static class MyLocationListener implements LocationListener {

        public void onLocationChanged(Location location) {
            location.getAccuracy();//精确度
            latitude = location.getLatitude();//经度
            longitude = location.getLongitude();//纬度
        }

        public void onStatusChanged(String provider, int status, Bundle extras) {

        }

        public void onProviderEnabled(String provider) {

        }

        public void onProviderDisabled(String provider) {

        }
    }

    public synchronized HashMap<String , Double> getLocationDict() {
        HashMap<String , Double> locationDict = new HashMap<String , Double>();
        locationDict.put("lat", latitude);
        locationDict.put("lon", longitude);
        return locationDict;
    }

}
