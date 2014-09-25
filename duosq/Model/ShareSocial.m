//
//  ShareSocial.m
//  duosq
//
//  Created by juno on 14-9-25.
//  Copyright (c) 2014年 juno. All rights reserved.
//

#import "ShareSocial.h"

@implementation ShareSocial
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
@end
