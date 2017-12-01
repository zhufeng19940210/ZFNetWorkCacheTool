//
//  ProductModel.h
//  YYWebImageMethod
//
//  Created by bailing on 2017/11/28.
//  Copyright © 2017年 bailing. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ProductModel : NSObject
@property (nonatomic,assign)int auto_open;
@property (nonatomic,copy)NSString *business_address;
@property (nonatomic,assign)int  business_check;
@property (nonatomic,assign)int business_id;
@property (nonatomic,copy)NSString  *business_introduction;
@property (nonatomic,copy)NSString  *business_keyword;
@property (nonatomic,copy)NSString  *business_lat;
@property (nonatomic,copy)NSString  *business_lng;
@property (nonatomic,copy)NSString  *business_logo;
@property (nonatomic,copy)NSString  *business_mobile;
@property (nonatomic,copy)NSString  *business_name;
@property (nonatomic,copy)NSString  *business_regtime;
@property (nonatomic,assign)int business_sales;
@property (nonatomic,assign)int business_sendtime;
@property (nonatomic,copy)NSString  *business_star;
@property (nonatomic,copy)NSString  *business_tel;
@property (nonatomic,copy)NSString  *business_type;
@property (nonatomic,copy)NSString  *city;
@property (nonatomic,assign)int  comment_count;
@property (nonatomic,assign)int dis_time;
@property (nonatomic,assign)int health_score;
@property (nonatomic,assign)int is_goodbus;
@property (nonatomic,assign)int is_myself;
@property (nonatomic,assign)int is_open;
@property (nonatomic,assign)int is_send;
@property (nonatomic,copy)NSString  *juli;
@property (nonatomic,copy)NSString  *last_ip;
@property (nonatomic,copy)NSString  *last_time;
@property (nonatomic,copy)NSString  *mealbox_cost;
@property (nonatomic,assign)int  open_end;
@property (nonatomic,assign)int  open_start;
@property (nonatomic,copy)NSString  *send_cost;
@property (nonatomic,assign)int shipping_type;
@property (nonatomic,assign)int tag;
@property (nonatomic,copy)NSString  *token_time;
@property (nonatomic,assign)int trans_type;
@property (nonatomic,assign)int upto_send;
@end
