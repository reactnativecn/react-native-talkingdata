package cn.reactnative.modules.talkingdata;

import android.content.Context;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.tendcloud.tenddata.TCAgent;
import com.tendcloud.tenddata.TalkingDataSMS;
import com.tendcloud.tenddata.TalkingDataSMSApplyCallback;
import com.tendcloud.tenddata.TalkingDataSMSVerifyCallback;

import java.util.HashMap;

/**
 * Created by lvbingru on 1/11/16.
 */
public class TalkingDataModule extends ReactContextBaseJavaModule {

    public TalkingDataModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "TalkingDataAPI";
    }

    private static Boolean registered = false;

    public static void register(Context context, String appID, String channelID, boolean reportExceptions) {
        if (!registered) {
            if (appID != null) {
                TCAgent.init(context, appID, channelID);
            }
            else {
                TCAgent.init(context);
            }
            if (reportExceptions) {
                TCAgent.setReportUncaughtExceptions(true);
            }
            registered = true;
        }
    }

    public static void registerSMS(Context context, String appID, String secretId) {
        TalkingDataSMS.init(context, appID, secretId);
    }

    @Override
    public void initialize() {
        super.initialize();
        if (!registered) {
            register(getReactApplicationContext(), null, null, true);
        }
    }

    @Override
    public void onCatalystInstanceDestroy() {
        super.onCatalystInstanceDestroy();
    }

    @ReactMethod
    public void setLocation(Double latitude, Double longitude){
    }

    @ReactMethod
    public void trackPageBegin(String pageName){
        TCAgent.onPageStart(getReactApplicationContext(), pageName);
    }

    @ReactMethod
    public void trackPageEnd(String pageName){
        TCAgent.onPageEnd(getReactApplicationContext(), pageName);
    }

    @ReactMethod
    public void trackEvent(String eventName, String eventLabel, ReadableMap parameters){

        if (eventLabel == null) {
            TCAgent.onEvent(getReactApplicationContext(), eventName);
        }
        else {
            if (parameters == null) {
                TCAgent.onEvent(getReactApplicationContext(), eventName, eventLabel);
            }
            else {
                HashMap map = new HashMap();
                ReadableMapKeySetIterator iterator = parameters.keySetIterator();
                while (iterator.hasNextKey()) {
                    String key = iterator.nextKey();
                    ReadableType type = parameters.getType(key);
                    if (type == ReadableType.String) {
                        map.put(key, parameters.getString(key));
                    }
                    else if (type == ReadableType.Boolean) {
                        map.put(key, new Boolean(parameters.getBoolean(key)));
                    }
                    else if (type == ReadableType.Number) {
                        map.put(key, new Double(parameters.getDouble(key)));
                    }
                }
                TCAgent.onEvent(getReactApplicationContext(), eventName, eventLabel, map);
            }
        }
    }

    @ReactMethod
    public void getDeviceID(Callback callback) {
        String deviceID = TCAgent.getDeviceId(getReactApplicationContext());
        callback.invoke(deviceID==null?"":deviceID);
    }

    @ReactMethod
    public void applyAuthCode(String countryCode, String mobile, String requestId, final Promise promise) {
        if (requestId!=null) {
            TalkingDataSMS.applyAuthCode(countryCode, mobile, new TalkingDataSMSApplyCallback() {
                @Override
                public void onApplySucc(String s) {
                    promise.resolve(s);
                }

                @Override
                public void onApplyFailed(int i, String s) {
                    promise.reject(""+i,s);
                }
            });
        }
        else {
            TalkingDataSMS.reapplyAuthCode(countryCode, mobile, requestId, new TalkingDataSMSApplyCallback() {
                @Override
                public void onApplySucc(String s) {
                    promise.resolve(s);
                }

                @Override
                public void onApplyFailed(int i, String s) {
                    promise.reject(""+i,s);
                }
            });
        }
    }

    @ReactMethod
    public void verifyAuthCode(String countryCode, String mobile, String authCode, final Promise promise) {
        TalkingDataSMS.verifyAuthCode(countryCode, mobile, authCode, new TalkingDataSMSVerifyCallback() {
            @Override
            public void onVerifySucc(String s) {
                promise.resolve(s);
            }

            @Override
            public void onVerifyFailed(int i, String s) {
                promise.reject(""+i,s);
            }
        });
    }
}

