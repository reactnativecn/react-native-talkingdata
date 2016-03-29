/**
 * Created by tdzl2_000 on 2015-12-29.
 */
import { NativeModules } from 'react-native';

const nativeModule = NativeModules.TalkingDataAPI;


export function trackPageBegin(page_name) {
  nativeModule.trackPageBegin(page_name);
}

export function trackPageEnd(page_name) {
  nativeModule.trackPageEnd(page_name);
}

export function trackEvent(event_name, event_label, parameters) {
  nativeModule.trackEvent(event_name, event_label, parameters);
}

export function setLocation(latitude, longitude) {
  nativeModule.setLocation(latitude, longitude);
}

export function getDeviceID() {
  return new Promise(resolve=>{
    nativeModule.getDeviceID(resolve);
  })
}

export async function applyAuthCode(countryCode, mobile, requestId) {
  return await nativeModule.applyAuthCode(countryCode, mobile, requestId);
}

export async function verifyAuthCode(countryCode, mobile, authCode) {
  return await nativeModule.verifyAuthCode(countryCode, mobile, authCode);
}