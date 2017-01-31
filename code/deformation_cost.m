function cost = deformation_cost( Li,p_i,Lj,p_j )
    % L --> [x, y, theta, scale]  end points of the query stick  
    % pi,pj is the query part, 1=torso, 2=left upper arm, 3=right upper arm, 4=left lower arm, 5=right lower arm, 6= head
    % w is weight for x,y,theta,scale. x,y here refers to joint distance
    w=[50,50,1,50];
    model_len=[160, 95,95,65,65,60];
    %% make sure pi<pj
    if p_i>p_j
        temp=Li;
        Li=Lj;
        Lj=temp;
        temp=p_i;
        p_i=p_j;
        p_j=temp;
    end
   %% get coords(p1 upper, p2 lower)
    A=get_coord_from_L(Li,model_len,p_i);
    B=get_coord_from_L(Lj,model_len,p_j);
    p1_i=A(1:2);
    p2_i=A(3:4);
    p1_j=B(1:2);
    p2_j=B(3:4);
    
    %% get joint location
    shoulderWidth=90;
    if p_i==1&&p_j==6
        joint_i=p1_i;
        joint_j=p2_j;
        ideal_theta=0;
    elseif p_i==1&&p_j==2
        joint_i=p1_i;
        joint_i(1)=joint_i(1)-shoulderWidth/2;
        joint_j=p1_j;
        ideal_theta=0;
    elseif p_i==1&&p_j==4
        joint_i=p1_i;
        joint_i(1)=joint_i(1)+shoulderWidth/2
        joint_j=p1_j
        ideal_theta=0;
    elseif p_i==2&&p_j==3
        joint_i=p2_i;
        joint_j=p1_j;
        ideal_theta=0;
    elseif p_i==4&&p_j==5
        joint_i=p2_i;
        joint_j=p1_j; 
        ideal_theta=0;
    end
   %%
   joint_cost=w(1)*abs(joint_i(1)-joint_j(1))+w(2)*abs(joint_i(2)-joint_j(2));
   theta_cost=w(3)*abs(rem(Li(3)-Lj(3),2*pi)-ideal_theta);
   scale_cost=w(4)*abs(log(Li(4))-log(Lj(4)));
   cost=joint_cost+theta_cost+scale_cost;
end

