//
//  HSReportIssueCell.m
//  Pods
//
//  Created by Santhana Amuthan on 13/05/14.
//
//

#import "HSReportIssueCell.h"
#import "HSHelpStack.h"

@interface HSReportIssueCell ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation HSReportIssueCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [[[HSHelpStack instance] appearance] customizeTextLabel:self.textLabel];
        self.textLabel.textColor = [UIColor colorWithRed:233.0/255.0f green:76.0/255.0f blue:67.0/255.0f alpha:1.0];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        [[[HSHelpStack instance] appearance] customizeTextLabel:self.textLabel];
        self.textLabel.textColor = [UIColor colorWithRed:233.0/255.0f green:76.0/255.0f blue:67.0/255.0f alpha:1.0];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) drawRect:(CGRect)rect {

}

@end
