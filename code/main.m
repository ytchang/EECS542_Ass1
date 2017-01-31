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
loc_parent = [198,292,1,1];
[ D,min_D ,min_loc] = min_cost_leaf_dp(lF,k,loc_parent,1,6,image_seq );
display(min_loc)
toc
figure
RGB = insertShape(img,'circle',[loc_parent(1) loc_parent(2) 35],'Color','yellow','LineWidth',5);
RGB = insertShape(RGB,'circle',[min_loc(1) min_loc(2) 35],'Color','blue','LineWidth',5);
imshow(RGB);