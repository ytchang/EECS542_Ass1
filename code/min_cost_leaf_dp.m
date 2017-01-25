function [ D,min_D ,min_loc] = min_cost_leaf_dp(k,loc_parent, leaf_part,seq )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% l_leaf_initial = [0,0,0,0];
% l_leaf = l_leaf_initial;
image_height = 720; image_width = 405; x_buckets = 20; y_buckets = 20;
scale_buckets = 5; theta_buckets = 10;
xs = linspace(1,image_width,x_buckets);
ys = linspace(1,image_height,y_buckets);
scales = linspace(0.1,5,scale_buckets);
thetas = linspace(-pi/2,pi/2,theta_buckets);

D = zeros(x_buckets,y_buckets,scale_buckets,theta_buckets);
min_index = [1 1 1 1];
min_D = Inf;
for x_i = 1:x_buckets
    for y_i = 1:y_buckets
        for s_i=1:scale_buckets
            for theta_i=1:theta_buckets
                D(x_i,y_i,s_i,theta_i) = match_energy_cost([xs(x_i),ys(y_i),scales(s_i),thetas(theta_i)],leaf_part,seq);
                if D(x_i,y_i,s_i,theta_i) < min_D
                    min_index = [x_i,y_i,s_i,theta_i];
                    min_D = D(x_i,y_i,s_i,theta_i);
                end
                
            end
        end
    end
end
% [min_D,min_D_index] = min(D(:));
% display(min_index);
min_loc = [ xs(min_index(1)) ys(min_index(2)) scales(min_index(3)) thetas(min_index(4))];

end

