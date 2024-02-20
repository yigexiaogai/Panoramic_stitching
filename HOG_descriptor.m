function feature = HOG_descriptor(patch,patch_size )
% ��������HOG�����㷨
%   ������patch,patch_size
%   ����Ϊ�˼��㷨 ����һ�ɽ�patch��Ϊblock��һ�ɻ��ֳ�2*2��cell

[m n]=size(patch);
patch=sqrt(patch);      %٤��У��

%���������Ե
fy=[-1 0 1];        %������ֱģ��
fx=fy';             %����ˮƽģ��
Iy=imfilter(patch,fy,'replicate');    %��ֱ��Ե
Ix=imfilter(patch,fx,'replicate');    %ˮƽ��Ե
Ied=sqrt(Ix.^2+Iy.^2);              %��Եǿ��
Iphase=Iy./Ix;              %��Եб�ʣ���ЩΪinf,-inf,nan������nan��Ҫ�ٴ���һ��

%��������cell
step=patch_size/2;      %step*step��������Ϊһ����Ԫ
orient=9;               %����ֱ��ͼ�ķ������
range=360/orient;       %ÿ����������ĽǶȷ�Χ
Cell=cell(2,2);         %���еĽǶ�ֱ��ͼ,cell�ǿ��Զ�̬���ӵģ�����������һ��
ii=1;                      
jj=1;
for i=1:step:m          %��������m/step���������������i=1:step:m-step
    ii=1;
    for j=1:step:n      %ͬ��
        tmpx=Ix(i:i+step-1,j:j+step-1);  %��ǰcell�ĺ����ݶ�
        tmped=Ied(i:i+step-1,j:j+step-1);%��ǰcell���ݶ�
        tmped=tmped/sum(sum(tmped));     %�ֲ���Եǿ�ȹ�һ��
        tmpphase=Iphase(i:i+step-1,j:j+step-1);%��ǰcell�ı�Եб��
        Hist=zeros(1,orient);            %��ǰstep*step���ؿ�ͳ�ƽǶ�ֱ��ͼ,����cell��һ����orient��
        %����ֱ��ͼ����
        for p=1:step
            for q=1:step
                if isnan(tmpphase(p,q))==1  %0/0��õ�nan�����������nan������Ϊ0(��ֹǿ��Ϊ0�ĵط�Ӱ��)
                    tmpphase(p,q)=0;
                end
                ang=atan(tmpphase(p,q));    %atan�����[-90 90]��֮�䣬������������Ŀ��������������෴
                ang=mod(ang*180/pi,360);    %ȫ��������-90��270
                if tmpx(p,q)<0              %����x����ȷ�������ĽǶ�
                    if ang<90               %����ǵ�һ����
                        ang=ang+180;        %�Ƶ���������
                    end
                    if ang>270              %����ǵ�������
                        ang=ang-180;        %�Ƶ��ڶ�����
                    end
                end
                ang=ang+0.0000001;          %��ֹangΪ0
                Hist(ceil(ang/range))=Hist(ceil(ang/range))+tmped(p,q);   %ceil����ȡ����ʹ�ñ�Եǿ�ȼ�Ȩ
            end
        end
        Hist=Hist/sum(Hist);    %����ֱ��ͼ��һ��
        Cell{ii,jj}=Hist;       %����Cell��
        ii=ii+1;                %���Cell��y����ѭ������
    end
    jj=jj+1;                    %���Cell��x����ѭ������
end

%��������feature,2*2��cell�ϳ�һ��block
feature=[Cell{1,1}(:)', Cell{1,2}(:)',  Cell{2,1}(:)',  Cell{2,1}(:)'];

end

