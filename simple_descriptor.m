function feature = simple_descriptor( patch )
% 此处显示详细说明
% 将像素值分布进行标准正态化来描述这个小patch (标准正态分布的均值为0，标准差为1)
% 然后将它展开成一维的数组
% patch: 尺寸为 (H, W)的灰度图像
% feature: 尺寸为 (H * W)的一维数组

feature=[];

%展开成一维向量
patch=patch';
patch=patch(:)';
    Mean = mean(patch);
    delta = std(patch); 
    if delta > 0.0
        patch = (patch - Mean) / delta; 
    else
        patch = patch - Mean;
    end
    feature = patch;
end

