/**
 * Created by tdzl2_000 on 2015-12-29.
 */
import { NativeModules } from 'react-native';
import promisify from 'es6-promisify';

const nativeModule = NativeModules.TalkingDataAPI;

function translateError(err, result) {
  if (!err) {
    return this.resolve(result);
  }
  if (typeof err === 'object') {
    if (err instanceof Error) {
      return this.reject(ret);
    }
    const {message, ...other} = err;
    return this.reject(Object.assign(new Error(err.message), other));
  } else if (typeof err === 'string') {
    return this.reject(new Error(err));
  }
  this.reject(Object.assign(new Error(), { origin: err }));
}

function wrapApi(nativeFunc, argCount) {
  if (!nativeFunc) {
    return undefined;
  }
  const promisified = promisify(nativeFunc, translateError);
  if (argCount != undefined){
    return (...args) => {
      let _args = args;
      if (_args.length < argCount) {
        _args[argCount - 1] = undefined;
      } else if (_args.length > argCount){
        _args = _args.slice(0, args);
      }
      return promisified(..._args);
    };
  } else {
    return () => {
      return promisified();
    };
  }
}

export function trackPageBegin(page_name) {
  nativeModule.trackPageBegin(page_name)
}

export function trackPageEnd(page_name) {
  nativeModule.trackPageEnd(page_name)
}

export function trackEvent(event_name, event_label, parameters) {
  nativeModule.trackEvent(event_name, event_label, parameters)
}

export function setLocation(latitude, longitude) {
  nativeModule.setLocation(latitude, longitude)
}

export const getDeviceID = wrapApi(nativeModule.getDeviceID);

