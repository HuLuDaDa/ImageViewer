//
//  LWQImageViewerVC.h
//  AnXinChat
//
//  Created by 李文强 on 2019/8/14.
//  Copyright © 2019 李文强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWQImageViewerVC : UIViewController{
    int ind;
}
//图片浏览器
@property (nonatomic, strong) NSMutableArray *imageArray;
- (instancetype)initWithImageArray:(NSMutableArray *)imageArray andPageIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
