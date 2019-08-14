//
//  LWQImageViewerVC.m
//  AnXinChat
//
//  Created by 李文强 on 2019/8/14.
//  Copyright © 2019 李文强. All rights reserved.
//

#import "LWQImageViewerVC.h"

@interface LWQImageViewerVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIPageControl *pageController;
@end

@implementation LWQImageViewerVC
- (instancetype)initWithImageArray:(NSMutableArray *)imageArray andPageIndex:(int)index{
    if ([super init]) {
        self.imageArray = imageArray;
        ind = index;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}
- (void)initSubview{
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.pageController];
}
- (void)initLayout{
    _mainScrollView.frame = CGRectMake(0, 0, SWight, SHeight);
    [_pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.equalTo(@300);
        make.height.equalTo(@10);
    }];
}
- (void)initOption{
    _mainScrollView.contentSize = CGSizeMake(self.imageArray.count*SWight, 0);
    _pageController.numberOfPages = self.imageArray.count;
    for (int i = 0; i<_imageArray.count; i++) {
        UIView *backView = [[UIView alloc]init];
        backView.frame = CGRectMake(SWight*i, 0, SWight, SHeight);
        [self.mainScrollView addSubview:backView];
        UIImageView *IM = _imageArray[i];
        UIImage *image = IM.image;
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat r = width/height;
        UIImageView *imageView = [UIImageView new];
        imageView.image = image;
        [backView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView.mas_centerX);
            make.centerY.equalTo(backView.mas_centerY);
            make.width.equalTo(@0).offset(SWight);
            make.height.equalTo(@0).offset(SWight*r);
        }];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)];
        //2.开启人机交互
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:longTap];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];

    _mainScrollView.contentOffset = CGPointMake(SWight*ind, 0);
}
- (void)tapClick:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消保存图片");
        }];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确认保存图片");
            // 保存图片到相册
            NSError *error = [[NSError alloc]init];
            [self imageSavedToPhotosAlbum:imageView.image didFinishSavingWithError:error contextInfo:nil];
        }];
        [alertControl addAction:cancel];
        [alertControl addAction:confirm];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}
#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo
{
    NSString*message =@"提示";
    if(!error) {
        message =@"成功保存到相册";
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {  }];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }else{
        message = [error description];
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {   }];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        UIScrollView *view = [[UIScrollView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        view.frame = CGRectMake(0, 0, SWight, SHeight);
        view.delegate = self;
        view.pagingEnabled = YES;
        _mainScrollView = view;
    }
    return _mainScrollView;
}
- (UIPageControl *)pageController{
    if (!_pageController) {
        UIPageControl *pageC = [[UIPageControl alloc]init];
        pageC.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageC.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageController = pageC;
    }
    return _pageController;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int num = scrollView.contentOffset.x/SWight;
    _pageController.currentPage = num;
}
- (void)saveImageToStore{

}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
