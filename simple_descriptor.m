function feature = simple_descriptor( patch )
% �˴���ʾ��ϸ˵��
% ������ֵ�ֲ����б�׼��̬�����������Сpatch (��׼��̬�ֲ��ľ�ֵΪ0����׼��Ϊ1)
% Ȼ����չ����һά������
% patch: �ߴ�Ϊ (H, W)�ĻҶ�ͼ��
% feature: �ߴ�Ϊ (H * W)��һά����

feature=[];

%չ����һά����
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

