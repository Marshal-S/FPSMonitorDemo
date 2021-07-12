//
//  ViewController.m
//  FPSMonitorDemo
//
//  Created by Marshal on 2021/7/12.
//

#import "ViewController.h"
#import "FPSMonitor.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    
    FPSLabel *fpsLabel = [FPSLabel loadFPSLabel];
    [self.view addSubview:fpsLabel];
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    cell.textLabel.text = @"我就测试一下";
    if (indexPath.row % 10 == 0) {
        [NSThread sleepForTimeInterval:0.1];
    }
    return cell;
}


@end
