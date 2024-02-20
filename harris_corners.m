function response = harris_corners( img )

%��RGBͼ��ת��Ϊ�Ҷ�ͼ
if length(size(img))==3
    img = rgb2gray(double(img)/255);
end


[row,col]=size(img); %��ȡͼ��ĸߺͿ�
kernel_size=3;%ģ���СΪ3
k=0.04; %���жȵ�������
border=10; %����߽�border�Ľǵ�

response=zeros(row,col);% ����һ����ͼ��ȴ��ͼ
process=response;%�м�����õ���temp

hx = fspecial('sobel'); %��ֱ����sobel����
hy = hx';%������ת�õõ�ˮƽ����sobel����

dx=conv2(img,hx,'same'); %����ͼ���sobel��ֱ�ݶ�
dy=conv2(img,hy,'same'); %����ͼ���sobelˮƽ�ݶ�

kernel=fspecial('gaussian',[kernel_size,kernel_size],1);   %ѡ��2: Gaussianƽ��

mxx=conv2(dx.*dx,kernel,'same');
myy=conv2(dy.*dy,kernel,'same');
mxy=conv2(dx.*dy,kernel,'same'); %�ֱ������������

% mxx=conv2(dxx,kernel);
% myy=conv2(dyy,kernel);
% mxy=conv2(dxy,kernel);

for i=1:row
    for j=1:col
        M=[mxx(i,j),mxy(i,j);mxy(i,j),myy(i,j)];
        process(i, j) =det(M) - k *(trace(M)^2);
    end
end

%�Ǽ���ֵ����
%�ҳ�ͼ��������ӦֵMax������ֵ��Ϊ0.01*Max
Max=max(process(:));
t=Max*0.01;
process=padarray(process,[1 1],'both');

%ʹ����ֵ���˽ǵ�
for i=2:row+1
    for j=2:col+1
        if process(i,j)<t
            process(i,j)=0;
        end
    end
end

%�Ǽ���ֵ����
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

%�޳��߽��ϵ���Ч�ǵ�
response=process(2:row+1,2:col+1);
response(1:border,:)=0;
response(:,1:border)=0;
response(row-border+1:row,:)=0;
response(:,col-border+1:col)=0;

response(response~=0)=1;
end

%��������x,y�����ظõ����ڵ�����㣬����(x,y)
function neighbors=get_neighbors(m,x,y)
neighbors =[m(x-1,y-1),m(x-1,y),m(x-1,y+1),m(x,y-1),m(x,y+1),m(x+1,y-1),m(x+1,y),m(x+1,y+1)];
end

