//
//  WMMenuView.m
//  WMPageController
//
//  Created by Mark on 15/4/26.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMMenuView.h"
#import "WMProgressView.h"
#import "WMFooldView.h"

@interface WMMenuView () <WMMenuItemDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) WMProgressView *progressView;
@property (nonatomic, weak) WMMenuItem *selItem;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, readonly) NSInteger titlesCount;
@end

// 下划线的高度
static CGFloat   const WMProgressHeight = 2.0;
static CGFloat   const WMMenuItemWidth  = 60.0;
static NSInteger const WMMenuItemTagOffset = 6250;

@implementation WMMenuView

#pragma mark - Setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    // Make the contentView center, because system will change menuView's frame if it's a titleView.
    if (self.scrollView && (self.scrollView.frame.origin.x + self.scrollView.frame.size.width / 2) != (self.bounds.origin.x + self.bounds.size.width / 2)) {
        CGRect contentFrame = self.scrollView.frame;
        contentFrame.origin.x = self.bounds.origin.x - (contentFrame.size.width - self.bounds.size.width) / 2;
        self.scrollView.frame = contentFrame;
    }
    
}

- (void)setLeftView:(UIView *)leftView {
    if (self.leftView) {
        [self.leftView removeFromSuperview];
        self.leftView = nil;
    }
    [self addSubview:leftView];
    _leftView = leftView;
    
    [self resetFrames];
}

- (void)setRightView:(UIView *)rightView {
    if (self.rightView) {
        [self.rightView removeFromSuperview];
        self.rightView = nil;
    }
    [self addSubview:rightView];
    _rightView = rightView;
    
    [self resetFrames];
}

#pragma mark - Getter
- (CGFloat)progressHeight {
    if (_progressHeight == 0.0) {
        _progressHeight = WMProgressHeight;
    }
    return _progressHeight;
}

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = self.selectedColor;
    }
    return _lineColor;
}

- (NSMutableArray *)frames {
    if (_frames == nil) {
        _frames = [NSMutableArray array];
    }
    return _frames;
}

- (UIColor *)selectedColor {
    if ([self.delegate respondsToSelector:@selector(menuView:titleColorForState:)]) {
        return [self.delegate menuView:self titleColorForState:WMMenuItemStateSelected];
    }
    return [UIColor blackColor];
}

- (UIColor *)normalColor {
    if ([self.delegate respondsToSelector:@selector(menuView:titleColorForState:)]) {
        return [self.delegate menuView:self titleColorForState:WMMenuItemStateNormal];
    }
    return [UIColor blackColor];
}

- (CGFloat)selectedSize {
    if ([self.delegate respondsToSelector:@selector(menuView:titleSizeForState:)]) {
        return [self.delegate menuView:self titleSizeForState:WMMenuItemStateSelected];
    }
    return 18.0;
}

- (CGFloat)normalSize {
    if ([self.delegate respondsToSelector:@selector(menuView:titleSizeForState:)]) {
        return [self.delegate menuView:self titleSizeForState:WMMenuItemStateNormal];
    }
    return 15.0;
}

#pragma mark - Public Methods
- (void)reload {
    [self.frames removeAllObjects];
    [self.progressView removeFromSuperview];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self addItems];
    [self makeStyle];
}

- (void)slideMenuAtProgress:(CGFloat)progress {
    if (self.progressView) {
        self.progressView.progress = progress;
    }
    NSInteger tag = (NSInteger)progress + WMMenuItemTagOffset;
    CGFloat rate = progress - tag + WMMenuItemTagOffset;
    WMMenuItem *currentItem = (WMMenuItem *)[self viewWithTag:tag];
    WMMenuItem *nextItem = (WMMenuItem *)[self viewWithTag:tag+1];
    if (rate == 0.0) {
        rate = 1.0;
        [self.selItem deselectedItemWithoutAnimation];
        self.selItem = currentItem;
        [self.selItem selectedItemWithoutAnimation];
        [self refreshContenOffset];
        return;
    }
    currentItem.rate = 1-rate;
    nextItem.rate = rate;
}

