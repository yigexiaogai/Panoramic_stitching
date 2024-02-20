function matches = match_descriptors( desc1,desc2,threshold )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[length_disc1,length_n]=size(desc1);
[length_disc2,length_n]=size(desc2);
length_n=length_n-2;
matches=[]; %用于存储匹配点

for i=1:length_disc1
    disMap=[];%用于存储一张距离表，其中包含点的距离和坐标
%     min_dis=sqrt( sum( ( desc1(i,3:end)-disc2(1,3:end) ).^2 ));%定一个初始最小值
    for j=1:length_disc2
        dis=sqrt( sum( ( desc1(i,3:end)-desc2(j,3:end) ).^2 ));
        disMap=[disMap;dis,desc1(i,1:2),desc2(j,1:2) ];
    end
    
    disMap=sortrows(disMap);
    if disMap(1,1)/disMap(2,1)<=threshold
        matches=[ matches; disMap(1,2:end) ];
    end
end

end

