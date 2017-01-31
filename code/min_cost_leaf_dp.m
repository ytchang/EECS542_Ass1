function [ D,min_D ,min_loc] = min_cost_leaf_dp(lF,k,l_parent,part_parent, part,seq )
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

D = (-1)*ones(x_buckets,y_buckets,scale_buckets,theta_buckets);
% initial loc configuration
% min_x_buk = 0;
% min_y_buk = 0;
% min_theta_buk = 0;
% min_s_buk = 0;
% min_buk = [0,0,0,0];
%% 

cur_buk = struct('x',0,'y',0,'theta',0,'s',0);
min_D = Inf;
new_buk = struct('x',2,'y',2,'theta',2,'s',2); %dummy initialization
% need more robust teminating rule to prevent infinite loop
% or even not looping at all?
while ~isequal(new_buk,cur_buk)
    
    cur_buk = new_buk;
    display(cur_buk)
    [D_new_val, new_buk] = single_iter_D(cur_buk);
    if D_new_val < min_D
        min_D = D_new_val;
        
    end
    
end

min_loc = [xs(new_buk.x),ys(new_buk.y),scales(new_buk.theta),thetas(new_buk.s)];
%% 





    function D_val = init_D(cur_bucket)
        % init D[cur_bucket] to f(w) when D[cur_bucket] == -1
        
%         subCell = num2cell(cur_bucket); 
%         cur_bucket_index = subCell{:};
        if D(cur_bucket.x,cur_bucket.y,cur_bucket.theta,cur_bucket.s)==-1
%              need to compute f(w)
            cur_loc = [xs(cur_bucket.x),ys(cur_bucket.y),scales(cur_bucket.theta),thetas(cur_bucket.s)]
            D(cur_bucket.x,cur_bucket.y,cur_bucket.theta,cur_bucket.s)...
                = deformation_cost( l_parent,part_parent,cur_loc,part ) ...
                +match_energy_cost(cur_loc,part,seq,lF);
        end
        D_val = D(cur_bucket.x,cur_bucket.y,cur_bucket.theta,cur_bucket.s);
    end

    function [D_new_val, new_buk] = single_iter_D(cur_buk)
        % compute single iteration
        % return the min value for updating D
        % and new bucket for next iteration of loop
        % no constant "k" version now
        original = init_D(cur_buk);
        local_min_val = original;
        new_buk = cur_buk;
        x_incr = Inf;
        if cur_buk.x > 1
            cur_buk.x = cur_buk.x+1;
            x_incr = init_D(cur_buk);
            cur_buk.x = cur_buk.x-1;
        end
        y_incr = Inf;
        if cur_buk.y > 1
            cur_buk.y = cur_buk.y+1;
            y_incr = init_D(cur_buk);
            cur_buk.y = cur_buk.y-1;
        end
        theta_incr = Inf;
        if cur_buk.theta > 1
            cur_buk.theta = cur_buk.theta+1;
            theta_incr = init_D(cur_buk);
            cur_buk.theta = cur_buk.theta-1;
        end
        s_incr = Inf;
        if cur_buk.s > 1
            cur_buk.s = cur_buk.s+1;
            s_incr = init_D(cur_buk);
            cur_buk.s = cur_buk.s-1;
        end
%         update min_val and new_buk
        if x_incr < local_min_val
            new_buk = cur_buk;
            new_buk.x = cur_buk.x+1;
            local_min_val = x_incr;
        end
        if y_incr < local_min_val
            new_buk = cur_buk;
            new_buk.y = cur_buk.y+1;
            local_min_val = y_incr;
        end
        if theta_incr < local_min_val
            new_buk = cur_buk;
            new_buk.theta = cur_buk.theta+1;
            local_min_val = theta_incr;
        end
        if s_incr < local_min_val
            new_buk = cur_buk;
            new_buk.s = cur_buk.s+1;
            local_min_val = s_incr;
        end
        D_new_val = local_min_val;
    end
end


