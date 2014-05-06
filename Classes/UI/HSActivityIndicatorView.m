//
//  HSActivityIndicatorView.m
//  Pods
//
//  Created by Nalin on 06/05/14.
//
//

#import "HSActivityIndicatorView.h"

@implementation HSActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if ([[UIApplication sharedApplication] statusBarStyle] == UIStatusBarStyleDefault) {
            self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
        else {
            self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
