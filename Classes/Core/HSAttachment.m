//
//  HAAttachment.m
//  HelpApp
//
//  Created by Santhana Amuthan on 31/10/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSAttachment.h"

@implementation HSAttachment

- (id)initWithUrl:(NSString *)url fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    if (self = [super init]) {
        self.url = url;
        self.fileName = fileName;
        self.mimeType = mimeType;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nAttachment Url: %@ \nFilename: %@\nMimetype = %@", _url, _fileName, _mimeType];
}

@end
