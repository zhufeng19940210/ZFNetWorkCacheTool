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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupTabelView];
}
-(void)setupData{
    //GET不带缓存的方法
    [[ZFNetWorkCacheTool ShareWorkTool]GETWithUrl:@"https://www.daodianwang.com/api/business/showGoodBusiness" parameter:nil success:^(id responseObject) {
        NSLog(@"fengfengresponseObject:%@",responseObject);
    } failure:^(NSString *error) {
        NSLog(@"请求失败我操");
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
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
