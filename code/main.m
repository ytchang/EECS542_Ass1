%% environment setup

% eval('run(startup.m)');
run('startup.m');
%% read img and txt file

image_seq = 1;
lF = ReadStickmenAnnotationTxt('../data/buffy_s5e2_sticks.txt'); 
frames = [lF.frame];
img_frame = frames(image_seq);
img_file = strcat('../buffy_s5e2_original/',num2str(img_frame,'%06d'),'.jpg')
% img = imread('../buffy_s5e2_original/025837.jpg'); 
img = imread(img_file); 
hdl = DrawStickman(lF(image_seq).stickmen.coor, img); 
%% run dp func
tic
k = [];
loc_parent = [];
[ D,min_D ,min_loc] = min_cost_leaf_dp(lF,k,loc_parent,1,image_seq );
display(min_loc)
toc
