function H = ransac(matches,sample,k,threshold)
% ransac函数
%   输入为循环次数 和匹配特征点，输出为一个变换矩阵

%进入大循环
matches_size=size(matches,1); %获取match长度

matches_A=[matches(:,1:2),ones(matches_size,1)];
matches_B=[matches(:,3:4),ones(matches_size,1)];
countMap=zeros(k,10); %生成一个计数用的结构体，由第一列为距离，第2到10列为变换矩阵
for i=1:k
    %随机选某几组matches
    rander=ceil(rand(sample,1)*matches_size); %生成随机数
    matches_choice=matches( rander(:),: ); %获取对应的坐标
    
    %根据这几个计算H
    add=ones(sample,1);%增加向量1的列向量
    matches_a=[matches_choice(:,1:2),add];
    matches_b=[matches_choice(:,3:4),add];
    
    H=fit_affine_matrix(matches_a, matches_b); %得到了变换矩阵 A*H->B H(3*3)
    
    %将变换矩阵应用到整个matches_A上
    matches_C=matches_A*H;
    %将得到的数据与mateches_A做距离比较,得到dis向量
    dis =( matches_C(:,1)-matches_B(:,1) ).^2+( matches_C(:,2)-matches_B(:,2) ).^2;
    %看dis里有几个小于阈值的点
    count=sum(dis(:)<threshold);
    %填充countMap结构体
    countMap(i,1)=count;
    countMap(i,2:10)=reshape(H,1,9);
    
    %对MAP进行排序
    countMap=sortrows(countMap,-1);
end

H=countMap(1,2:10);
H=reshape(H,3,3);
H(:,3)=[0 0 1];
end

