//
//  ViewController.m
//  LocationTest
//
//  Created by DejingMa on 16/8/10.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *m_label;
@property (strong, nonatomic) CLLocationManager *m_locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)initLocationManager:(id)sender {
	self.m_locationManager = [[CLLocationManager alloc] init];
	self.m_locationManager.delegate = self;
	self.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.m_locationManager.distanceFilter = 10;
	// iOS9.0 以后，如果要后台也定位，使用requestAlwaysAuthorization就可以，若allowsBackgroundLocationUpdates和requestWhenInUseAuthorization一起使用，后台可定位，但是会有蓝条出现。
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//		 self.m_locationManager.allowsBackgroundLocationUpdates = YES;
	}
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
//		[self.m_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
		[self.m_locationManager requestAlwaysAuthorization];
	}
	[self.m_locationManager startUpdatingLocation];//开启定位
	self.m_label.text = @"正在定位中。。。";
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	CLLocation *currLocation = [locations lastObject];
	NSLog(@"la---%f, lo---%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude);
	
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
		if (placemarks.count > 0) {
			// 自动定位获取城市等信息
			CLPlacemark * plmark = [placemarks firstObject];
			NSLog(@"第一个地址:%@\n", plmark.name); //显示所有地址
			self.m_label.text = plmark.name; //给label负值
		}
	}];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if ([error code] == kCLErrorDenied) {
		NSLog(@"访问被拒绝");
	}

	if ([error code]==kCLErrorLocationUnknown) {
		NSLog(@"无法获取位置信息");
	}
}


@end


