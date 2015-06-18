//
//  CommonDefine.h
//  DiZiES
//
//  Created by admin on 15/5/26.
//  Copyright (c) 2015年 DiZiCompanyLimited. All rights reserved.
//
#import "Tools.h"

#ifndef DiZiES_CommonDefine_h
#define DiZiES_CommonDefine_h

#define UserInfoPath [FileManager getDocumentPathWithName:@"UserInfo.plist"] // 用户信息保存的文件

#define LoginUrl   @"http://ebsctgmgt.padccc.net/restapi/index.php/login" // 登录url

#define FloderUrl  @"http://ebsctgmgt.padccc.net/restapi/index.php/folder/" // 请求文件目录下的文件夹及文件

#define ContentUrl @"http://ebsctgmgt.padccc.net/restapi/index.php/document/"// 文件内容，共下载

#define DownloadDir [FileManager getDownloadDirPath] // 用户下载保存目录

#endif


/*
 "http://ebsctgmgt.padccc.net/restapi/index.php/login"     登录URL  
 @"http://ebsctgmgt.padccc.net/restapi/index.php/folder/1/children"  请求文件目录下的文件夹及文件
 @"http://ebsctgmgt.padccc.net/restapi/index.php/document/2/content"  文件内容
 */