- (void)selectItemAtIndex:(NSInteger)index {
    NSInteger tag = index + WMMenuItemTagOffset;
    NSInteger currentIndex = self.selItem.tag - WMMenuItemTagOffset;
    WMMenuItem *item = (WMMenuItem *)[self viewWithTag:tag];
    [self.selItem deselectedItemWithoutAnimation];
    self.selItem = item;
    [self.selItem selectedItemWithoutAnimation];
    [self.progressView setProgressWithOutAnimate:index];
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:index currentIndex:currentIndex];
    }
    [self refreshContenOffset];
}

- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index andWidth:(BOOL)update {
    if (index >= self.titlesCount || index < 0) { return; }
    
    WMMenuItem *item = (WMMenuItem *)[self viewWithTag:(WMMenuItemTagOffset + index)];
    item.text = title;
    if (!update) { return; }
    [self resetFrames];
}

#pragma mark - Data source
- (NSInteger)titlesCount {
    return [self.dataSource numbersOfTitlesInMenuView:self];
}

#pragma mark - Private Methods
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.scrollView) { return; }
    
    [self addScrollView];
    [self addItems];
    [self makeStyle];
}

- (void)resetFrames {
    CGRect frame = self.bounds;
    if (self.rightView) {
        CGRect rightFrame = self.rightView.frame;
        rightFrame.origin.x = frame.size.width - rightFrame.size.width;
        self.rightView.frame = rightFrame;
        frame.size.width -= rightFrame.size.width;
    }
    
    if (self.leftView) {
        CGRect leftFrame = self.leftView.frame;
        leftFrame.origin.x = 0;
        self.leftView.frame = leftFrame;
        frame.origin.x += leftFrame.size.width;
        frame.size.width -= leftFrame.size.width;
    }
    
    self.scrollView.frame = frame;
    [self resetFramesFromIndex:0];
    [self refreshContenOffset];
}

- (void)resetFramesFromIndex:(NSInteger)index {
    [self.frames removeAllObjects];
    [self calculateItemFrames];
    for (NSInteger i = index; i < self.titlesCount; i++) {
        WMMenuItem *item = (WMMenuItem *)[self viewWithTag:(WMMenuItemTagOffset + i)];
        CGRect frame = [self.frames[i] CGRectValue];
        item.frame = frame;
    }
    if (!self.progressView.superview) { return; }
    CGRect frame = self.progressView.frame;
    frame.size.width = self.scrollView.contentSize.width;
    if ([self.progressView isKindOfClass:[WMFooldView class]]) {
        frame.origin.y = 0;
    } else {
        frame.origin.y = self.frame.size.height - self.progressHeight;
    }
    self.progressView.frame = frame;
    self.progressView.itemFrames = self.frames;
    [self.progressView setNeedsDisplay];
}

- (void)makeStyle {
    switch (self.style) {
        case WMMenuViewStyleLine:
            [self addProgressView];
            break;
        case WMMenuViewStyleFoold:
            [self addFooldViewHollow:NO];
            break;
        case WMMenuViewStyleFooldHollow:
            [self addFooldViewHollow:YES];
            break;
        default:
            break;
    }
}

