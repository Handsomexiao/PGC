//
//  PGCViewController.h
//  PGC
//
//  Created by Shuai Xiao on 10/1/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGCViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>{    
    int lastPage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@property (weak, nonatomic) IBOutlet UILabel *ImageTitle;

@property (nonatomic, retain) NSMutableDictionary *visiblePages;
@property (nonatomic, retain) NSMutableSet *recyledPages;
@property (nonatomic, retain) NSMutableArray *imageArray;


@end
