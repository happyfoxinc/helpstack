//  HSAppearance.h
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


#import <UIKit/UIKit.h>

@interface HSAppearance : NSObject

@property (nonatomic, strong) NSDictionary *customThemeProperties;

+ (id)instance;

- (UIColor *)getBackgroundColor;
- (void)customizeNavigationBar:(UINavigationBar *)navigationBar;
- (void)customizeTableView:(UITableView *)tableView;
- (void)customizeTableHeader:(UIView *)view;
- (void)customizeHeaderTitle:(UILabel *)title;
- (void)customizeCell:(UITableViewCell *)cell;
- (void)customizeTextLabel:(UILabel *)title;
- (void)customizeSmallTextLabel:(UILabel *)title;
- (void)customizeTextView:(UITextView *)textView;
- (void)customizeButton:(UIButton *)button;
- (void)customizeRightBubble:(UIView *)bubble;
- (void)customizeLeftBubble:(UIView *)bubble;
- (UIFont *)getBubbleTextFont;
-(void)customizeRightBubbleText:(UITextView *)BubbleText;
-(void)customizeLeftBubbleText:(UITextView *)BubbleText;
-(void) customizeBubbleArrowForRightChatBubble:(UIView *)arrowView;
-(void) customizeBubbleArrowForLeftChatBubble:(UIView *)arrowView;

+ (BOOL)isTall;
+ (BOOL)isIPad;
+ (BOOL)isIOS6;


@end
