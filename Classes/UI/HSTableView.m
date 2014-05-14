//  HSTableView.m
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

#import "HSTableView.h"
#import "HSTableViewCell.h"

@implementation HSTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        HSAppearance* appearance = [[HSHelpStack instance] appearance];
        [appearance customizeTableView:self];
        
    }
    return self;
}

-(UIView *)getHeaderViewforFrame:(CGRect)frame forTitle:(NSString *)title{
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, 200.0, 30.0)];
    [headerView addSubview:headerTitle];
    headerTitle.text = title;
    [[[HSHelpStack instance] appearance] customizeTableHeader:headerView];
    [[[HSHelpStack instance] appearance] customizeHeaderTitle:headerTitle];
    return headerView;
}

@end
