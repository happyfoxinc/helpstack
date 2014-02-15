//
//  HAZendDeskArticleViewController.m
//  HelpApp
//
//  Created by Tenmiles on 22/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSArticleDetailViewController.h"
#import "HSHelpStack.h"

#define HTML_WRAPPER_WITH_TITLE @"<!DOCTYPE html><html><head><style>body{font:14.0px helvetica} .heading{}</style></head><body><h3 class='heading'>%@</h3>%@</body></html>"

@interface HSArticleDetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation HSArticleDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.loadingView];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.loadingView.hidden = YES;
    
    self.title = @"";
    
    NSString* content;
    if(self.article.htmlContent) {
        content = self.article.htmlContent;
    }
    else if(self.article.textContent) {
        content = self.article.textContent;
    }
    
    // patch the content to add title and font
    NSString* wrapperContent = [NSString stringWithFormat:HTML_WRAPPER_WITH_TITLE,  self.article.title, content];
    
    NSURL* baseUrl = [NSURL URLWithString:self.article.baseUrl];
    [self.webView loadHTMLString:wrapperContent baseURL:baseUrl];
    self.webView.scalesPageToFit = false;
    self.webView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return false;
    }
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

@end
