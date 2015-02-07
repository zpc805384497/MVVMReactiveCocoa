//
//  MRCViewController.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "MRCViewController.h"
#import "MRCViewModel.h"

@interface MRCViewController ()

@property (strong, nonatomic, readwrite) MRCViewModel *viewModel;

@end

@implementation MRCViewController

@synthesize viewModel = _viewModel;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    MRCViewController *viewController = [super allocWithZone:zone];

    [[viewController
        rac_signalForSelector:@selector(viewDidLoad)]
        subscribeNext:^(id x) {
            [viewController bindViewModel];
        }];
    
    return viewController;
}

- (id<MRCViewProtocol>)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)bindViewModel {
    RAC(self, title) = RACObserve(self.viewModel, title);
    
    @weakify(self)
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        @strongify(self)
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:error.localizedDescription
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:NULL];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel.willDisappearSignal sendNext:nil];
}

@end
