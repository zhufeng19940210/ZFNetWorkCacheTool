//
//  ZFHomeViewController.m
//  Cache
//
//  Created by bailing on 2017/11/30.
//  Copyright © 2017年 bailing. All rights reserved.
//
#import "ZFHomeViewController.h"
#import "ZFNetWorkCacheTool.h"
#import "ZFHomeTableViewCell.h"
#import "ProductModel.h"
#import <YYModel.h>
#import <YYWebImage.h>
#import <MBProgressHUD.h>
static NSString *const homeCellIdentity = @"homeCellIdentity";
@interface ZFHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end
@implementation ZFHomeViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YYCache的使用方法";
    [self setupTabelView];
}
-(void)setupData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //GET不带缓存的方法
    [[ZFNetWorkCacheTool ShareWorkTool]GETWithUrl:@"https://www.daodianwang.com/api/business/showGoodBusiness" parameter:nil success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"fengfengresponseObject:%@",responseObject);
        NSArray *array = responseObject[@"result"];
        for (NSDictionary *dict in array) {
            ProductModel *model = [ProductModel yy_modelWithJSON:dict];
            [self.dataArray addObject:model];
        }
        //刷新数据
        [self.homeTableView reloadData];
    } failure:^(NSString *error) {
        NSLog(@"请求失败我操");
        return;
    }];
    //GET带缓存的方法
    [[ZFNetWorkCacheTool ShareWorkTool]GETCacheWithUrl:@"https://www.daodianwang.com/api/business/showGoodBusiness" paramter:nil success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"fengfengresponseObject:%@",responseObject);
        NSArray *array = responseObject[@"result"];
        for (NSDictionary *dict in array) {
            ProductModel *model = [ProductModel yy_modelWithJSON:dict];
                [self.dataArray addObject:model];
            }
            //刷新数据
            [self.homeTableView reloadData];
    } failure:^(NSString *error) {
        NSLog(@"请求失败");
        return;
    }];
}
-(void)setupTabelView{
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    self.homeTableView.rowHeight = 60;
    //注册cell
    [self.homeTableView registerNib:[UINib nibWithNibName:@"ZFHomeTableViewCell" bundle:nil] forCellReuseIdentifier:homeCellIdentity];
}
#pragma mark - uitableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZFHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellIdentity];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ZFHomeTableViewCell" owner:nil options:nil]lastObject];
    }
    ProductModel *model = self.dataArray[indexPath.row];
    [cell.iconImageView yy_setImageWithURL:[NSURL URLWithString:model.business_logo] options:(YYWebImageOptionShowNetworkActivity)];
    cell.descriptionLabel.text = model.business_address;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
