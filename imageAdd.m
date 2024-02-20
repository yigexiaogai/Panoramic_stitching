function img3 = imageAdd( img1_warp,img2_warp,matches )
%将两张图片拼合
[H1,W1]=size(img1_warp);
[H2,W2]=size(img2_warp);

if H1<=H2
    H3=H2*3+2;
else
    H3=H1*3+2;
end

if W1<=W2
    W3=W2*3+2;
else
    W3=W1*3+2;
end

img3=zeros(H3,W3);
%计算两张图片的相对位移
dw=round(sum( matches(:,4)-matches(:,2) )/size(matches,1)); %Bw-Aw=dw
dh=round(sum( matches(:,3)-matches(:,1) )/size(matches,1)); %Bh-Ah=dh

%将图片A放在底片正中心
A_left_corner_H=round((H3-H1)/2)+1;
A_left_corner_W=round((W3-W1)/2)+1;
A_right_corner_H=round((H3-H1)/2)+1;
A_right_corner_W=round((W3-W1)/2)+W1;

B_left_corner_H=round((H3-H2)/2)+1-dh;
B_left_corner_W=A_right_corner_W+1-dw;



%得到平移距离
img3( A_left_corner_H : A_left_corner_H+H1-1, A_left_corner_W : A_left_corner_W+W1-1 )=img1_warp*0.5;
img3( B_left_corner_H : B_left_corner_H+H2-1, B_left_corner_W : B_left_corner_W+W2-1 )=img3( B_left_corner_H : B_left_corner_H+H2-1,  B_left_corner_W : B_left_corner_W+W2-1 )+img2_warp*0.5;

%去掉周围的0
img3(all(img3==0,2),:) = [];
img3(:,all(img3==0,1)) = [];


figure
imshow(img3);title('重合后图像','FontSize',25);
end

