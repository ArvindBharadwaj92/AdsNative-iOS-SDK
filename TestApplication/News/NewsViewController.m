//
//  TableViewCellController.m
//  AdsNative
//
//  Created by Santthosh on 6/2/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import "NewsViewController.h"
#import "UIImageView+WebCache.h"
#import "SVModalWebViewController.h"
#import "GTMNSString+HTML.h"
#import "AdsNative.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Toast+UIView.h"

@interface NewsViewController ()

@property (nonatomic,strong) NSMutableArray *news;

-(void)fetchNews;

@end

@implementation NewsViewController

@synthesize style,news;

- (id)initWithStyle:(UITableViewStyle)astyle {
    self = [super initWithStyle:astyle];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.news = [NSMutableArray array];

    if(self != [self.navigationController.viewControllers objectAtIndex:0]) {
        UIImage *backButtonImage = [UIImage imageNamed:@"back_arrow"];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:backButtonImage forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height);
        [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNews) forControlEvents:UIControlEventValueChanged];
    
    self.title = @"News";
    
    [self fetchNews];
}

#pragma mark - DataSource

/** Fetch AdsNative native ads **/
-(void)fetchAds {
    ANAdRequest *request = [ANAdRequest requestWithAdUnitID:@"D8TqdJ7Nc8XT5cKIzXqDayoxrrTlOwSxRUX9gslp"];
    //With Keyword targeting:
    //ANAdRequest *request = [ANAdRequest requestWithAdUnitID:@"D8TqdJ7Nc8XT5cKIzXqDayoxrrTlOwSxRUX9gslp" andKeywords:[NSArray arrayWithObjects:@"test", nil]];
    [ANSponsoredStory loadRequest:request
        onSuccess:^(ANSponsoredStory *story) {
            if([self.news count]) {
                [self.news insertObject:story atIndex:1]; //Set the position at which the native ad should be shown
            } else {
                [self.news addObject:story];
            }
            [self.tableView reloadData];
        }
        onError:^(NSError *error) {
            // Oops ad request was not successful
            NSLog(@"NSError Object: %@", error);
            NSLog(@"Error message: %@", [error.userInfo objectForKey:@"NSLocalizedDescription"]);
        }
    ];
}

- (void)fetchNews {
    [self.refreshControl beginRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://feeds.abcnews.com/abcnews/politicsheadlines"]];
        NSError* error;

        NSArray *news_obtained = [[[[NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error] objectForKey:@"responseData"] objectForKey:@"feed"] objectForKey:@"entries"];
        [news removeAllObjects];
        [news addObjectsFromArray:news_obtained];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            [self fetchAds];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return news.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}


/** Whenever ad is to be displayed, let AdsNative know that ad is being displayed and at the same time what on tap/click action should be **/
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[news objectAtIndex:indexPath.row] isKindOfClass:[ANSponsoredStory class]]) {
        ANSponsoredStory *sponsoredStory = [news objectAtIndex:indexPath.row];
        //Configure the ANSponsoredStory on select/tap action here.
        HandleSelectBlock handleSelectBlock = ^(){
            //Begin: Your code - Open the full content view of your choice
            NSLog(@"click handler in block");
            SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:sponsoredStory.url];
            [self presentModalViewController:webViewController animated:YES];
            //End: Your code
            
            //This line is important and should be called in all cases except for video ads. Pass the full content view as an argument
            if([sponsoredStory.type  isEqual: @"story"]){
                [sponsoredStory attachFullContentToView:webViewController.view];
            }
        };
        //Basically notify the ANSponsoredStory that ad is getting displayed
        [sponsoredStory attachToView:cell onSelect:handleSelectBlock];
    } else {
        [ANSponsoredStory detachSponsoredStoriesFromView:cell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NewsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    NSString *text = nil;
    NSString *name = nil;
    NSString *story_image_url = nil;
    if([[news objectAtIndex:indexPath.row] isKindOfClass:[ANSponsoredStory class]]) {
        /** Set the information provided by ANSponsoredStory, such as Title, Image, etc. to create your view **/
        ANSponsoredStory *sponsoredStory = [news objectAtIndex:indexPath.row];
        text = sponsoredStory.title;
        name = [NSString stringWithFormat:@"%@ %@", sponsoredStory.promoted_by_tag, sponsoredStory.promoted_by];
        story_image_url = sponsoredStory.thumbnail_url;
        //NSLog(@"brand image - %@", sponsoredStory.brand_image);
        cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.98039 blue:0.9411 alpha:1];
    } else {
        NSDictionary *news_item = [news objectAtIndex:indexPath.row];
        text = [news_item objectForKey:@"title"];
        name = [news_item objectForKey:@"author"];
        @try {
            //NSLog(@"%@", [[[news_item objectForKey:@"mediaGroups"] objectAtIndex:0] objectForKey:@"contents"]);
            story_image_url = [[[[[[[news_item objectForKey:@"mediaGroups"] objectAtIndex:0] objectForKey:@"contents"] objectAtIndex:0] objectForKey:@"thumbnails"] objectAtIndex:0] objectForKey:@"url"];
        }
        @catch (NSException *exception) {
            //NSLog(@"image not found");
        }
    }
    
    UITableViewCell *imageViewCell = cell;
    [cell.imageView setImageWithURL:[NSURL URLWithString:story_image_url] placeholderImage:[UIImage imageNamed:@"twitter_egg.png"] success:^(UIImage *image, BOOL cached) {
        [imageViewCell setNeedsLayout];
    } failure:^(NSError *error) {
        
    }];
    
    cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
    cell.detailTextLabel.backgroundColor = cell.contentView.backgroundColor;
    
    cell.textLabel.text = [text gtm_stringByUnescapingFromHTML];
    cell.textLabel.numberOfLines = 4;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = name;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //This function won't be called for ANSponsoredStory cell
    if(![[news objectAtIndex:indexPath.row] isKindOfClass:[ANSponsoredStory class]]) {
        NSString *webURL;
        NSDictionary *news_item = [news objectAtIndex:indexPath.row];
        webURL = [news_item objectForKey:@"url"];
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:webURL];
        [self presentModalViewController:webViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
