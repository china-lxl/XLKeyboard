//
//  XLFaceBottomView.m
//  test
//
//  Created by lixinglu on 2017/11/8.
//  Copyright © 2017年 lixinglu. All rights reserved.
//

#import "XLFaceBottomView.h"

#import "XLFaceLayout.h"

#import "FaceCell.h"

#import "XLFaceModel.h"

#define k_page_height  25

#define k_num_H     4

@interface XLFaceBottomView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) UIPageControl *pageControl;

@property(nonatomic, strong) UICollectionView *faceCollectionView;

@property(nonatomic, strong) NSArray *faceArray;

@end

static NSString *cellId = @"FaceCell";

@implementation XLFaceBottomView{
    int k_num_L;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    
    if (self.frame.size.width > 375) {
        k_num_L = 9;
    }else{
        k_num_L = 8;
    }
    
    self.backgroundColor = [UIColor greenColor];
    
    [self addSubview:self.faceCollectionView];
    [self addSubview:self.pageControl];
}


#pragma mark - collectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.faceArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.faceModel = self.faceArray[indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float content_Width = scrollView.contentOffset.x;
    
    self.pageControl.currentPage = content_Width/self.frame.size.width;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XLFaceModel *model = self.faceArray[indexPath.row];
    
    if (model.isDele) {
        if ([self.delegate respondsToSelector:@selector(deleFaceModel)]) {
            [self.delegate deleFaceModel];
        }
    }else{
        if (model.name) {
            if ([self.delegate respondsToSelector:@selector(addFaceModel:)]) {
                [self.delegate addFaceModel:model];
            }
        }
    }
}

#pragma mark - set/get
- (NSArray *)faceArray{
    if (!_faceArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Face" ofType:@"plist"];
        
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:array.count];
        int page = 1;
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:array.count];
        
        for (int i = 0; i < array.count; i ++) {
            NSDictionary *dic = array[i];
            
            if (i == (k_num_L * k_num_H - 1) * page) {
                XLFaceModel *model = [[XLFaceModel alloc] init];
                model.isDele = YES;
                [modelArr addObject:model];
                page ++;
            }
            
            XLFaceModel *model = [XLFaceModel modelWithDic:dic];
            
            [tempArr addObject:model.name];
            
            [modelArr addObject:model];
        }
        
        self.dataArray = tempArr;
        
        while (modelArr.count % (k_num_L * k_num_H) != 0) {
            XLFaceModel *model = [[XLFaceModel alloc] init];
            if (modelArr.count % (k_num_L * k_num_H) + 1 == k_num_L * k_num_H) {
                model.isDele = YES;
            }
            [modelArr addObject:model];
        }
        
        _faceArray = modelArr;
    }
    return _faceArray;
}
- (UICollectionView *)faceCollectionView{
    if (!_faceCollectionView) {
        XLFaceLayout *flowLayout = [[XLFaceLayout alloc] init];
        
        float height = (self.frame.size.height - k_page_height)/k_num_H;
        float width = self.frame.size.width / k_num_L;
        
        flowLayout.item_H = k_num_H;
        flowLayout.item_Row = k_num_L;
        
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _faceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-k_page_height) collectionViewLayout:flowLayout];
        
        _faceCollectionView.backgroundColor = [UIColor clearColor];
        
        _faceCollectionView.pagingEnabled = YES;
        _faceCollectionView.showsHorizontalScrollIndicator = NO;
        _faceCollectionView.bounces = NO;
        _faceCollectionView.delegate = self;
        _faceCollectionView.dataSource = self;
        
        [_faceCollectionView registerNib:[UINib nibWithNibName:@"FaceCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    }
    return _faceCollectionView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - k_page_height, self.frame.size.width, k_page_height)];
        
        _pageControl.numberOfPages = ceilf(self.faceArray.count/k_num_H/k_num_L);
        
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

@end