// 让选中的item位于中间
- (void)refreshContenOffset {
    CGRect frame = self.selItem.frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    if (itemX > width/2) {
        CGFloat targetX;
        if ((contentSize.width-itemX) <= width/2) {
            targetX = contentSize.width - width;
        } else {
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        // 应该有更好的解决方法
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)addScrollView {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGRect frame = CGRectMake(0, 0, width, height);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.backgroundColor = self.backgroundColor;
    scrollView.scrollsToTop = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)addItems {
    [self calculateItemFrames];
    
    for (int i = 0; i < self.titlesCount; i++) {
        CGRect frame = [self.frames[i] CGRectValue];
        WMMenuItem *item = [[WMMenuItem alloc] initWithFrame:frame];
        item.tag = (i+WMMenuItemTagOffset);
        item.delegate = self;
        item.text = [self.dataSource menuView:self titleAtIndex:i];
        item.textAlignment = NSTextAlignmentCenter;
        item.textColor = self.normalColor;
        item.userInteractionEnabled = YES;
        if (self.fontName) {
            item.font = [UIFont fontWithName:self.fontName size:self.selectedSize];
        } else {
            item.font = [UIFont systemFontOfSize:self.selectedSize];
        }
        item.backgroundColor = [UIColor clearColor];
        item.normalSize    = self.normalSize;
        item.selectedSize  = self.selectedSize;
        item.normalColor   = self.normalColor;
        item.selectedColor = self.selectedColor;
        if (i == 0) {
            [item selectedItemWithoutAnimation];
            self.selItem = item;
        } else {
            [item deselectedItemWithoutAnimation];
        }
        [self.scrollView addSubview:item];
    }
}

// 计算所有item的frame值，主要是为了适配所有item的宽度之和小于屏幕宽的情况
// 这里与后面的 `-addItems` 做了重复的操作，并不是很合理
- (void)calculateItemFrames {
    CGFloat contentWidth = [self itemMarginAtIndex:0];
    for (int i = 0; i < self.titlesCount; i++) {
        CGFloat itemW = WMMenuItemWidth;
        if ([self.delegate respondsToSelector:@selector(menuView:widthForItemAtIndex:)]) {
            itemW = [self.delegate menuView:self widthForItemAtIndex:i];
        }
        CGRect frame = CGRectMake(contentWidth, 0, itemW, self.frame.size.height);
        // 记录frame
        [self.frames addObject:[NSValue valueWithCGRect:frame]];
        contentWidth += itemW + [self itemMarginAtIndex:i+1];
    }
    // 如果总宽度小于屏幕宽,重新计算frame,为item间添加间距
    if (contentWidth < self.scrollView.frame.size.width) {
        // 计算间距
        CGFloat distance = self.scrollView.frame.size.width - contentWidth;
        CGFloat gap = distance / (self.titlesCount + 1);
        for (int i = 0; i < self.frames.count; i++) {
            CGRect frame = [self.frames[i] CGRectValue];
            frame.origin.x += gap * (i+1);
            self.frames[i] = [NSValue valueWithCGRect:frame];
        }
        contentWidth = self.scrollView.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.frame.size.height);
}

- (CGFloat)itemMarginAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(menuView:itemMarginAtIndex:)]) {
        return [self.delegate menuView:self itemMarginAtIndex:index];
    }
    return 0.0;
}

// MARK:Progress View
- (void)addProgressView {
    WMProgressView *pView = [[WMProgressView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - self.progressHeight, self.scrollView.contentSize.width, self.progressHeight)];
    pView.itemFrames = self.frames;
    pView.color = self.lineColor.CGColor;
    pView.backgroundColor = [UIColor clearColor];
    self.progressView = pView;
    [self.scrollView addSubview:pView];
}

- (void)addFooldViewHollow:(BOOL)isHollow {
    WMFooldView *fooldView = [[WMFooldView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.frame.size.height)];
    fooldView.itemFrames = self.frames;
    fooldView.color = self.lineColor.CGColor;
    fooldView.hollow = isHollow;
    fooldView.backgroundColor = [UIColor clearColor];
    self.progressView = fooldView;
    [self.scrollView insertSubview:fooldView atIndex:0];
}

#pragma mark - Menu item delegate
- (void)didPressedMenuItem:(WMMenuItem *)menuItem {
    if (self.selItem == menuItem) return;
    
    CGFloat progress = menuItem.tag - WMMenuItemTagOffset;
    [self.progressView moveToPostion:progress];
    
    NSInteger currentIndex = self.selItem.tag - WMMenuItemTagOffset;
    if ([self.delegate respondsToSelector:@selector(menuView:didSelesctedIndex:currentIndex:)]) {
        [self.delegate menuView:self didSelesctedIndex:menuItem.tag-WMMenuItemTagOffset currentIndex:currentIndex];
    }
    
    menuItem.selected = YES;
    self.selItem.selected = NO;
    self.selItem = menuItem;
    // 让选中的item位于中间
    [self refreshContenOffset];
}

@end
