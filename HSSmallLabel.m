//
//  HSSmallLabel.m
//  Pods
//
//  Created by Santhana Amuthan on 08/05/14.
//
//

#import "HSSmallLabel.h"
#import "HSHelpStack.h"

@implementation HSSmallLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        [[[HSHelpStack instance] appearance] customizeSmallTextLabel:self];
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
