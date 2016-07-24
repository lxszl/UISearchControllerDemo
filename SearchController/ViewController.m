//
//  ViewController.m
//  SearchController
//
//  Created by nercita on 16/7/15.
//  Copyright © 2016年 nercita. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()<UISearchResultsUpdating,UISearchControllerDelegate>
@property (nonatomic, strong) TableViewController *tableViewController;
@property (nonatomic, strong) UISearchController *searchVC;
@property (nonatomic ,strong) NSMutableArray *dataArr;
@property (nonatomic ,strong) NSMutableArray *resultArr;
@end

@implementation ViewController

-(TableViewController *)tableViewController{
    
    if (!_tableViewController) {
        _tableViewController = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    return _tableViewController;
}

- (UISearchController *)searchVC{
    if (!_searchVC) {
        
        _searchVC = [[UISearchController alloc]initWithSearchResultsController:self.tableViewController];
        _searchVC.searchResultsUpdater = self;
        _searchVC.delegate = self;
        _searchVC.hidesNavigationBarDuringPresentation = NO;
#warning //有了这句,取消键就不会被遮挡了
        self.definesPresentationContext = YES;
        self.navigationItem.titleView = self.searchVC.searchBar;
    }
    return _searchVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray arrayWithCapacity:200];
    for (int i = 0; i < 200; i ++) {
        int NUMBER_OF_CHARS = 5;
        char data[NUMBER_OF_CHARS];//生成一个五位数的字符串
        for (int x=0;x<10;data[x++] = (char)('A' + (arc4random_uniform(26))));
        NSString *string = [[NSString alloc] initWithBytes:data length:5 encoding:NSUTF8StringEncoding];//随机给字符串赋值
        [_dataArr addObject:string];
    } // 随机生成200个五位数的字符串
    
    [self searchVC];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchVC.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.tableViewController.dataSource!= nil) {
        [self.tableViewController.dataSource removeAllObjects];
    }
    //过滤数据
    self.tableViewController.dataSource = [NSMutableArray arrayWithArray:[_dataArr filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableViewController.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
