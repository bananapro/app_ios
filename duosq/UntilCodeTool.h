//  Created by jiangwei.wu on 13-4-11.
//  Copyright (c) 2013年 mxy. All rights reserved.
//

#if	TARGET_IPHONE_SIMULATOR
#define FL_DEBUG_MODEL	1
#else
#define FL_DEBUG_MODEL	0
#endif

#define INVALIDED_URL_NUMBER    -1

#define SAFE_RELEASE(instanse)  [instanse release], instanse = nil

#define SAFE_INSTANCE_CHECK_RETURN(instanse, returnValue)    if(!(instanse)) {return returnValue;}

#define SAFE_INSTANCE_CHECK(instanse)    if(!(instanse)) {return;}

#define GET_SYSTEM_EXACTLY_TIME

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#if  FL_DEBUG_MODEL
#define debug_NSLog(format,...) NSLog((@"<%@:(%d)> %s: " format),[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,__PRETTY_FUNCTION__,##__VA_ARGS__)
#define debug_NSAssert(condition, desc, ...) NSAssert(condition, desc, ##__VA_ARGS__)
#else
#define debug_NSLog(...)  NSLog(__VA_ARGS__)
#define debug_NSAssert(condition, desc, ...) 0
#endif

#define FL_FUNCTION_BINDVIERTUALUSER() \
{\
UserData* udata = [[DataManager sharedDataManager] getUser];\
if ([udata isVirtualUser])\
{\
[[SceneManager sharedSceneManager] showViewController:[ControllerGenerator upgradeContainerViewController] withStyle:FL_SCENE_SHOW_PRESENT];\
return;\
}\
}


//NSCoding实现 目前不支持class有数据成员存在
#define FL_FUNCTION_NSCODINGIMP()\
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
unsigned int num = 0;\
Ivar* var = class_copyIvarList([self class], &num);\
for (int i = 0; i < num; i++)\
{\
const char* name = ivar_getName(*(var+i));\
id v = object_getIvar(self, *(var+i));\
if (nil != v)\
{\
[aCoder encodeObject:v forKey:[NSString stringWithUTF8String:name]];\
}\
}\
}\
\
- (id)initWithCoder:(NSCoder *)aDecoder\
{\
self = [super init];\
if (self)\
{\
unsigned int num = 0;\
Ivar* var = class_copyIvarList([self class], &num);\
for (int i = 0; i < num; i++)\
{\
const char* name = ivar_getName(*(var+i));\
id v = [aDecoder decodeObjectForKey:[NSString stringWithUTF8String:name]];\
object_setIvar(self, *(var+i), [v retain]);\
}\
}\
return self;\
}