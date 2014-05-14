//  HATypeKB.m
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


#import "HSKBItem.h"

@implementation HSKBItem

- (id)initAsArticle:(NSString*)title textContent:(NSString*)content kbID:(NSString*)kbID{
    if(self = [super init]) {
        self.title = title;
        self.textContent = content;
        self.itemType = HSKBItemTypeArticle;
        self.kb_id = kbID;
    }
    return self;
}

- (id)initAsArticle:(NSString*)title htmlContent:(NSString*)content baseUrl:(NSString*)baseUrl kbID:(NSString*)kbID
{
    if(self = [super init]) {
        self.title = title;
        self.htmlContent = content;
        self.baseUrl = baseUrl;
        self.itemType = HSKBItemTypeArticle;
        self.kb_id = kbID;
    }
    return self;
}

- (id)initAsSection:(NSString*)title kbID:(NSString*)kbID{
    if(self = [super init]) {
        self.title = title;
        self.itemType = HSKBItemTypeSection;
        self.kb_id = kbID;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nKBItem Title: %@ \nHtmlContent: %@\nBaseurl = %@\nKb_ID = %@\nItemType %@", _title, _htmlContent, _baseUrl, _kb_id, [self itemTypeString]];
}

- (NSString *)itemTypeString
{
    
    if (_itemType == 0) {
        return @"Article";
    }
    else if (_itemType == 1) {
        return @"Section";
    }
    
    return nil;
    
}

@end
