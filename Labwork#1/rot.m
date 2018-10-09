function R = rot(axis,teta,unit)
	if(unit=='deg')
		% Conv to Rad (can also use deg2rad)
		teta=(teta/180)*pi;
	end
    if(axis=='X')
        R=[1 0 0 ; 0 cos(teta) -sin(teta) ; 0 sin(teta) cos(teta)];
    end
    if(axis=='Y')
        R=[cos(teta) 0 sin(teta) ; 0 1 0 ; -sin(teta) 0 cos(teta)];
    end
    if(axis=='Z')
        R=[cos(teta) -sin(teta) 0 ; sin(teta) cos(teta) 0 ; 0 0 1];
    end
end