function keypoint_desc = keypoint_description_simple( image,keypoint,descriptorMode,patch_size )
%   �˴���ʾ��ϸ˵��
% imageΪ����ͼ��
% keypointΪ�õ��Ĺؼ���ͼ��
% patch_sizeΪ�趨patch��С
% descriptorMode ������ģʽ��1��ʾ�򵥵�һά������2��ʾHOG�㷨

%��RGBͼ��ת��Ϊ�Ҷ�ͼ
if length(size(image))==3
    image = rgb2gray(double(image)/255);
end

keypoint_desc = [];

%����keypoint�õ��ؼ������
count=0;
[H,W]=size(keypoint);
for i=1:H
    for j=1:W
        if keypoint(i,j)==1
            count=count+1;
        end
    end
end

%�õ�Ԫ���±�
[x,y]=find(keypoint==1); %x�� y��

%����Ϊ��x�У���y��
for i=1:count
    if descriptorMode==1
        patch=image( (x(i)-patch_size/2) : (x(i)+patch_size/2) , (y(i)-patch_size/2) : (y(i)+patch_size/2) );
        description = [x(i),y(i),simple_descriptor(patch)]; %�õ�����
    elseif descriptorMode==2
        patch=image( (x(i)-patch_size/2+1) : (x(i)+patch_size/2) , (y(i)-patch_size/2+1) : (y(i)+patch_size/2) );
        description = [x(i),y(i),HOG_descriptor(patch,patch_size)]; %�õ�����
    end
    keypoint_desc=[keypoint_desc;description];
end

end

