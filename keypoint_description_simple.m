function keypoint_desc = keypoint_description_simple( image,keypoint,descriptorMode,patch_size )
%   此处显示详细说明
% image为输入图像
% keypoint为得到的关键点图像
% patch_size为设定patch大小
% descriptorMode 是描述模式，1表示简单的一维向量；2表示HOG算法

%将RGB图像转化为灰度图
if length(size(image))==3
    image = rgb2gray(double(image)/255);
end

keypoint_desc = [];

%遍历keypoint得到关键点个数
count=0;
[H,W]=size(keypoint);
for i=1:H
    for j=1:W
        if keypoint(i,j)==1
            count=count+1;
        end
    end
end

%得到元素下标
[x,y]=find(keypoint==1); %x行 y列

%中心为第x行，第y列
for i=1:count
    if descriptorMode==1
        patch=image( (x(i)-patch_size/2) : (x(i)+patch_size/2) , (y(i)-patch_size/2) : (y(i)+patch_size/2) );
        description = [x(i),y(i),simple_descriptor(patch)]; %得到描述
    elseif descriptorMode==2
        patch=image( (x(i)-patch_size/2+1) : (x(i)+patch_size/2) , (y(i)-patch_size/2+1) : (y(i)+patch_size/2) );
        description = [x(i),y(i),HOG_descriptor(patch,patch_size)]; %得到描述
    end
    keypoint_desc=[keypoint_desc;description];
end

end

