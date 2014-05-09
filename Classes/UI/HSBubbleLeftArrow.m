//
//  HSBubbleLeftArrow.m
//  Pods
//
//  Created by Santhana Amuthan on 08/05/14.
//
//

#import "HSBubbleLeftArrow.h"
#import "HSHelpStack.h"

@implementation HSBubbleLeftArrow

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
    [[[HSHelpStack instance] appearance] customizeBubbleArrowForLeftChatBubble:self];
}


@end
