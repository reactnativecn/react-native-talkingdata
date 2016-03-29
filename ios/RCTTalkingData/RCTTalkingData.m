//
//  RCTTalkingData.m
//  RCTTalkingData
//
//  Created by LvBingru on 1/11/16.
//  Copyright © 2016 erica. All rights reserved.
//

#import "RCTTalkingData.h"
#import "TalkingData.h"
#import "TalkingDataSMS.h"
#import "RCTUtils.h"

@interface RCTSMSDelegate: NSObject <TalkingDataSMSDelegate>

@property (nonatomic, strong) RCTPromiseResolveBlock resolve;
@property (nonatomic, strong) RCTPromiseRejectBlock reject;

@end

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

+ (void)registerSMS:(NSString *)appId secret:(NSString *)secretId
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [TalkingDataSMS init:appId withSecretId:secretId];
    });
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

RCT_EXPORT_METHOD(applyAuthCode:(NSString *)countryCode
                  mobile:(NSString *)mobile
                  requestId:(NSString *)requestId
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject
                  )
{
    RCTSMSDelegate *delegate = [RCTSMSDelegate new];
    delegate.resolve = resolve;
    delegate.reject = reject;
    
    if (requestId.length) {
        [TalkingDataSMS reapplyAuthCode:countryCode mobile:mobile requestId:requestId delegate:delegate];
    }
    else {
        [TalkingDataSMS applyAuthCode:countryCode mobile:mobile delegate:delegate];
    }
}

RCT_EXPORT_METHOD(verifyAuthCode:(NSString *)countryCode
                  mobile:(NSString *)mobile
                  authCode:(NSString *)authCode
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject
                  )
{
    RCTSMSDelegate *delegate = [RCTSMSDelegate new];
    delegate.resolve = resolve;
    delegate.reject = reject;
    
    [TalkingDataSMS verifyAuthCode:countryCode mobile:mobile authCode:authCode delegate:delegate];
    
}

@end


@implementation RCTSMSDelegate

#pragma mark delegate
- (void)onApplySucc:(NSString *)requestId
{
    if (self.resolve) {
        self.resolve(requestId);
    }
}

- (void)onApplyFailed:(int)errorCode errorMessage:(NSString *)errorMessage
{
    if (self.reject) {
        self.reject([NSString stringWithFormat:@"%d",errorCode], errorMessage, nil);
    }
    
}

- (void)onVerifySucc:(NSString *)requestId
{
    if (self.resolve) {
        self.resolve(requestId);
    }
}

- (void)onVerifyFailed:(int)errorCode errorMessage:(NSString *)errorMessage
{
    if (self.reject) {
        self.reject([NSString stringWithFormat:@"%d",errorCode], errorMessage, nil);
    }
}


@end
