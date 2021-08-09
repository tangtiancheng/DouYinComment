//
//  DDAnimationLayout.m
//  DuoDUoAnimateHouse
//
//  Created by 唐天成 on 2017/11/15.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "DDAnimationLayout.h"
#import "TTCCom.h"

@interface DDAnimationLayout()

//这个字典用来存储每一列最大的X值(每一列的高度)
@property (nonatomic, strong) NSMutableDictionary *maxXDict;
//存放所有的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation DDAnimationLayout

- (NSMutableDictionary *)maxXDict
{
    if (!_maxXDict) {
        self.maxXDict = [[NSMutableDictionary alloc] init];
    }
    return _maxXDict;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

- (instancetype)init
{
    if (self = [super init]) {
        //        self.columnMargin = 10;
        //        self.rowMargin = 10;
        //        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //        self.rowsCount = 2;
    }
    return self;
}

/**
 *  每次布局之前的准备
 */
-(void)prepareLayout{
    [super prepareLayout];
    //    NSLog(@"%s",__func__);
    // 1.清空最大的X值
    for (int i = 0; i<self.rowsOrColumnsCount; i++) {
        if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            NSString *column = [NSString stringWithFormat:@"%d", i];
            self.maxXDict[column] = @(self.sectionInset.left);
        } else {
            NSString *column = [NSString stringWithFormat:@"%d", i];
            self.maxXDict[column] = @(self.sectionInset.top);
        }
        
    }
    
    // 2.计算所有cell的属性
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //   NSLog(@"haha%d",count);
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 返回所有的尺寸
 */
-(CGSize)collectionViewContentSize{
    __block NSString* maxColumn=@"0";
    [self.maxXDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxX, BOOL *stop) {
        if([maxX floatValue]>[self.maxXDict[maxColumn]floatValue]){
            maxColumn=column;
        }
    }];
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        return CGSizeMake([self.maxXDict[maxColumn] floatValue]+self.sectionInset.right,0 );
    } else {
        return CGSizeMake(0,[self.maxXDict[maxColumn] floatValue]+self.sectionInset.bottom);
    }
    
}

/**
 *  返回indexPath这个位置Item的布局属性
 */
-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //  NSLog(@"%s  %@  %d",__func__,self.maxYDict,indexPath.row);
    //假设最短的那一列的第0列
    __block NSString* minColumn = @"0";
    __block NSString* maxColumn = @"0";
    //找出最短的那一列
    [self.maxXDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxX, BOOL *stop) {
        
        if([maxX floatValue] < [self.maxXDict[minColumn] floatValue]){
            minColumn=column;
        }
        if([maxX floatValue] > [self.maxXDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    CGSize size = [self.delegate DDAnimationLayout:self atIndexPath:indexPath];
    // 计算尺寸
    CGFloat height = size.height;
    CGFloat width = size.width;
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if(!( fabs(width / height - 1.28)>=0 && fabs(width / height - 1.28) <= 0.01)) {
            //如果是那种特殊的
            //计算位置
            CGFloat y = self.sectionInset.top;
            //    CGFloat x=self.sectionInset.left+(width+self.columnMargin)*[minColumn intValue];
            CGFloat x = 0;
            if(fabs([self.maxXDict[maxColumn] floatValue] - self.sectionInset.left)<0.01) {//小于0.01默认相等
                x=[self.maxXDict[maxColumn] floatValue];
            } else {
                x=[self.maxXDict[maxColumn] floatValue]+self.columnMargin;
            }
            //    CGFloat y=[self.maxYDict[minColumn] floatValue]+self.rowMargin;
            //更新这一列的最大Y值
            [self.maxXDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxX, BOOL *stop) {
                self.maxXDict[column] = @(x+width);
            }];
            
            //创建属性
            UICollectionViewLayoutAttributes* attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attrs.frame=CGRectMake(x, y, width, height);
            return attrs;
        } else {
            
            //计算位置
            CGFloat y = self.sectionInset.top+(height+self.rowMargin)*[minColumn intValue];
            
            //    CGFloat x=self.sectionInset.left+(width+self.columnMargin)*[minColumn intValue];
            //        CGFloat x = [self.maxXDict[minColumn] floatValue];//+self.columnMargin;
            CGFloat x = 0;
            
            if(fabs([self.maxXDict[minColumn] floatValue] - self.sectionInset.left<0.01)) {
                x=[self.maxXDict[minColumn] floatValue];
            } else {
                x=[self.maxXDict[minColumn] floatValue]+self.columnMargin;
            }
            
            //    CGFloat y=[self.maxYDict[minColumn] floatValue]+self.rowMargin;
            //更新这一列的最大Y值
            self.maxXDict[minColumn]=@(x+width);
            
            //创建属性
            UICollectionViewLayoutAttributes* attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attrs.frame=CGRectMake(x, y, width, height);
            return attrs;
        }
    } else {
        if(width > SCREEN_WIDTH/2) {
            //特殊的
            //计算位置
            CGFloat y = 0;
            CGFloat x = self.sectionInset.left ;
            if(fabs([self.maxXDict[minColumn] floatValue] - self.sectionInset.top < 0.01)) {
                y=[self.maxXDict[minColumn] floatValue];
            } else {
                y=[self.maxXDict[minColumn] floatValue]+self.rowMargin;
            }
            [self.maxXDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxX, BOOL *stop) {
                self.maxXDict[column] = @(y+height);
            }];
            //创建属性
            UICollectionViewLayoutAttributes* attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attrs.frame=CGRectMake(x, y, width, height);
            return attrs;
        }
        
        //计算位置
        CGFloat y = 0;
        CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColumn intValue];
        if(fabs([self.maxXDict[minColumn] floatValue] - self.sectionInset.top < 0.01)) {
            y=[self.maxXDict[minColumn] floatValue];
        } else {
            y=[self.maxXDict[minColumn] floatValue]+self.rowMargin;
        }
        //    CGFloat y=[self.maxYDict[minColumn] floatValue]+self.rowMargin;
        //更新这一列的最大X值
        self.maxXDict[minColumn]=@(y+height);
        
        //创建属性
        UICollectionViewLayoutAttributes* attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attrs.frame=CGRectMake(x, y, width, height);
        return attrs;
    }
    
}
/**
 *  返回rect范围内的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

// Invalidate:刷新
// 在滚动的时候是否允许刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}


@end


