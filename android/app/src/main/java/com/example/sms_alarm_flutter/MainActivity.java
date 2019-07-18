package com.example.sms_alarm_flutter;

import android.os.Bundle;
import android.Manifest;
import android.content.pm.PackageManager;
import android.telephony.SmsManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.app.Activity;
import android.widget.Toast;
import android.content.IntentFilter;
import java.lang.Boolean;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.concurrent.CompletableFuture;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.platforms/utils";
  CompletableFuture<Boolean> m_completableFuture;
  final String SENT = "SMS_SENT";

  Boolean sendSMS(String phone, String msg) 
  {
    Boolean result = false;
    //PendingIntent sentPI = PendingIntent.getBroadcast(this, 0, new Intent(SENT), 0);
   
    /*registerReceiver(new BroadcastReceiver(){
      @Override
      public void onReceive(Context  arg0, Intent arg1) {
          switch (getResultCode())
          {
              case Activity.RESULT_OK:
                  Toast.makeText(getBaseContext(), "SMS sent", 
                          Toast.LENGTH_SHORT).show();
                  break;
              case SmsManager.RESULT_ERROR_GENERIC_FAILURE:
                  Toast.makeText(getBaseContext(), "Generic failure", 
                          Toast.LENGTH_SHORT).show();
                  break;
              case SmsManager.RESULT_ERROR_NO_SERVICE:
                  Toast.makeText(getBaseContext(), "No service", 
                          Toast.LENGTH_SHORT).show();
                  break;
              case SmsManager.RESULT_ERROR_NULL_PDU:
                  Toast.makeText(getBaseContext(), "Null PDU", 
                          Toast.LENGTH_SHORT).show();
                  break;
              case SmsManager.RESULT_ERROR_RADIO_OFF:
                  Toast.makeText(getBaseContext(), "Radio off", 
                          Toast.LENGTH_SHORT).show();
                  break;
          }
          try {
            m_completableFuture.complete(true);
          } catch (Exception e) {}
      }
    }, new IntentFilter(SENT));*/

    try {
      //m_completableFuture = new CompletableFuture<Boolean>();
      SmsManager smsManager = SmsManager.getDefault();
      //smsManager.sendTextMessage(phone, null, msg, sentPI, null);
      smsManager.sendTextMessage(phone, null, msg, null, null);
      //result = m_completableFuture.get();
    } catch (Exception ex) { 
      result = false;
    }
    return result;
  }


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
              if(call.method.equals("p_SendSMS")) {
                String num = call.argument("phone");
                String msg = call.argument("message");
                Boolean response = sendSMS(num, msg);
                result.success(response);
              } else {
                result.notImplemented();
              }
            }
        }
    );
  }
}
