//
//  UDTicketViewController.m
//  UdeskSDK
//
//  Created by xuchen on 15/11/26.
//  Copyright (c) 2015年 xuchen. All rights reserved.
//

#import "UDTicketViewController.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_0
#import <JavaScriptCore/JavaScriptCore.h>
#else

#endif

@interface UDTicketViewController ()

@end

@implementation UDTicketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"提交问题", @"");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:Config.ticketTitleColor}];
    
    NSString *key = [UDManager key];
    NSString *domain = [UDManager domain];
    
    if (![UDTools isBlankString:key]||[UDTools isBlankString:domain]) {
        
        _ticketWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, MDK_SCREEN_WIDTH, MDK_SCREEN_HEIGHT-44-kStatusBarHeight)];
        _ticketWebView.backgroundColor=[UIColor whiteColor];
        
        NSURL *ticketURL = [UDManager getSubmitTicketURL];
        
        [_ticketWebView loadRequest:[NSURLRequest requestWithURL:ticketURL]];
        
        [self.view addSubview:_ticketWebView];
        
        [_ticketWebView stringByEvaluatingJavaScriptFromString:@"ticketCallBack()"];
        
        if (isIOS7) {
            JSContext *ticketContext = [self.ticketWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
            
            ticketContext[@"ticketCallBack"] = ^() {
                
                NSArray *args = [JSContext currentArguments];
                
                for (JSValue *uDVal in args) {
                    
                    NSString *jsValString = [NSString stringWithFormat:@"%@",uDVal];
                    
                    if ([jsValString isEqualToString:@"200"]) {
                        
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"工单提交成功" message:@"客服收到您的工单会第一时间答复您" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                        
                    }
                    
                }
                
            };
            
        }
        
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    if (isIOS6) {
        self.navigationController.navigationBar.tintColor = Config.oneSelfNavcigtionColor;
    } else {
        self.navigationController.navigationBar.barTintColor = Config.oneSelfNavcigtionColor;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    if (self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
    
    if (isIOS6) {
        self.navigationController.navigationBar.tintColor = Config.ticketNavigationColor;
    } else {
        self.navigationController.navigationBar.barTintColor = Config.ticketNavigationColor;
        self.navigationController.navigationBar.tintColor = Config.ticketBackButtonColor;
    }
    
}


@end