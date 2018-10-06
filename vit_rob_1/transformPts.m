function newPts = transformPts(Pts, T)
    newPts = zeros(size(Pts));
    for i = 1:size(Pts, 2)
        Pt = [Pts(:, i); 1];
        newPt = T * Pt;
        newPts(1:3, i) = newPt(1:3);
    end
    