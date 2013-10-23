AdsNative-iOS-SDK
=================

Installing AdsNative to your XCode project
------------------------------------------

1. Clone the git repository into your desired folder 

  `git clone git@github.com:picatcha/AdsNative-iOS-SDK.git`
  
  OR download the zip by clicking on the button shown on right on Github page.
    
2. Drag and drop "AdsNative" folder from the repository to your project's root folder

![alt text](https://s3.amazonaws.com/adsnative-public/images/add-folder.png "")
  
3. Check "Copy items...", select "Create groups for.." and "Finish"

![alt text](https://s3.amazonaws.com/adsnative-public/images/copy-project.png "")

4. It should look something like this...

![alt text](https://s3.amazonaws.com/adsnative-public/images/final.png "")

5. Under "Targets -> Build Phases", add the `AdSupport.Framework`

![alt text](https://s3.amazonaws.com/adsnative-public/images/add-frameworks.png "")

![alt text](https://s3.amazonaws.com/adsnative-public/images/lookup.png "")

6. Repeat the process for `SystemConfiguration.Framework` 

Making Calls to AdsNative
-------------------------

1. Add `#import "Adsnative.h"` in your header file whenever you plan to use AdsNative 
2. Create an ANAdRequest object initializing it with zone id provided to you. You'll have to pass this object to most of requests you make to AdsNative
  ```ANAdRequest *request = [ANAdRequest requestWithAdUnitID:@"D8TqdJ7Nc8XT5cKIzXqDayoxrrTlOwSxRUX9gslp"];```
3. To request for sponsored content make a call to following non-blocking function,


    [ANSponsoredStory loadRequest:request
      onSuccess:^(ANSponsoredStory *story) {
            NSLog(@"Title: %@", story.title);
        }
      onError:^(NSError *error) {
            // Oops ad request was not successful
        }];


