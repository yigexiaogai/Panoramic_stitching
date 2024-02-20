W=615;
d=300;
U=ones(1,W)
for i=1:d
    U(W-d+i)=1-1/d*i;
end

img1_warp=img1_warp.*U;