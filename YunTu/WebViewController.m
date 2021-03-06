//
//  WebViewController.m
//  abiz-best
//
//  Created by zhuangch on 15/7/3.
//  Copyright (c) 2015年 focustech. All rights reserved.
//

#import "WebViewController.h"
#import "AppUtil.h"

@interface WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.navigationItem.leftBarButtonItem = [AppUtil leftBarItemWithTarget:self action:@selector(popBack)];
    
//    self.reloadButton.layer.borderColor = [UIColor colorWithHexString:@"0x999999"].CGColor;
    self.reloadButton.layer.borderWidth = 1.0f;
    self.reloadButton.layer.cornerRadius = 3.0f;
    
    [self loadPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)loadPage {
//    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"xingtaixue" ofType:@"html"];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if ([fm fileExistsAtPath:fileName isDirectory:nil]) {
//        NSLog(@"YES");
//    }
//    
//    NSError *error = nil;
//    NSString *htmlString = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&error];
//    [self.webview loadHTMLString:htmlString baseURL:nil];
    
//    NSURLRequest *request =[NSURLRequest requestWithURL:self.linkUrl];
//    [self.webview loadRequest:request];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path;
    if (_isAboutYuntu) {
        path = [[NSBundle mainBundle] pathForResource:@"guanyuyuntu" ofType:@"html"];
    } else {
        path = [[NSBundle mainBundle] pathForResource:@"xingtaixue" ofType:@"html"];
    }
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webview loadHTMLString:html baseURL:baseURL];
}

- (IBAction)reloadPage:(id)sender {
    self.networkErrorView.hidden = YES;
    [self loadPage];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicatorView startAnimating] ;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.activityIndicatorView stopAnimating];
    self.webview.hidden = YES;
    self.networkErrorView.hidden = NO;
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
