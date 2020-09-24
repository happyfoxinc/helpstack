//  HAZendDeskArticleViewController.m
//
//Copyright (c) 2014 HelpStack (http://helpstack.io)
//
//Permission is hereby granted, free of charge, to any person obtaining a cop
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

@import WebKit;

#import "HSArticleDetailViewController.h"
#import "HSHelpStack.h"
#import "HSActivityIndicatorView.h"

#define HTML_WRAPPER_WITH_TITLE @"<!DOCTYPE html><html><head><link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'><style>body{padding: 0 8px} .heading{ font-family: 'Helvetica Neue'; font-size: 20px; color: #000000; padding: 8px 0; line-height:30px;} .content{ font-family: 'Open Sans', sans-serif;  font-size: 16px; color: #313131; line-height:30px;} p{ line-height: 30px; text-align: left !important; margin-bottom:20px;}</style></head><body><h2 class='heading'>%@</h3><div class='content'>%@</div></body></html>"

@interface HSArticleDetailViewController ()

@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) HSActivityIndicatorView *loadingView;

@end

@implementation HSArticleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.webView = [WKWebView new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loadingView = [[HSActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.loadingView];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.loadingView.hidden = YES;
    
    self.title = @"Article";
    
    NSString* content;
    if(self.article.htmlContent) {
        content = self.article.htmlContent;
        content = [self stripUnwantedHtmlTags:content];
    }
    else if(self.article.textContent) {
        content = self.article.textContent;
    }
    
    
    
    // patch the content to add title and font
    NSString* wrapperContent = [NSString stringWithFormat:HTML_WRAPPER_WITH_TITLE,  self.article.title, content];
    
    NSURL* baseUrl = [NSURL URLWithString:self.article.baseUrl];
    [self.webView loadHTMLString:wrapperContent baseURL:baseUrl];
    self.webView.navigationDelegate = self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)stripUnwantedHtmlTags:(NSString *)htmlString
{
    // Removing a empty P tags so view looks perfect
    return [htmlString stringByReplacingOccurrencesOfString:@"<p>&nbsp;</p>" withString:@""];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        [[UIApplication sharedApplication] openURL:[navigationAction.request URL]];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
}

@end
