//
//  HSTableFooterCreditsView.m
//  Pods
//
//  Created by Santhana Amuthan on 14/05/14.
//
//

#import "HSTableFooterCreditsView.h"
#import "HSLabel.h"

@implementation HSTableFooterCreditsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        HSLabel* poweredlabel = [[HSLabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 30)];
        [poweredlabel setFont:[UIFont systemFontOfSize:12]];
        [poweredlabel setTextAlignment:NSTextAlignmentCenter];
        [poweredlabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [poweredlabel setTextColor:[UIColor colorWithRed:(197.0/255.0) green:(197.0/255.0) blue:(197.0/255.0) alpha:1.0]];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Powered by HelpStack"];
        [attributedString beginEditing];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont boldSystemFontOfSize:12]
                                 range:NSMakeRange(11, 9)];
        [attributedString endEditing];
        
        [poweredlabel setAttributedText:attributedString];
        [self addSubview:poweredlabel];
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
