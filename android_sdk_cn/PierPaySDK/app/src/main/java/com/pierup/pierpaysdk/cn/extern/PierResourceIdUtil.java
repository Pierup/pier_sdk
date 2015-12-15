package com.pierup.pierpaysdk.cn.extern;

import android.content.Context;

/**
 * Created by wangbei on 12/15/15.
 */
public class PierResourceIdUtil {

    public static int getResourseIdByName(Context context, String className, String name) {
        Class r = null;
        int id = 0;
        try {
            r = Class.forName(context.getPackageName() + ".R");

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
