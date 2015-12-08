package com.pierup.pierpaysdk;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;

import com.pierup.pierpaysdk.business.PierObject;
import com.pierup.pierpaysdk.business.bean.PierRootBean;
import com.pierup.pierpaysdk.business.bean.PierSDKBean;
import com.pierup.pierpaysdk.service.network.PierNetwork;

import static com.pierup.pierpaysdk.business.PierServiceEnumSDK.getProvince;

public class PierBaseActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pier_base);
//        setContentView(getResourseIdByName("layout", "activity_pier_base"));

        requestProvinceService();
    }

//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
//        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu.menu_pier_home, menu);
////        getMenuInflater().inflate(getResourseIdByName("menu", "menu_pier_home"), menu);
//        return true;
//    }
//
//    @Override
//    public boolean onOptionsItemSelected(MenuItem item) {
//        // Handle action bar item clicks here. The action bar will
//        // automatically handle clicks on the Home/Up button, so long
//        // as you specify a parent activity in AndroidManifest.xml.
//        int id = item.getItemId();
//
//        //noinspection SimplifiableIfStatement
//        if (id == R.id.action_settings) {
//            return true;
//        }
////        if (id == getResourseIdByName("id", "action_settings")) {
////            return true;
////        }
//
//        return super.onOptionsItemSelected(item);
//    }

    private void requestProvinceService() {
        PierSDKBean sdkBean = new PierSDKBean();
        new PierNetwork(getProvince, this, sdkBean) {
            @Override
            public void onSuccess(PierRootBean bean, PierObject result) {
                PierObject response = (PierObject) result;

            }

            @Override
            public void onFailure(PierRootBean bean, String result, Throwable error) {

            }
        }.start();
    }

    public int getResourseIdByName(String className, String name) {
        Class r = null;
        int id = 0;
        try {
            r = Class.forName(getApplicationContext().getPackageName() + ".R");

            Class[] classes = r.getClasses();
            Class desireClass = null;

            for (int i = 0; i < classes.length; i++) {
                if (classes[i].getName().split("\\$")[1].equals(className)) {
                    desireClass = classes[i];
                    break;
                }
            }

            if (desireClass != null)
                id = desireClass.getField(name).getInt(desireClass);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }

        return id;
    }
}
