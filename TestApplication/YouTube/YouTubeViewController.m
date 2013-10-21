//
//  TableViewCellController.m
//  AdsNative
//
//  Created by Santthosh on 6/2/13.
//  Copyright (c) 2013 AdsNative. All rights reserved.
//

#import "YouTubeViewController.h"
#import "UIImageView+WebCache.h"
#import "GTMNSString+HTML.h"
#import "AdsNative.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "Toast+UIView.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "SVWebViewController.h"

@interface YouTubeViewController ()

@property (nonatomic,strong) NSMutableArray *videos;

-(void)fetchVideos;

@end

@implementation YouTubeViewController

@synthesize style, videos;

- (id)initWithStyle:(UITableViewStyle)astyle {
    self = [super initWithStyle:astyle];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videos = [NSMutableArray array];
    
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
    [self.refreshControl addTarget:self action:@selector(fetchVideos) forControlEvents:UIControlEventValueChanged];
    
    self.title = @"YouTube";
    
    [self fetchVideos];
}

#pragma mark - DataSource

-(void)fetchAds {
    ANAdRequest *request = [ANAdRequest requestWithAdUnitID:@"2-cIvYDwuRBFYSgRR3Xfvt9fsC_bnsXIb1YRn47w"];
    [ANSponsoredStory loadRequest:request
                        onSuccess:^(ANSponsoredStory *story) {
                            if([self.videos count]) {
                                [self.videos insertObject:story atIndex:2];
                            } else {
                                [self.videos addObject:story];
                            }
                            [self.tableView reloadData];
                        }
                          onError:^(NSError *error) {
                              // Oops ad request was not successful
                          }];
}

- (void)fetchVideos {
    [self.refreshControl beginRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"https://gdata.youtube.com/feeds/api/users/devinsupertramp/uploads?alt=json"]];
        NSError* error;
        
        NSArray *videos_obtained = [[[NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:&error] objectForKey:@"feed"] objectForKey:@"entry"];
        [videos removeAllObjects];
        [videos addObjectsFromArray:videos_obtained];
        
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
    return videos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[videos objectAtIndex:indexPath.row] isKindOfClass:[ANSponsoredStory class]]) {
        ANSponsoredStory *sponsoredStory = [videos objectAtIndex:indexPath.row];
        HandleSelectBlock handleSelectBlock = ^(){
            //Begin: Your code - Open the full content view of your choice
            NSLog(@"click handler in block");
            SVModalWebViewController *webViewController;
            //Make sure it's a video ad. You can handle video and story ads separately. Please notice use of "embed_url" in following lines.
            if([sponsoredStory.type  isEqual: @"video"]){
                NSString *	videoHTML = [NSString stringWithFormat:videoIFrame, sponsoredStory.embed_url, self.view.frame.size.width, self.view.frame.size.height];
                webViewController = [[SVModalWebViewController alloc] initWithHTML:videoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
                [self presentModalViewController:webViewController animated:YES];
            }
            //End: Your code
            
            //This line is important and should be called in all cases except for video ads. Pass the full content view as an argument
            if([sponsoredStory.type  isEqual: @"story"]){
                [sponsoredStory attachFullContentToView:webViewController.view];
            }
        };
        [sponsoredStory attachToView:cell onSelect:handleSelectBlock];
    } else {
        [ANSponsoredStory detachSponsoredStoriesFromView:cell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VideoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:CellIdentifier];
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    NSString *text = nil;
    NSString *name = nil;
    NSString *story_image_url = nil;
    if([[videos objectAtIndex:indexPath.row] isKindOfClass:[ANSponsoredStory class]]) {
        ANSponsoredStory *sponsoredStory = [videos objectAtIndex:indexPath.row];
        text = sponsoredStory.title;
        name = [NSString stringWithFormat:@"%@ %@", sponsoredStory.promoted_by_tag, sponsoredStory.promoted_by];
        story_image_url = sponsoredStory.thumbnail_url;
        cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.98039 blue:0.9411 alpha:1];
    } else {
        NSDictionary *video = [videos objectAtIndex:indexPath.row];
        text = [[video objectForKey:@"title"] objectForKey:@"$t"];
        name = @"by Davin";
        @try {
            story_image_url = [[[[video objectForKey:@"media$group"] objectForKey:@"media$thumbnail"] objectAtIndex:0] objectForKey:@"url"];
        }
        @catch (NSException *exception) {
            NSLog(@"image not found");
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
    NSDictionary *video = [videos objectAtIndex:indexPath.row];
    NSString *videoURL = [[[video objectForKey:@"link"] objectAtIndex:0] objectForKey:@"href"];
    [self openYTVideo:videoURL];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

static NSString *videoIFrame = @"<!DOCTYPE html><html><head><meta name=\"viewport\" content=\"initial-scale = 1.0,maximum-scale = 2.0\" /><style>body{margin:0px 0px 0px 0px;} iframe {margin:0px 0px 0px 0px; border:none;}; </style></head><body><iframe src='%@' width='%0.0fpx' height='%0.0fpx' frameboder=0></iframe></body></html>";

-(void) openYTVideo:(NSString *)videoURL {
    NSError *error = NULL;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:videoURL
                                                    options:0
                                                      range:NSMakeRange(0, [videoURL length])];
    if (match) {
        NSRange videoIDRange = [match rangeAtIndex:0];
        NSString *substringForFirstMatch = [videoURL substringWithRange:videoIDRange];
        NSString *videoHTML = [NSString stringWithFormat:videoIFrame, [NSString stringWithFormat:@"http://youtube.com/embed/%@", substringForFirstMatch], self.view.frame.size.width, self.view.frame.size.height];
        SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithHTML:videoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
        [self presentModalViewController:webViewController animated:YES];
    }
}

@end
