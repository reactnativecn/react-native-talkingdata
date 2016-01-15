//
//  RCTTalkingData.m
//  RCTTalkingData
//
//  Created by LvBingru on 1/11/16.
//  Copyright © 2016 erica. All rights reserved.
//

#import "RCTTalkingData.h"
#import "TalkingData.h"
#import "RCTUtils.h"

@implementation RCTTalkingData

RCT_EXPORT_MODULE(TalkingDataAPI)

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (void)registerApp:(NSString *)appId channelID:(NSString *)channelID crashReport:(BOOL)report
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (report) {
            [TalkingData setExceptionReportEnabled:YES];
            [TalkingData setSignalReportEnabled:YES];
        }
        [TalkingData sessionStarted:appId withChannelId:channelID];
    });
    
#ifdef DEBUG
    [TalkingData setLogEnabled:YES];
#endif
}

RCT_EXPORT_METHOD(trackPageBegin:(NSString *)page_name)
{
    [TalkingData trackPageBegin:page_name];
}

RCT_EXPORT_METHOD(trackPageEnd:(NSString *)page_name)
{
    [TalkingData trackPageEnd:page_name];
}

RCT_EXPORT_METHOD(trackEvent:(NSString *)event_name label:(NSString *)event_label parameters:(NSDictionary *)parameters)
{
    if (event_label == nil) {
        [TalkingData trackEvent:event_name];
    }
    else if (parameters == nil){
        [TalkingData trackEvent:event_name label:event_label];
    }
    else {
        [TalkingData trackEvent:event_name label:event_label parameters:parameters];
    }
}

RCT_EXPORT_METHOD(setLocation:(double)latitude longitude:(double)longitude)
{
    [TalkingData setLatitude:latitude longitude:longitude];
}

RCT_EXPORT_METHOD(getDeviceID:(RCTResponseSenderBlock)callback)
{
    NSString *deviceID = [TalkingData getDeviceID];
    if (callback) {
        callback(@[RCTNullIfNil(deviceID)]);
    }
}

RCT_EXPORT_METHOD(setLogEnabled:(BOOL)enabled)
{
    [TalkingData setLogEnabled:enabled];
}

@end
