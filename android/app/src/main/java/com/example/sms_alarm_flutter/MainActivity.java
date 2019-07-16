package com.example.sms_alarm_flutter;

import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.Manifest;
import android.content.pm.PackageManager;
import android.telephony.SmsManager;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.platforms/utils";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
              if(call.method.equals("p_SendSMS")) {
                if(isSmsPermissionGranted()) {
                  String num = call.argument("phone");
                  String msg = call.argument("message");
                  try {
                    SmsManager smsManager = SmsManager.getDefault();
                    smsManager.sendTextMessage(num, null, msg, null, null);
                  } catch (Exception ex) { }
                } else {
                  requestSmsPermission();
                }
                result.success(null);
              } else {
                result.notImplemented();
              }
            }
        }
    );
  }

  public boolean isSmsPermissionGranted() {
    return ActivityCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED;
  }

  public void requestSmsPermission() {
    ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.SEND_SMS}, 100);
  }
}
