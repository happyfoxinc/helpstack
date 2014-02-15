//
//  HATypeKB.m
//  HelpApp
//
//  Created by Tenmiles on 30/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

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
