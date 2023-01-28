package com.talhaiqbal.renthouse;

 import io.flutter.app.FlutterApplication;
 import io.flutter.plugin.common.PluginRegistry;
 import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
//  import io.flutter.plugins.GeneratedPluginRegistrant;
//  import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;
// import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;

 public class Application extends FlutterApplication implements PluginRegistrantCallback {
   @Override
   public void onCreate() {
     super.onCreate();
    //  FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
   }

   @Override
   public void registerWith(PluginRegistry registry) {
    //  GeneratedPluginRegistrant.registerWith(registry);
    //   FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.messaging.FirebaseMessagingPlugin"));
   }
 }