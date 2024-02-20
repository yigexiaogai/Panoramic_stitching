function H = ransac(matches,sample,k,threshold)
% ransac����
%   ����Ϊѭ������ ��ƥ�������㣬���Ϊһ���任����

%�����ѭ��
matches_size=size(matches,1); %��ȡmatch����

matches_A=[matches(:,1:2),ones(matches_size,1)];
matches_B=[matches(:,3:4),ones(matches_size,1)];
countMap=zeros(k,10); %����һ�������õĽṹ�壬�ɵ�һ��Ϊ���룬��2��10��Ϊ�任����
for i=1:k
    %���ѡĳ����matches
    rander=ceil(rand(sample,1)*matches_size); %���������
    matches_choice=matches( rander(:),: ); %��ȡ��Ӧ������
    
    %�����⼸������H
    add=ones(sample,1);%��������1��������
    matches_a=[matches_choice(:,1:2),add];
    matches_b=[matches_choice(:,3:4),add];
    
    H=fit_affine_matrix(matches_a, matches_b); %�õ��˱任���� A*H->B H(3*3)
    
    %���任����Ӧ�õ�����matches_A��
    matches_C=matches_A*H;
    %���õ���������mateches_A������Ƚ�,�õ�dis����
    dis =( matches_C(:,1)-matches_B(:,1) ).^2+( matches_C(:,2)-matches_B(:,2) ).^2;
    %��dis���м���С����ֵ�ĵ�
    count=sum(dis(:)<threshold);
    %���countMap�ṹ��
    countMap(i,1)=count;
    countMap(i,2:10)=reshape(H,1,9);
    
    %��MAP��������
    countMap=sortrows(countMap,-1);
end

H=countMap(1,2:10);
H=reshape(H,3,3);
H(:,3)=[0 0 1];
end

