//
//  ViewController.m
//  城市搜索数据库
//
//  Created by mac on 16/4/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "HTCityCollectionViewCell.h"
#import "HTSectionHeaderView.h"
#import "HTCityGroup.h"
#import "NSString+pinyin.h"
#import "HTCitySelectIndexView.h"
#import "HTDataBase.h"
#import "UIColor+hex.h"
#import "HTCollectionViewPlainLayout.h"

#define kCurrentW [UIScreen mainScreen].bounds.size.width
#define kCurrentH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,HTCitySelectIndexViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong) NSMutableArray *cityGroupsArray;
@property(nonatomic,strong) NSMutableArray *indexTitleArray;
@property(nonatomic,strong) NSMutableArray *allCityArray;
@property(nonatomic,strong) UILabel *promotLabel;
@property(nonatomic,strong) UICollectionView *searchAssociateView;
@property(nonatomic,strong) NSArray *searchResultArray;
@property(nonatomic,strong) UICollectionView *cityCollectionView;

@end


static NSString *const cityCellID = @"cityCell";
static NSString *const sectionHeaderID = @"sectionHeader";

#define headerH 20
#define sectionInsetTop 20

@implementation ViewController

- (NSMutableArray *)allCityArray{
    
    if (_allCityArray == nil) {
        
        _allCityArray = [NSMutableArray array];
    }
    return _allCityArray;
}

- (NSMutableArray *)cityGroupsArray{
    
    if (_cityGroupsArray == nil) {
        _cityGroupsArray = [[NSMutableArray alloc] init];
    }
    return _cityGroupsArray;
}

- (NSMutableArray *)indexTitleArray{
    
    if (_indexTitleArray == nil) {
        _indexTitleArray = [[NSMutableArray alloc] init];
    }
    return _indexTitleArray;
}

- (UICollectionView *)searchAssociateView{
    
    if (_searchAssociateView == nil) {
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(90,30);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.sectionInset = UIEdgeInsetsMake(sectionInsetTop, 10, 10, 20);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64,kCurrentW, kCurrentH - 64) collectionViewLayout:flowLayout];
        
        [collectionView registerNib:[UINib nibWithNibName:@"HTCityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cityCell"];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.hidden = YES;
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _searchAssociateView = collectionView;
    }
    return _searchAssociateView;
}

- (NSArray *)searchResultArray{
    if (_searchResultArray == nil) {
        _searchResultArray = [NSArray array];
        
    }
    return _searchResultArray;
}

- (UILabel *)promotLabel{
    
    if (_promotLabel == nil) {
        _promotLabel = [[UILabel alloc] init];
        _promotLabel.bounds = CGRectMake(0, 0, 80, 80);
        _promotLabel.center = self.view.center;
        _promotLabel.layer.cornerRadius = 10;
        _promotLabel.layer.masksToBounds = YES;
        _promotLabel.backgroundColor = [UIColor blackColor];
        _promotLabel.textAlignment = NSTextAlignmentCenter;
        _promotLabel.textColor = [UIColor whiteColor];
        _promotLabel.font = [UIFont systemFontOfSize:20];
        _promotLabel.alpha = 0.8;
        _promotLabel.hidden = YES;
    }
    return _promotLabel;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    HTDataBase *database = [HTDataBase getDataBase];
//    [database deleteTable:@"DELETE FROM t_city;"];

    [self readCityData];
    
    [self setupView];

}

- (void)readCityData{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"citynew" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    NSArray *cityArray = [jsonObject objectForKey:@"city"];
    
    
    // dic 2 model
    self.cityGroupsArray = [HTCityGroup objectArrayWithKeyValuesArray:cityArray];
    
    // 排序 #abc...xyz
    [self.cityGroupsArray sortUsingComparator:^NSComparisonResult(HTCityGroup *obj1, HTCityGroup *obj2) {
        NSComparisonResult result = [obj1.groupName compare:obj2.groupName];
        // 这个block需要返回一个NSComparisonResult
        return result;
    }];
    
    // 处理热#数据
    
    HTCityGroup *group = self.cityGroupsArray[0];
    group.groupName = @"热门";

    return;
    // 全局队列
    dispatch_queue_t globalQ = dispatch_get_global_queue(0, 0);
    
    dispatch_async(globalQ, ^{
        
        // 添加拼音 - 为了制作数据库
        NSRange range = NSMakeRange(1,self.cityGroupsArray.count - 1);
        NSArray *makeDbArray = [self.cityGroupsArray subarrayWithRange:range];
        
        for (HTCityGroup *cityGroup in makeDbArray) {
            
            for (HTCity *city in cityGroup.cityArray) {
                
                city.pinyinName = [NSString transformTextToPinYin:city.cityName withSpace:NO];
                city.shortName = [NSString getFirstStrFromText:city.cityName];
                
                // 制作数据库
                HTDataBase *db = [HTDataBase getDataBase];
                [db saveCityDataWithModel:city];
            }
        }
    
    });
    
}

