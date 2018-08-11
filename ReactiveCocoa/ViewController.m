//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by shenghai on 2018/8/10.
//  Copyright © 2018年 shenghai. All rights reserved.
//

#import "ViewController.h"

NSString * const cellID = @"com.ReactiveCocoa.cellID";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 配置数据
    [self configData];
    // 配置UI
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSUserDefaults standardUserDefaults] setValue:@"ggwp" forKey:@"com.ReactiveCocoa.NSUserDefaultsControllerID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc {
    NSLog(@"=====%@被销毁了=====", [self class]);
}


#pragma mark - 初始化UI
- (void)configUI {
    self.title = @"ReactiveCocoa";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - 初始化数据
- (void)configData {
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"ReactiveCocoa" ofType:@"plist"];
    self.dataSource = [[[[NSArray alloc] initWithContentsOfFile:plistPath] reverseObjectEnumerator] allObjects];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *data = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [data objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = [self.dataSource objectAtIndex:indexPath.row];
    NSString *clsName = [data objectForKey:@"className"];
    Class cls = NSClassFromString(clsName);
    UIViewController *vc = [[cls alloc] init];
    vc.title = [data objectForKey:@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ----------------------------- 其他方法 ------------------------------

#pragma mark ----------------------------- 公用方法 ------------------------------

#pragma mark ----------------------------- 网络请求 ------------------------------

#pragma mark ----------------------------- 代理方法 ------------------------------

#pragma mark --------------------------- setter&getter -------------------------


@end
