//
//  GYChatToolsEmojiView.m
//  GYChat
//
//  Created by gyy on 2019/9/16.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatToolsEmojiView.h"
#import "GYChatEmojiHelper.h"
#import "GYChatEmojiModel.h"
#import <Masonry/Masonry.h>
#import "UIView+GY.h"

@interface GYChatToolsEmojiViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *emojiLab;
@property (strong, nonatomic) UIImageView *emojiView;
@end
@implementation GYChatToolsEmojiViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _emojiLab = [[UILabel alloc] init];
        _emojiLab.font = [UIFont fontWithName:@"AppleColorEmoji" size:25.0f];
        [self.contentView addSubview:_emojiLab];
        [_emojiLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        _emojiView = [[UIImageView alloc]init];
        _emojiView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_emojiView];
        [_emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
    }
    return self;
}

@end


@interface GYChatToolsEmojiView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) UIView *bottomPageView;
@property (strong, nonatomic) NSMutableArray *bottomPageArys;

@property (strong, nonatomic) NSMutableArray *datasAry;
@property (assign, nonatomic) NSInteger currentPage;
@end

@implementation GYChatToolsEmojiView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    _datasAry = [[NSMutableArray alloc] initWithCapacity:0];
    _bottomPageArys = [[NSMutableArray alloc] initWithCapacity:0];
    _currentPage = 0;
    [_datasAry addObjectsFromArray:[GYChatEmojiHelper getAllCustomEmojis]];

    
    //表情视图
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[GYChatToolsEmojiViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 40, 0));
    }];
    
    _bottomPageView= [UIView new];
    _bottomPageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomPageView];
    
    //底部切换按钮
    for (int i = 0; i < _datasAry.count; i ++) {
        GYChatEmojiGroupModel *group = _datasAry[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*40, 0, 40, 40)];
        btn.tag = i;
        [btn setImage:group.image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeEmojiPage:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomPageView addSubview:btn];
        if (i == self.currentPage) {
            btn.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        }
        [_bottomPageArys addObject:btn];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.currentPage == 0) {
        self.layout.itemSize = CGSizeMake(self.width/7, (self.height-40)/3);
    }else{
        self.layout.itemSize = CGSizeMake(self.width/4, (self.height - 40)/2);
    }
    self.bottomPageView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), self.width, 40);
}

-(void)changeEmojiPage:(UIButton *)sender{
    self.currentPage = sender.tag;
    for (UIButton *btn in self.bottomPageArys) {
        btn.backgroundColor = [UIColor whiteColor];
    }
    sender.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [self setNeedsLayout];
    [_collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    GYChatEmojiGroupModel *model = _datasAry[_currentPage];
    return model.emojis.count;
//    return [GYChatEmojiHelper getAllEmojis].count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    GYChatToolsEmojiViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    GYChatEmojiGroupModel *group = self.datasAry[_currentPage];
    GYChatEmojiModel *model = group.emojis[indexPath.row];
    cell.emojiView.image = [model.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GYChatEmojiGroupModel *group = self.datasAry[_currentPage];
    GYChatEmojiModel *model = group.emojis[indexPath.row];
    if (model.isDel) {
        if (_delegate && [_delegate respondsToSelector:@selector(GYChatToolsEmojiViewCustomDidDel:)]) {
            [_delegate GYChatToolsEmojiViewCustomDidDel:model];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(GYChatToolsEmojiViewCustomDidSelected:)]) {
            [_delegate GYChatToolsEmojiViewCustomDidSelected:model];
        }
    }
}


@end