- (void)setupView{
    
    // collectionView
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(90,30);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(sectionInsetTop, 10, 10, 20);
    flowLayout.headerReferenceSize = CGSizeMake(100, headerH);
    
    
    HTCollectionViewPlainLayout *plainLayout = [[HTCollectionViewPlainLayout alloc] init];
    plainLayout.itemSize = CGSizeMake(90,30);
    plainLayout.minimumLineSpacing = 10;
    plainLayout.minimumInteritemSpacing = 20;
    plainLayout.sectionInset = UIEdgeInsetsMake(sectionInsetTop, 10, 10, 20);
    plainLayout.headerReferenceSize = CGSizeMake(100, headerH);

    
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
//        // iOS9 自带悬停效果 以下版本只能自己写
//        flowLayout.sectionHeadersPinToVisibleBounds = YES;
//    }
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,kCurrentW, kCurrentH) collectionViewLayout:plainLayout];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HTCityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cityCell"];
    
    [collectionView registerNib:[UINib nibWithNibName:@"HTSectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.cityCollectionView = collectionView;
#warning 这个横竖屏 有影响 直接addSubView 横屏时没有反应
    [self.view addSubview:collectionView];
//    self.view = collectionView;
    
    
    // indexView
    CGFloat indexViewW = 20;
    CGFloat indexViewH = 400;
    HTCitySelectIndexView *indexView = [[HTCitySelectIndexView alloc] initWithFrame:CGRectMake(kCurrentW - indexViewW,(kCurrentH - indexViewH) * 0.5, indexViewW, indexViewH)];

    NSMutableArray *tempArray = [NSMutableArray array];
    for (HTCityGroup *group in self.cityGroupsArray) {
        [tempArray addObject:group.groupName];
    }
    indexView.titlesArray = tempArray;
    
    indexView.delegate = self;
    [self.view addSubview:indexView];
    
    // prompt
    [self.view addSubview:self.promotLabel];
    
    
    // searchView
    UISearchBar *search = [[UISearchBar alloc] init];
    [search sizeToFit];
    search.searchBarStyle = UIBarStyleDefault;
    search.tintColor = [UIColor colorWithHexString:@"#00a752"];
    search.placeholder = @"全拼|简拼|中文";
    search.returnKeyType = UIReturnKeyDone;
    search.showsCancelButton = NO;
    search.delegate = self;
//    self.navigationItem.titleView = search;
}


#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (collectionView == self.cityCollectionView) {
        
        return self.cityGroupsArray.count;
    }else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (collectionView == self.cityCollectionView) {
        
        HTCityGroup *cityGroup = self.cityGroupsArray[section];
        
        return cityGroup.cityArray.count;
    } else {
    
        return self.searchResultArray.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HTCityCollectionViewCell *cityCell = [collectionView dequeueReusableCellWithReuseIdentifier:cityCellID forIndexPath:indexPath];
    
    if (collectionView == self.cityCollectionView) {
        
        
        HTCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
        HTCity *city = cityGroup.cityArray[indexPath.row];
        
        cityCell.cellName = [NSString stringWithFormat:@"%@",city.cityName];
        
        return cityCell;
    } else {
        
        HTCity *city = self.searchResultArray[indexPath.item];
        cityCell.cellName = [NSString stringWithFormat:@"%@",city.cityName];
        return cityCell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.cityCollectionView) {
        
        HTSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        HTCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
        headerView.headerName = [NSString stringWithFormat:@"    %@",cityGroup.groupName];
        
        return headerView;
    } else {
    
        return nil;
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTCity *city = nil;
    
    if (collectionView == self.cityCollectionView) {
        
        HTCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
        city = cityGroup.cityArray[indexPath.item];
    } else {
    
        city = self.searchResultArray[indexPath.item];
    }
    
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:city.cityName preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alertVc addAction:action];
    
    [self presentViewController:alertVc animated:YES completion:nil];

    
}

#pragma mark -HTCitySelectIndexViewDelegate


-(void)collectionViewIndex:(HTCitySelectIndexView *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title{

    [self.cityCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    
    if (index > 0) {
        
        [self.cityCollectionView setContentOffset:CGPointMake(0, self.cityCollectionView.contentOffset.y - headerH - sectionInsetTop) animated:NO];
    }
    
    self.promotLabel.text = title;
}

- (void)collectionViewIndexTouchesBegan:(HTCitySelectIndexView *)collectionViewIndex{
    
    self.promotLabel.alpha = 0.8;
    self.promotLabel.hidden = NO;
    
}

- (void)collectionViewIndexTouchesEnd:(HTCitySelectIndexView *)collectionViewIndex{

    [UIView animateWithDuration:0.3 animations:^{
        self.promotLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.promotLabel.hidden = YES;
    }];
}



#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
    [self.view addSubview:self.searchAssociateView];
    // 去空格
    searchBar.text = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchText == nil || [searchText isEqualToString:@""]) {
        self.searchAssociateView.hidden = YES;
    }else {
        HTDataBase *database = [HTDataBase getDataBase];
        self.searchResultArray = [database quaryDataFromTable:searchText];
        self.searchAssociateView.hidden = NO;
    }
    
    [self.searchAssociateView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    searchBar.text = nil;
    searchBar.showsCancelButton = NO;
    self.searchResultArray = nil;
    self.searchAssociateView.hidden = YES;
    [searchBar resignFirstResponder];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
}

@end
