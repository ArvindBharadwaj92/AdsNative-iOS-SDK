//
//  MasterViewController.h
//  TestApplication
//
//  Created by Kuldeep Kapade on 10/21/13.
//  Copyright (c) 2013 Picatcha Inc. (AdsNative). All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsViewController;
@class YouTubeViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NewsViewController *newsViewController;
@property (strong, nonatomic) YouTubeViewController *youtubeViewController;

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *collections;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
