package com.pierup.pierpaysdk.service.utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PierJSONObject {

    private JSONObject jsonObject;

    public PierJSONObject(PierJSONObject pierJSONObject) {
        this.jsonObject = pierJSONObject.jsonObject;
    }

    public JSONObject getJsonObject() {
        return jsonObject;
    }

    public void setJsonObject(JSONObject jsonObject) {
        this.jsonObject = jsonObject;
    }

    public PierJSONObject(JSONObject jsonObject) throws JSONException {
        this.jsonObject = jsonObject;
    }

    public PierJSONObject(String json) throws JSONException {
        this.jsonObject = new JSONObject(json);
    }

    public PierJSONObject() {
        this.jsonObject = new JSONObject();
    }

    public String getMergedJson(PierJSONObject pierJSONObject ,String json) {
        String result = "";
        PierJSONObject merJson = null;
        try {
            PierJSONObject resultObj = new PierJSONObject();
        } finally {
            return result;
        }
    }

    public PierJSONObject getJSONObject(String name) {
        PierJSONObject result = new PierJSONObject();
        try {
            JSONObject newJsonObj = this.jsonObject.getJSONObject(name);
            result.setJsonObject(newJsonObj);
        } catch (JSONException e) {
            result = null;
            e.printStackTrace();
        } finally {
            return result;
        }
    }

    public String getString(String name) {
        String result = "";
        try {
            result = this.jsonObject.getString(name);
        } catch (JSONException e) {
            result = "";
            e.printStackTrace();
        } finally {
            return result;
        }
    }

    public int getInt(String name) {
        int result = 0;
        try {
            result = this.jsonObject.getInt(name);
        } catch (JSONException e) {
            result = 0;
            e.printStackTrace();
        } finally {
            return result;
        }
    }

    public JSONArray getJSONArray(String json) {
        JSONArray jsonArray = null;
        try {
            jsonArray = this.jsonObject.getJSONArray(json);
        } catch (JSONException e) {
            e.printStackTrace();
        } finally {
            return jsonArray;
        }
    }

    public void put(String key , String value) {
        try {
            this.jsonObject.put(key, value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    @Override
    public String toString() {
        return this.jsonObject.toString();
    }
}
