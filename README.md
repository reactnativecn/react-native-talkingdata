# react-native-talkingdata
React Native的TalkingData插件
## 如何安装

### 首先安装npm包

```bash
npm install @cross2d/react-native-talkingdata --save
```

### link
```bash
rnpm link
```

#### Note: rnpm requires node version 4.1 or higher


### iOS工程配置

在工程target的`Build Phases->Link Binary with Libraries`中加入`、CoreTelephony.framework、AdSupport.framework、SystemConfiguration.framework、Security.framework、CoreMotion.framework、liz.tbd`


在你工程的`AppDelegate.m`文件中添加如下代码：

```
#import "RCTTalkingData.h"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// 添加在第一行
  [RCTTalkingData registerApp:@"APPID" channelID:@"渠道号" crashReport:YES];
  ...
  ...

}

```

### 安装Android工程

在`android/app/build.gradle`里，defaultConfig栏目下添加如下代码：

```
	manifestPlaceholders = [
           TD_APPID: "talkingdata的APPID",//在此修改为你的TalkingData APPID
           APP_CHANNEL: "渠道号",
   	]
```

在你自定义的MainApplication的getPackages()函数 return Arrays.<ReactPackage>asList 中加入

```
	new TalkingDataPackage(),
```

注意导入 talkingdata的对应包

```
	import cn.reactnative.modules.talkingdata.TalkingDataPackage;
```

在你自定义的MainActivity的onCreate()中第一行加入

```
	TalkingDataModule.register(getApplicationContext(), null, null, true);
```


## 如何使用

### 引入包

```
import * as TD from 'react-native-talkingdata';
```

### API

#### TD.trackPageBegin(page_name)
#### TD.trackPageEnd(page_name)
#### TD.trackEvent(event_name, event_label, parameters)
#### TD.setLocation(latitude, longitude)
#### TD.getDeviceID()
