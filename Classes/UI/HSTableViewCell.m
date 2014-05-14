//
//  HSTableViewCell.m
//  HelpApp
//
//  Created by Santhana Amuthan on 19/12/13.
//  Copyright (c) 2013 Anand. All rights reserved.
//

#import "HSTableViewCell.h"

@implementation HSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        [self initialize];
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialize];
    }
    return self;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [[[HSHelpStack instance] appearance] customizeCell:self];
    [[[HSHelpStack instance] appearance] customizeTextLabel:self.textLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect {

}


@end
