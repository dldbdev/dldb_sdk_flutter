package io.dldb.io_dldb_sdk;

import android.content.Context;
import android.location.Location;

import androidx.annotation.NonNull;

import java.time.Instant;

import io.dldb.DLDB;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * IoDldbSdkPlugin
 */
public class IoDldbSdkPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "io_dldb_sdk");
        channel.setMethodCallHandler(this);
        mContext = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else {
            if (!onMethodCallImpl(call, result))
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        mContext = null;
    }

    protected DLDB myDLDB = new DLDB();
    private Context mContext = null;

    static {
        System.loadLibrary("dldb-lib");
    }

    static protected final String dldbApiKey = "dldbApiKey";
    static protected final String eventsDictionaryAsJson = "eventsDictionaryAsJson";
    static protected final String eventsAsJson = "eventsAsJson";
    static protected final String longitudeInDegrees = "longitudeInDegrees";
    static protected final String latitudeInDegrees = "latitudeInDegrees";
    static protected final String horizontalAccuracy = "horizontalAccuracy";
    static protected final String maxEntries = "maxEntries";
    static protected final String durationInSeconds = "durationInSeconds";
    static protected final String resolution = "resolution";

    protected boolean onMethodCallImpl(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "init": {
                init(call, result);
                break;
            }
            case "heartbeat": {
                heartbeat(result);
                break;
            }
            case "runQueriesIfAny": {
                runQueriesIfAny(result);
                break;
            }
            case "close": {
                close(result);
                break;
            }
            case "addEvents": {
                addEvents(call, result);
                break;
            }
            case "addEventsWithLocation": {
                addEventsWithLocation(call, result);
                break;
            }
            case "addLocation": {
                addLocation(call, result);
                break;
            }
            case "queriesLog": {
                queriesLog(call, result);
                break;
            }
            case "locationsLog": {
                locationsLog(call, result);
                break;
            }
            default:
                return false;
        }
        return true;
    }

    protected void init(@NonNull MethodCall call, @NonNull Result result) {
        String dldbApiKey = call.argument(IoDldbSdkPlugin.dldbApiKey);
        String eventsDictionaryAsJson = call.argument(IoDldbSdkPlugin.eventsDictionaryAsJson);

        myDLDB.init(mContext, dldbApiKey, eventsDictionaryAsJson);
        result.success(true);
    }

    protected void heartbeat(@NonNull Result result) {

        myDLDB.heartbeat();
        result.success(true);
    }

    protected void runQueriesIfAny(@NonNull Result result) {
        myDLDB.runQueriesIfAny();
        result.success(true);
    }

    protected void close(@NonNull Result result) {
        myDLDB.close();
        result.success(true);
    }

    protected void addEvents(@NonNull MethodCall call, @NonNull Result result) {
        String eventsAsJson = call.argument(IoDldbSdkPlugin.eventsAsJson);

        myDLDB.addEvents(null, eventsAsJson);
        result.success(true);
    }

    protected void addEventsWithLocation(@NonNull MethodCall call, @NonNull Result result) {
        String eventsAsJson = call.argument(IoDldbSdkPlugin.eventsAsJson);
        Double longitudeInDegrees = call.argument(IoDldbSdkPlugin.longitudeInDegrees);
        Double latitudeInDegrees = call.argument(IoDldbSdkPlugin.latitudeInDegrees);
        Double horizontalAccuracy = call.argument(IoDldbSdkPlugin.horizontalAccuracy);

        final long timeUTCInMillis = Instant.now().toEpochMilli();
        Location loc = new Location("");
        if (longitudeInDegrees != null)
            loc.setLongitude(longitudeInDegrees);
        if (latitudeInDegrees != null)
            loc.setLatitude(latitudeInDegrees);
        if (horizontalAccuracy != null)
            loc.setAccuracy(horizontalAccuracy.floatValue());
        loc.setTime(timeUTCInMillis);

        myDLDB.addEvents(loc, eventsAsJson);
        result.success(true);
    }

    protected void addLocation(@NonNull MethodCall call, @NonNull Result result) {
        Double longitudeInDegrees = call.argument(IoDldbSdkPlugin.longitudeInDegrees);
        Double latitudeInDegrees = call.argument(IoDldbSdkPlugin.latitudeInDegrees);
        Double horizontalAccuracy = call.argument(IoDldbSdkPlugin.horizontalAccuracy);

        final long timeUTCInMillis = Instant.now().toEpochMilli();
        Location loc = new Location("");
        if (longitudeInDegrees != null)
            loc.setLongitude(longitudeInDegrees);
        if (latitudeInDegrees != null)
            loc.setLatitude(latitudeInDegrees);
        if (horizontalAccuracy != null)
            loc.setAccuracy(horizontalAccuracy.floatValue());
        loc.setTime(timeUTCInMillis);

        myDLDB.addEvents(loc, null);
        result.success(true);
    }

    protected void queriesLog(@NonNull MethodCall call, @NonNull Result result) {
        Integer maxEntries = call.argument(IoDldbSdkPlugin.maxEntries);
        result.success(myDLDB.queriesLog(maxEntries == null ? 0 : maxEntries));
    }

    protected void locationsLog(@NonNull MethodCall call, @NonNull Result result) {
        Integer durationInSeconds = call.argument(IoDldbSdkPlugin.durationInSeconds);
        Integer maxEntries = call.argument(IoDldbSdkPlugin.maxEntries);
        Integer resolution = call.argument(IoDldbSdkPlugin.resolution);

        result.success(myDLDB.locationsLog(
                durationInSeconds == null ? 0 : durationInSeconds,
                maxEntries == null ? 0 : maxEntries,
                resolution == null ? 0 : resolution)
        );
    }
}
