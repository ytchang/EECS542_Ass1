function [ D,min_D ,min_loc_all] = min_cost_leaf_dp(lF,k,l_parent,part_parent, part,seq,def_loc )
%min_cost_leaf_dp compute min cost of given parts by dynamic programming
% lF: stickman coor info,
% k: not used yet
% l_parent: [x, y, theta, scale] of parent (if part == torso, then useless)
% part_parent: whcih part parent is
% part,seq: seq of image
% def_loc: default location for the part (can be omitted)
% ouput==> D:used in dp (not neccessary to output?), min_D: minimum cost,
% min_loc_all: record the minimum location configure of the 6 parts
% (each col is for each part, e.g. min_loc_all(:,1) is location for torso)

def_buk = [1 1 1 1];
image_height = 720; image_width = 405; x_buckets = 30; y_buckets = 30;
theta_buckets = 20; scale_buckets = 10; 
if nargin == 7
    def_buk = [floor(def_loc(1)/(image_height/x_buckets)) floor(def_loc(2)/(image_width/y_buckets))...
        1 1];
    
    
end
xs = linspace(1,image_height,x_buckets);
ys = linspace(1,image_width,y_buckets);
thetas = linspace(0,pi/2,theta_buckets);
scales = linspace(1,5,scale_buckets);
D = (-1)*ones(x_buckets,y_buckets,theta_buckets,scale_buckets);


% for debugging output
% def_min_loc = [xs(def_buk(1)),ys(def_buk(2)),thetas(def_buk(4)),scales(def_buk(3))]
%% 
% initial loc (bucket) configuration
cur_buk = struct('x',0,'y',0,'theta',0,'s',0);
min_D = Inf;
new_buk = struct('x',def_buk(1),'y',def_buk(2),'theta',def_buk(3),'s',def_buk(4)); % dummy initialization
% need more robust teminating rule to prevent infinite loop
% or even not looping at all?
while ~isequal(new_buk,cur_buk) 
%     && cur_buk.x<x_buckets-1 ...
%         && cur_buk.y<y_buckets-1 && cur_buk.theta<theta_buckets-1 && cur_buk.s<scale_buckets-1
    
    cur_buk = new_buk;
    display(cur_buk)
    [D_new_val, new_buk] = single_iter_D(cur_buk);
    if D_new_val < min_D
        min_D = D_new_val;
        
    end
    
end

min_loc = [xs(new_buk.x),ys(new_buk.y),thetas(new_buk.theta),scales(new_buk.s)];
min_loc_all(:,part) = min_loc';
%% init_D
    function D_val = init_D(cur_bucket)
        % initialize D[cur_bucket] to f(w) when D[cur_bucket] == -1

%         display(cur_bucket)
        if D(cur_bucket.x,cur_bucket.y,cur_bucket.theta,cur_bucket.s)==-1
%              need to compute f(w)
            
            cur_loc = [xs(cur_bucket.x),ys(cur_bucket.y),thetas(cur_bucket.theta),scales(cur_bucket.s)];
            match_cost = match_energy_cost(cur_loc,part,seq,lF);
            deform_cost = 0; % for torso, deform cost = 0
           
            if part == 2 || part == 4 || part == 6
                % for not torso (root)
                deform_cost = deformation_cost( l_parent,part_parent,cur_loc,part );
            end
            Bc = 0;
            if part == 1
               % for torso
               for i=[2,3,6]
                   [ D_tmp,min_D_tmp ,min_loc_tmp] = min_cost_leaf_dp(lF,k,cur_loc,1, i,seq );
                   Bc = Bc + min_D_tmp;
                   min_loc_all(:,i) = min_loc_tmp(:,i);
               end
            end
%             display(Bc)
            D(cur_bucket.x,cur_bucket.y,cur_bucket.theta,cur_bucket.s)...
                = match_cost + deform_cost + Bc;
%                 = match_cost + Bc;
%                 = Bc
                
        end
        D_val = D(cur_bucket.x,cur_bucket.y,cur_bucket.theta,cur_bucket.s);
    end
%% single_iter_D

    function [D_new_val, new_buk] = single_iter_D(cur_buk)
        % compute single iteration
        % return the min value for updating D
        % and new bucket for next iteration of loop
        % no constant "k" version now
        original = init_D(cur_buk);
        local_min_val = original;
        new_buk = cur_buk;
        x_incr = Inf;
        if cur_buk.x >= 1 && cur_buk.x < x_buckets
            cur_buk.x = cur_buk.x+1;
            x_incr = init_D(cur_buk);
            cur_buk.x = cur_buk.x-1;
        end
        y_incr = Inf;
        if cur_buk.y >= 1 && cur_buk.y < y_buckets
            cur_buk.y = cur_buk.y+1;
            y_incr = init_D(cur_buk);
            cur_buk.y = cur_buk.y-1;
        end
        theta_incr = Inf;
        if cur_buk.theta >= 1 && cur_buk.theta+1 < theta_buckets
            cur_buk.theta = cur_buk.theta+1;
            theta_incr = init_D(cur_buk);
            cur_buk.theta = cur_buk.theta-1;
        end
        s_incr = Inf;
        if cur_buk.s >= 1 && cur_buk.s < scale_buckets
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


