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
        [[[HSHelpStack instance] appearance] customizeBubbleArrowForLeftChatBubble:self];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        [[[HSHelpStack instance] appearance] customizeBubbleArrowForLeftChatBubble:self];
    }
    return self;
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}


@end
