//
//  HAAttachmentsViewController.m
//  HelpApp
//
//  Created by Santhana Amuthan on 04/11/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSAttachmentsViewController.h"
#import "HSActivityIndicatorView.h"

@interface HSAttachmentsViewController () <UIWebViewDelegate>

@property (nonatomic, strong) HSActivityIndicatorView *loadingView;

@end

@implementation HSAttachmentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    self.webView.delegate = self;
    
    if (_attachment.url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_attachment.url]];
        [self.webView loadRequest:request];
    }
    else {
        [self.webView loadData:_attachment.attachmentData MIMEType:_attachment.mimeType textEncodingName:nil baseURL:nil];
    }
    
    
    
    
	// Do any additional setup after loading the view.
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
