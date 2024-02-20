function response = harris_corners( img )

%将RGB图像转化为灰度图
if length(size(img))==3
    img = rgb2gray(double(img)/255);
end


[row,col]=size(img); %获取图像的高和宽
kernel_size=3;%模板大小为3
k=0.04; %敏感度调节因子
border=10; %距离边界border的角点

response=zeros(row,col);% 创建一个与图像等大的图
process=response;%中间过程用到的temp

hx = fspecial('sobel'); %垂直方向sobel算子
hy = hx';%将矩阵转置得到水平方向sobel算子

dx=conv2(img,hx,'same'); %计算图像的sobel垂直梯度
dy=conv2(img,hy,'same'); %计算图像的sobel水平梯度

kernel=fspecial('gaussian',[kernel_size,kernel_size],1);   %选项2: Gaussian平滑

mxx=conv2(dx.*dx,kernel,'same');
myy=conv2(dy.*dy,kernel,'same');
mxy=conv2(dx.*dy,kernel,'same'); %分别三个方向计算

% mxx=conv2(dxx,kernel);
% myy=conv2(dyy,kernel);
% mxy=conv2(dxy,kernel);

for i=1:row
    for j=1:col
        M=[mxx(i,j),mxy(i,j);mxy(i,j),myy(i,j)];
        process(i, j) =det(M) - k *(trace(M)^2);
    end
end

%非极大值抑制
%找出图像的最大响应值Max，将阈值设为0.01*Max
Max=max(process(:));
t=Max*0.01;
process=padarray(process,[1 1],'both');

%使用阈值过滤角点
for i=2:row+1
    for j=2:col+1
        if process(i,j)<t
            process(i,j)=0;
        end
    end
end

%非极大值抑制
for i=2:row+1
    for j=2:col+1
        if process(i,j)~=0
            neighbors=get_neighbors(process,i,j);
            if process(i,j)<max(neighbors(:))
                process(i,j)=0;
            end
        end
    end
end

%剔除边界上的无效角点
response=process(2:row+1,2:col+1);
response(1:border,:)=0;
response(:,1:border)=0;
response(row-border+1:row,:)=0;
response(:,col-border+1:col)=0;

response(response~=0)=1;
end

%输入坐标x,y，返回该点相邻的坐标点，包括(x,y)
function neighbors=get_neighbors(m,x,y)
neighbors =[m(x-1,y-1),m(x-1,y),m(x-1,y+1),m(x,y-1),m(x,y+1),m(x+1,y-1),m(x+1,y),m(x+1,y+1)];
end

