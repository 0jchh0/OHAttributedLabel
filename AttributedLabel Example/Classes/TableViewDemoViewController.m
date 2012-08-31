//
//  TableViewDemoViewController.m
//  AttributedLabel Example
//
//  Created by Olivier Halligon on 31/08/12.
//
//

#import "TableViewDemoViewController.h"
#import "OHAttributedLabel.h"
#import "UIAlertView+Commodity.h"

@interface TableViewDemoViewController () <OHAttributedLabelDelegate>
@property(nonatomic, retain) NSArray* texts;
@end


@implementation TableViewDemoViewController
@synthesize texts = _texts;

/////////////////////////////////////////////////////////////////////////////
#pragma mark - Init/Dealloc
/////////////////////////////////////////////////////////////////////////////

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        NSMutableArray* entries = [NSMutableArray arrayWithObjects:
                                   @"Visit http://www.apple.com now!",
                                   @"Go to http://www.foodreporter.net !",
                                   @"Start a search on http://www.google.com",
                                   nil];
        for(int i=0; i<20;++i)
        {
            [entries addObject:[NSString stringWithFormat:@"Call +1555-000-%04d from your iPhone", i]];
        }
        self.texts = entries;
        [self.tableView reloadData];
    }
    return self;
}



/////////////////////////////////////////////////////////////////////////////
#pragma mark - TableView DataSource
/////////////////////////////////////////////////////////////////////////////

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.texts count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* const kCellIdentifier = @"SomeCell";
    static NSInteger const kAttributedLabelTag = 100;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    OHAttributedLabel* attrLabel = nil;
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        
        attrLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(10,10,300,tableView.rowHeight-20)];
        attrLabel.textAlignment = UITextAlignmentCenter;
        attrLabel.centerVertically = YES;
        attrLabel.font = [UIFont systemFontOfSize:16];
        attrLabel.automaticallyAddLinksForType = NSTextCheckingAllTypes;
        attrLabel.delegate = self;
        attrLabel.tag = kAttributedLabelTag;
        [cell addSubview:attrLabel];
        
#if ! __has_feature(objc_arc)
        [attrLabel autorelease];
        [cell autorelease];
#endif
    }
    
    attrLabel = (OHAttributedLabel*)[cell viewWithTag:kAttributedLabelTag];
    attrLabel.text = [self.texts objectAtIndex:indexPath.row];
    return cell;
}



/////////////////////////////////////////////////////////////////////////////
#pragma mark - OHAttributedLabel Delegate Method
/////////////////////////////////////////////////////////////////////////////

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    if ([[UIApplication sharedApplication] canOpenURL:linkInfo.extendedURL])
    {
        return YES;
    }
    else
    {
        // Unsupported link type (especially phone links are not supported on Simulator, only on device)
        [UIAlertView showWithTitle:@"Link tapped" message:[NSString stringWithFormat:@"Should open link: %@", linkInfo.extendedURL]];
        return NO;
    }
}

@end
