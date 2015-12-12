//
//  AppDelegate.swift
//  HKUEmoji
//
//  Created by Wang Youan on 23/11/2015.
//  Copyright © 2015 Wang Youan. All rights reserved.
//

import UIKit

let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window?.tintColor = themeColor
        
        
        /**
        *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
        *  在将生成的AppKey传入到此方法中。
        *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
        *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
        *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
        */
        ShareSDK.registerApp("iosv1101",
            activePlatforms :
            [
                SSDKPlatformType.TypeSinaWeibo.rawValue,
                SSDKPlatformType.TypeTencentWeibo.rawValue,
                SSDKPlatformType.TypeDouBan.rawValue,
                SSDKPlatformType.TypeCopy.rawValue,
                SSDKPlatformType.TypeFacebook.rawValue,
                SSDKPlatformType.TypeTwitter.rawValue,
                SSDKPlatformType.TypeMail.rawValue,
                SSDKPlatformType.TypeSMS.rawValue,
                SSDKPlatformType.TypeWechat.rawValue,
                SSDKPlatformType.TypeQQ.rawValue,
                SSDKPlatformType.TypeRenren.rawValue,
                SSDKPlatformType.TypeKaixin.rawValue,
                SSDKPlatformType.TypeGooglePlus.rawValue,
                SSDKPlatformType.TypePocket.rawValue,
                SSDKPlatformType.TypeInstagram.rawValue,
                SSDKPlatformType.TypeTumblr.rawValue,
                SSDKPlatformType.TypeLinkedIn.rawValue,
                SSDKPlatformType.TypeWhatsApp.rawValue,
                SSDKPlatformType.TypeYouDaoNote.rawValue,
                SSDKPlatformType.TypeFlickr.rawValue,
                SSDKPlatformType.TypeLine.rawValue,
                SSDKPlatformType.TypeYinXiang.rawValue,
                SSDKPlatformType.TypeEvernote.rawValue
            ],
            // onImport 里的代码,需要连接社交平台SDK时触发
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.TypeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                case SSDKPlatformType.TypeRenren:
                    ShareSDKConnector.connectRenren(RennClient.classForCoder())
                case SSDKPlatformType.TypeGooglePlus:
                    ShareSDKConnector.connectGooglePlus(GPPSignIn.classForCoder(), shareClass: GPPShare.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
                switch platform
                {
                case SSDKPlatformType.TypeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo.SSDKSetupSinaWeiboByAppKey("568898243",
                        appSecret : "38a4f8204cc784f81f9f0daaf31e02e3",
                        redirectUri : "http://www.sharesdk.cn",
                        authType : SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.TypeWechat:
                    //设置微信应用信息
                    appInfo.SSDKSetupWeChatByAppId("wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
                    
                    
                case SSDKPlatformType.TypeTencentWeibo:
                    //设置腾讯微博应用信息，其中authType设置为只用Web形式授权
                    appInfo.SSDKSetupTencentWeiboByAppKey("801307650",
                        appSecret : "ae36f4ee3946e1cbb98d6965b0b2ff5c",
                        redirectUri : "http://www.sharesdk.cn")
                    
                    
                case SSDKPlatformType.TypeFacebook:
                    //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                    
                    appInfo.SSDKSetupFacebookByApiKey("107704292745179",
                        appSecret : "38053202e1a5fe26c80c753071f0b573",
                        authType : SSDKAuthTypeBoth)
                    
                    
                    
                case SSDKPlatformType.TypeTwitter:
                    //设置Twitter应用信息
                    appInfo.SSDKSetupTwitterByConsumerKey("LRBM0H75rWrU9gNHvlEAA2aOy",
                        consumerSecret : "gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G",
                        redirectUri : "http://mob.com")
                    
                case SSDKPlatformType.TypeQQ:
                    //设置QQ应用信息
                    appInfo.SSDKSetupQQByAppId("100371282",
                        appKey : "aed9b0303e3ed1e27bae87c33761161d",
                        authType : SSDKAuthTypeWeb)
                    
                    
                case SSDKPlatformType.TypeDouBan:
                    //设置豆瓣应用信息
                    appInfo.SSDKSetupDouBanByApiKey("02e2cbe5ca06de5908a863b15e149b0b", secret: "9f1e7b4f71304f2f", redirectUri: "http://www.sharesdk.cn")
                    
                    
                case SSDKPlatformType.TypeRenren:
                    //设置人人网应用信息
                    appInfo.SSDKSetupRenRenByAppId("226427", appKey: "fc5b8aed373c4c27a05b712acba0f8c3", secretKey: "f29df781abdd4f49beca5a2194676ca4", authType: SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.TypeKaixin:
                    //设置开心网应用信息
                    appInfo.SSDKSetupKaiXinByApiKey("358443394194887cee81ff5890870c7c", secretKey: "da32179d859c016169f66d90b6db2a23", redirectUri: "http://www.sharesdk.cn/")
                    
                case SSDKPlatformType.TypeGooglePlus:
                    //设置GooglePlus应用信息
                    //如果要使用demo中的key进行客户端授权的话，需要将项目的Bundle Identifiter改为 : com.mob.demoShareSDK
                    appInfo.SSDKSetupGooglePlusByClientID("232554794995.apps.googleusercontent.com", clientSecret: "PEdFgtrMw97aCvf0joQj7EMk", redirectUri: "http://localhost", authType: SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.TypePocket:
                    //设置Pocket应用信息
                    appInfo.SSDKSetupPocketByConsumerKey("11496-de7c8c5eb25b2c9fcdc2b627", redirectUri: "pocketapp1234", authType: SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.TypeInstagram:
                    //设置Instagram应用信息
                    appInfo.SSDKSetupInstagramByClientID("ff68e3216b4f4f989121aa1c2962d058", clientSecret: "1b2e82f110264869b3505c3fe34e31a1", redirectUri: "http://sharesdk.cn")
                    
                case SSDKPlatformType.TypeLinkedIn:
                    //设置LinkedIn应用信息
                    appInfo.SSDKSetupLinkedInByApiKey("ejo5ibkye3vo", secretKey: "cC7B2jpxITqPLZ5M", redirectUrl: "http://sharesdk.cn")
                    
                case SSDKPlatformType.TypeTumblr:
                    //设置Tumblr应用信息
                    appInfo.SSDKSetupTumblrByConsumerKey("2QUXqO9fcgGdtGG1FcvML6ZunIQzAEL8xY6hIaxdJnDti2DYwM", consumerSecret: "3Rt0sPFj7u2g39mEVB3IBpOzKnM3JnTtxX2bao2JKk4VV1gtNo", callbackUrl: "http://sharesdk.cn")
                    
                case SSDKPlatformType.TypeFlickr:
                    //设置Flickr应用信息
                    appInfo.SSDKSetupFlickrByApiKey("33d833ee6b6fca49943363282dd313dd", apiSecret: "3a2c5b42a8fbb8bb")
                    
                case SSDKPlatformType.TypeYouDaoNote:
                    //设置YouDaoNote应用信息
                    appInfo.SSDKSetupYouDaoNoteByConsumerKey("dcde25dca105bcc36884ed4534dab940", consumerSecret: "d98217b4020e7f1874263795f44838fe", oauthCallback: "http://www.sharesdk.cn/")
                    
                    //印象笔记分为国内版和国际版，注意区分平台
                    //设置印象笔记（中国版）应用信息
                case SSDKPlatformType.TypeYinXiang:
                    appInfo.SSDKSetupEvernoteByConsumerKey("sharesdk-7807", consumerSecret: "d05bf86993836004", sandbox: true)
                    
                    //设置印象笔记（国际版）应用信息
                case SSDKPlatformType.TypeEvernote:
                    appInfo.SSDKSetupEvernoteByConsumerKey("sharesdk-7807", consumerSecret: "d05bf86993836004", sandbox: true)
                    
                    
                default:
                    break
                }
        })
        return true
    

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

