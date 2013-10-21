//
//  MasterViewController.m
//  TestApplication
//
//  Created by Kuldeep Kapade on 10/21/13.
//  Copyright (c) 2013 Picatcha Inc. (AdsNative). All rights reserved.
//

#import "MasterViewController.h"

#import "NewsViewController.h"
#import "YouTubeViewController.h"

#define kTitle @"kTitle"
#define kImage @"kImage"

@implementation MasterViewController

@synthesize titles,collections;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AdsNative", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);;
        }
    }
    return self;
}

-(void)viewDidLoad {
    NSMutableArray *tableViews = [NSMutableArray arrayWithObjects:
                                  [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"News",@"news.png",nil] forKeys:[NSArray arrayWithObjects:kTitle,kImage,nil]],
                                  [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"YouTube",@"youtube.png",nil] forKeys:[NSArray arrayWithObjects:kTitle,kImage,nil]],
                                  nil];
    self.collections = [NSMutableArray arrayWithObject:tableViews];
    self.titles = [NSMutableArray arrayWithObject:@"Applications"];
    [super viewDidLoad];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *collection = [self.collections objectAtIndex:section];
    return [collection count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.titles objectAtIndex:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    NSArray *collection = [self.collections objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [collection objectAtIndex:indexPath.row];
    cell.textLabel.text = [dictionary objectForKey:kTitle];
    cell.imageView.image = [UIImage imageNamed:[dictionary objectForKey:kImage]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UITableViewCellStyle style = UITableViewCellStyleSubtitle;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if(indexPath.row == 0) {
                self.newsViewController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
                self.newsViewController.style = style;
                [self.navigationController pushViewController:self.newsViewController animated:YES];
            }
            if(indexPath.row == 1) {
                self.youtubeViewController = [[YouTubeViewController alloc] initWithNibName:@"YouTubeViewController" bundle:nil];
                self.youtubeViewController.style = style;
                [self.navigationController pushViewController:self.youtubeViewController animated:YES];
            }
        } else {
            self.newsViewController.style = style;
        }
    }
}

@end
