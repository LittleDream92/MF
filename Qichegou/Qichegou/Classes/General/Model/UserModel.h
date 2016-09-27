//
//  UserModel.h
//  Qichegou
//
//  Created by Meng Fan on 16/9/27.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

/*手机号码*/
@property (nonatomic, copy) NSString *sjhm;
/*真实姓名*/
@property (nonatomic, copy) NSString *zsxm;
/*头像*/
@property (nonatomic, copy) NSString *head_img;

/* token */
@property (nonatomic, copy) NSString *token;

@end
