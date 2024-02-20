function feature = HOG_descriptor(patch,patch_size )
% 这是用于HOG描述算法
%   输入有patch,patch_size
%   这里为了简化算法 我们一律将patch视为block，一律划分成2*2的cell

[m n]=size(patch);
patch=sqrt(patch);      %伽马校正

%下面是求边缘
fy=[-1 0 1];        %定义竖直模板
fx=fy';             %定义水平模板
Iy=imfilter(patch,fy,'replicate');    %竖直边缘
Ix=imfilter(patch,fx,'replicate');    %水平边缘
Ied=sqrt(Ix.^2+Iy.^2);              %边缘强度
Iphase=Iy./Ix;              %边缘斜率，有些为inf,-inf,nan，其中nan需要再处理一下

%下面是求cell
step=patch_size/2;      %step*step个像素作为一个单元
orient=9;               %方向直方图的方向个数
range=360/orient;       %每个方向包含的角度范围
Cell=cell(2,2);         %所有的角度直方图,cell是可以动态增加的，所以先设了一个
ii=1;                      
jj=1;
for i=1:step:m          %如果处理的m/step不是整数，最好是i=1:step:m-step
    ii=1;
    for j=1:step:n      %同上
        tmpx=Ix(i:i+step-1,j:j+step-1);  %当前cell的横向梯度
        tmped=Ied(i:i+step-1,j:j+step-1);%当前cell的梯度
        tmped=tmped/sum(sum(tmped));     %局部边缘强度归一化
        tmpphase=Iphase(i:i+step-1,j:j+step-1);%当前cell的边缘斜率
        Hist=zeros(1,orient);            %当前step*step像素块统计角度直方图,就是cell，一共有orient列
        %进入直方图计算
        for p=1:step
            for q=1:step
                if isnan(tmpphase(p,q))==1  %0/0会得到nan，如果像素是nan，重设为0(防止强度为0的地方影响)
                    tmpphase(p,q)=0;
                end
                ang=atan(tmpphase(p,q));    %atan求的是[-90 90]度之间，但这里求出来的可能与真正方向相反
                ang=mod(ang*180/pi,360);    %全部变正，-90变270
                if tmpx(p,q)<0              %根据x方向确定真正的角度
                    if ang<90               %如果是第一象限
                        ang=ang+180;        %移到第三象限
                    end
                    if ang>270              %如果是第四象限
                        ang=ang-180;        %移到第二象限
                    end
                end
                ang=ang+0.0000001;          %防止ang为0
                Hist(ceil(ang/range))=Hist(ceil(ang/range))+tmped(p,q);   %ceil向上取整，使用边缘强度加权
            end
        end
        Hist=Hist/sum(Hist);    %方向直方图归一化
        Cell{ii,jj}=Hist;       %放入Cell中
        ii=ii+1;                %针对Cell的y坐标循环变量
    end
    jj=jj+1;                    %针对Cell的x坐标循环变量
end

%下面是求feature,2*2个cell合成一个block
feature=[Cell{1,1}(:)', Cell{1,2}(:)',  Cell{2,1}(:)',  Cell{2,1}(:)'];

end

