AdsNative-iOS-SDK
=================

Installing AdsNative in your XCode project
------------------------------------------

1. Clone the git repository into your desired folder 

  `git clone git@github.com:picatcha/AdsNative-iOS-SDK.git`
  
  OR download the zip by clicking on the button shown on right of the Github page.
    
2. Drag and drop "AdsNative" folder from the repository to your project's root folder

![alt text](https://s3.amazonaws.com/adsnative-public/images/add-folder.png "")
  
3.Check "Copy items...", select "Create groups for.." and "Finish"

![alt text](https://s3.amazonaws.com/adsnative-public/images/copy-project.png "")

4.It should look something like this...

![alt text](https://s3.amazonaws.com/adsnative-public/images/final.png "")

5.Under "Targets -> Build Phases", add the `AdSupport.Framework`

![alt text](https://s3.amazonaws.com/adsnative-public/images/add-frameworks.png "")

![alt text](https://s3.amazonaws.com/adsnative-public/images/lookup.png "")

6.Repeat the process for `SystemConfiguration.Framework` 

Using AdsNative APIs
-------------------------

1. Add `#import "Adsnative.h"` in your header file whenever you plan to use AdsNative 
2. Create an ANAdRequest object initializing it with zone id provided to you. You'll have to pass this object to most of requests you make to AdsNative
  ```ANAdRequest *request = [ANAdRequest requestWithAdUnitID:@"INSERT-YOUR-ZONE-ID-HERE"];```
  For keyword targeting,
  ```ANAdRequest *request = [ANAdRequest requestWithAdUnitID:@"INSERT-YOUR-ZONE-ID-HERE" andKeywords:[NSArray arrayWithObjects:@"KEYWORD-1", @"KEYWORD-2", nil]];```
3. To request for sponsored content make a call to following non-blocking function,

    ```
    [ANSponsoredStory loadRequest:request
      onSuccess:^(ANSponsoredStory *story) {
            NSLog(@"Title: %@", story.title);
        }
      onError:^(NSError *error) {
            // Oops ad request was not successful
        }];
    ```
4. One important thing to note is that, whenever you create UIView or any UIView based class using the information provided by above ANSponsoredStory object you will have to attach that view to ANSponsoredStory object. Same goes for ViewController or native browser used by the app to open the sponsored content. This allows AdsNative track various events occuring on the sponsored content. 

Following code snippet shows an example of code that can be used in a table view,


    - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
    {
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
            [sponsoredStory attachToView:cell onSelect:handleSelectBlock];
        }
    }
    
  Notice that the user click/tap handler also needs to be passed to the attachToView function, which will handle the user's tap event and take your desired action typically open a native browser.
  
You can look at the TestApplication provided in project for detailed example and to best use AdsNative SDK.
