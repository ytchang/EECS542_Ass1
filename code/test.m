ideal_L=zeros(4,6);
for i=1:6
   ideal_L(:,i)=transpose(get_L_from_coord(transpose(c_ideal(:,i)),model_len,i));
end
ideal_L
%%
i=6
cost16=deformation_cost(ideal_L(:,3)',3,ideal_L(:,1)',1)
%%
ideal_c2=zeros(4,6);
for i=1:6
   ideal_c2(:,i)=transpose(get_coord_from_L(transpose(ideal_L(:,i)),model_len,i));
end
ideal_c2