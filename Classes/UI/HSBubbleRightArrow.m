//
//  HSBubbleRightArrow.m
//  Pods
//
//  Created by Santhana Amuthan on 08/05/14.
//
//

#import "HSBubbleRightArrow.h"
#import "HSHelpStack.h"

@implementation HSBubbleRightArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [[[HSHelpStack instance] appearance] customizeBubbleArrowForRightChatBubble:self];
}


@end
