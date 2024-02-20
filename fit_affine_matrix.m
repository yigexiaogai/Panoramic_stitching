function H = fit_affine_matrix( p1,p2)
%   仿射变换
%   此处显示详细说明
H=p1\p2;
H(:,3)=[0 0 1];
end

