//
//  FaceCell.m
//  test
//
//  Created by lixinglu on 2017/11/9.
//  Copyright © 2017年 lixinglu. All rights reserved.
//

#import "FaceCell.h"

#import "XLFaceModel.h"

@interface FaceCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation FaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    // Initialization code
}

- (void)setFaceModel:(XLFaceModel *)faceModel{
    _faceModel = faceModel;
    if (faceModel.isDele) {
        self.imageView.image = [UIImage imageNamed:@"face_dele"];
    }else{
        self.imageView.image = [UIImage imageNamed:faceModel.picname];
    }
}

@end
