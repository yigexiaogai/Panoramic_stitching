function matches = match_descriptors( desc1,desc2,threshold )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[length_disc1,length_n]=size(desc1);
[length_disc2,length_n]=size(desc2);
length_n=length_n-2;
matches=[]; %���ڴ洢ƥ���

for i=1:length_disc1
    disMap=[];%���ڴ洢һ�ž�������а�����ľ��������
%     min_dis=sqrt( sum( ( desc1(i,3:end)-disc2(1,3:end) ).^2 ));%��һ����ʼ��Сֵ
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

