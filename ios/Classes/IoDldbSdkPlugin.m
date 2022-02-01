#import "IoDldbSdkPlugin.h"

#import "DLDB_C.h"


@implementation IoDldbSdkPlugin
DLDB_C* myDLDB;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"io_dldb_sdk"
            binaryMessenger:[registrar messenger]];
  IoDldbSdkPlugin* instance = [[IoDldbSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
      if (![self handleMethodCallImpl: call result: result])
          result(FlutterMethodNotImplemented);
  }
}

static NSString *const NSdldbApiKey = @"dldbApiKey";
static NSString *const NSeventsDictionaryAsJson = @"eventsDictionaryAsJson";
static NSString *const NSeventsAsJson = @"eventsAsJson";
static NSString *const NSlongitudeInDegrees = @"longitudeInDegrees";
static NSString *const NSlatitudeInDegrees = @"latitudeInDegrees";
static NSString *const NShorizontalAccuracy = @"horizontalAccuracy";
static NSString *const NSmaxEntries = @"maxEntries";
static NSString *const NSdurationInSeconds = @"durationInSeconds";
static NSString *const NSresolution = @"resolution";

-(bool) handleMethodCallImpl: (FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"init"])
        [self init: call result:result];
    else if ([call.method isEqualToString:@"heartbeat"])
        [self heartbeat: result];
    else if ([call.method isEqualToString:@"runQueriesIfAny"])
        [self runQueriesIfAny: result];
    else if ([call.method isEqualToString:@"close"])
        [self close: result];
    else if ([call.method isEqualToString:@"addEvents"])
        [self addEvents: call result:result];
    else if ([call.method isEqualToString:@"addEventsWithLocation"])
        [self addEventsWithLocation: call result:result];
    else if ([call.method isEqualToString:@"addLocation"])
        [self addLocation: call result:result];
    else if ([call.method isEqualToString:@"queriesLog"])
        [self queriesLog: call result:result];
    else if ([call.method isEqualToString:@"locationsLog"])
        [self locationsLog: call result:result];
    else
        return false;
    return true;
}

- (void) init: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *dldbApiKey = call.arguments[NSdldbApiKey];
    NSString *eventsDictionaryAsJson = call.arguments[NSeventsDictionaryAsJson];

    if(myDLDB == nil)
        myDLDB = [[DLDB_C alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [myDLDB start:documentsDirectory dldbApiKey:dldbApiKey registerCallback: nil dictionary: eventsDictionaryAsJson];
    result(nil);
}

- (void) heartbeat:(FlutterResult)result {

    if(myDLDB != nil)
        [myDLDB heartbeat];
    result(nil);
}

- (void) runQueriesIfAny: (FlutterResult)result {
    if(myDLDB != nil)
        [myDLDB runQueriesIfAny];
    result(nil);
}

- (void) close:(FlutterResult)result {
    if(myDLDB != nil)
        [myDLDB close];
    result(nil);
}

- (void) addEvents: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *eventsAsJson = call.arguments[NSeventsAsJson];

    if(myDLDB != nil)
        [myDLDB addEvents: nil eventsAsJson:eventsAsJson];
    result(nil);
}

- (void) addEventsWithLocation: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *eventsAsJson = call.arguments[NSeventsAsJson];
    NSNumber *longitudeInDegrees = call.arguments[NSlongitudeInDegrees];
    NSNumber *latitudeInDegrees = call.arguments[NSlatitudeInDegrees];
    NSNumber *horizontalAccuracy = call.arguments[NShorizontalAccuracy];

    NSDate* now = [NSDate date];
    NSTimeInterval timeInSeconds = [now timeIntervalSince1970];
    NSInteger currentGMTOffset = [[NSTimeZone localTimeZone] secondsFromGMTForDate:now];
    [myDLDB addEvents: longitudeInDegrees == nil ? NAN : [longitudeInDegrees doubleValue]
        latitudeInDegrees: latitudeInDegrees == nil ? NAN : [latitudeInDegrees doubleValue]
        horizontalAccuracyInMeters: horizontalAccuracy == nil ? NAN : [horizontalAccuracy floatValue]
        epochUTCInSeconds: timeInSeconds
        offsetFromUTCInSeconds: (int32_t)currentGMTOffset
        eventsAsJson:eventsAsJson];
    result(nil);
}

- (void) addLocation: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *longitudeInDegrees = call.arguments[NSlongitudeInDegrees];
    NSNumber *latitudeInDegrees = call.arguments[NSlatitudeInDegrees];
    NSNumber *horizontalAccuracy = call.arguments[NShorizontalAccuracy];

    NSDate* now = [NSDate date];
    NSTimeInterval timeInSeconds = [now timeIntervalSince1970];
    NSInteger currentGMTOffset = [[NSTimeZone localTimeZone] secondsFromGMTForDate:now];
    [myDLDB addEvents: longitudeInDegrees == nil ? NAN : [longitudeInDegrees doubleValue]
        latitudeInDegrees: latitudeInDegrees == nil ? NAN : [latitudeInDegrees doubleValue]
        horizontalAccuracyInMeters: horizontalAccuracy == nil ? NAN : [horizontalAccuracy floatValue]
        epochUTCInSeconds: timeInSeconds
        offsetFromUTCInSeconds: (int32_t)currentGMTOffset
        eventsAsJson: nil];
    result(nil);
}

- (void) queriesLog: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *maxEntries = call.arguments[NSmaxEntries];
    NSString *queriesLog = [myDLDB queriesLog: (maxEntries == nil ? 0 : [maxEntries intValue])];
    result(queriesLog);
}

- (void) locationsLog: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *durationInSeconds = call.arguments[NSdurationInSeconds];
    NSNumber *maxEntries = call.arguments[NSmaxEntries];
    NSNumber *resolution = call.arguments[NSresolution];

    result([myDLDB locationsLog:
                    durationInSeconds == nil ? 0 : [durationInSeconds intValue]
                    maxEntries: maxEntries == nil ? 0 : [maxEntries intValue]
                    resolution: resolution == nil ? 0 : [resolution intValue]
           ]);
}


@end
