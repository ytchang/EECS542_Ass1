function dat_val = get_L_from_coord(dat_pt,model_len,part)
%GET_L_FROM_COORD Summary of this function goes here
%   Detailed explanation goes here
dat_x=mean([dat_pt(1) dat_pt(3)]);
dat_y=mean([dat_pt(2) dat_pt(4)]);
dat_theta=atan((dat_pt(2)-dat_pt(4))/(dat_pt(1)-dat_pt(3)))
dat_scale=sqrt(sum([dat_pt(1)-dat_pt(3),dat_pt(2)-dat_pt(4)].^2))/model_len(part);
dat_val=[dat_x, dat_y, dat_theta, dat_scale];

end

