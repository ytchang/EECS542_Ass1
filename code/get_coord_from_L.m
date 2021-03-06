function coords = get_coord_from_L( Li,model_len,part )
%GET_COORD_FROM_L Summary of this function goes here
%   Detailed explanation goes here
    part_len=model_len(part);
    if part==1 | part ==6
        if Li(3)<0
            Li(3)=Li(3)+pi/2;
        else
            Li(3)=Li(3)-pi/2;
        end
    end
    halfLen_i=Li(4)*part_len/2;
    slope_i=tan(Li(3));
    if abs(slope_i)<10^-10
        p1_i=[Li(1)+halfLen_i, Li(2)];
        p2_i=[Li(1)-halfLen_i, Li(2)];
    else
        %half stick length if y diff is 1
        unitYLen_i=sqrt(1+1/slope_i/slope_i);
        %get y diff
        dy_i=halfLen_i/unitYLen_i;
        %get end points points(p1 upper, p2 lower)
        p1_i=[Li(1)+dy_i/slope_i, Li(2)+dy_i];
        p2_i=[Li(1)-dy_i/slope_i, Li(2)-dy_i];
        
    end
    coords=[p1_i p2_i];
end

