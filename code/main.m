%% environment setup

% eval('run(startup.m)');
run('startup.m');
close all;
%% read img and txt file

% change here for different images
image_seq = 1;
lF = ReadStickmenAnnotationTxt('../data/buffy_s5e2_sticks.txt'); 
frames = [lF.frame];
img_frame = frames(image_seq);
img_file = strcat('../buffy_s5e2_original/',num2str(img_frame,'%06d'),'.jpg')

img = imread(img_file); 
hdl = DrawStickman(lF(image_seq).stickmen.coor, img); 

%% run dp func
tic
k = [];
root_s = 1;
loc_parent = [403,270,1,root_s];

% test only by head ( and suume torso is given in the arg
% [ D,min_D ,min_loc] = min_cost_leaf_dp(lF,k,loc_parent,1,6,image_seq,[275 143 1 1.5] );

% test by torso
[ D,min_D ,min_loc] = min_cost_leaf_dp(lF,k,[],0,1,image_seq );
display(min_loc)
toc
figure
% need computer vision toolbox to draw circle on img in the code below
RGB = insertShape(img,'circle',[min_loc(1,1) min_loc(2,1) 10],'Color','blue','LineWidth',5);
RGB = insertShape(RGB,'circle',[min_loc(1,2) min_loc(2,2) 10],'Color','red','LineWidth',5);
RGB = insertShape(RGB,'circle',[min_loc(1,3) min_loc(2,3) 10],'Color','green','LineWidth',5);
RGB = insertShape(RGB,'circle',[min_loc(1,6) min_loc(2,6) 10],'Color','cyan','LineWidth',5);

imshow(RGB);