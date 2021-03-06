//
//  AlbumContentViewController.h
//  Memories
//
//  Created by Ruchi Varshney on 2/17/14.
//
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface AlbumContentViewController : UIViewController

@property (nonatomic) NSUInteger pageNum;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) Album *album;

- (UIView *)getPlacementView;
- (void)hidePlacementViews;
- (CGRect)placementRectForLocation:(CGPoint)location;

@end
