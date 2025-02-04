% assume a large difference
mindiff = 1e7;
minoffsetX = 0;
minoffsetY = 0;

% compare two 1 row*N column matrix 
% for each offset sum the abs difference between the two segments

% slen : shift range for comparing
if vtPanoramic == 1
    for halfOffset = halfOffsetRange

        seg2 = circshift(seg2,[0 halfOffset]);

        for offsetY = 0:slenY
            for offsetX = 0:slenX
                cdiff = abs(seg1(1 + offsetY : cwlY , 1 + offsetX : cwlX) - seg2(1 : cwlY - offsetY, 1 : cwlX - offsetX));
                cdiff = sum(sum(cdiff)) / (cwlY - offsetY) * (cwlX - offsetX) ;
                if (cdiff < mindiff)
                    mindiff = cdiff;
                    minoffsetX = offsetX;
                    minoffsetY = offsetY;
                end
            end
        end

        for offsetY = 1:slenY
            for offsetX = 1:slenX
                cdiff = abs(seg1(1 : cwlY - offsetY, 1 : cwlX - offsetX) - seg2(1 + offsetY : cwlY, 1 + offsetX : cwlX));
                cdiff = sum(sum(cdiff)) / (cwlY - offsetY) * (cwlX - offsetX) ;
                if (cdiff < mindiff)
                    mindiff = cdiff;
                    minoffsetX = -offsetX;
                    minoffsetY = -offsetY;
                end
            end
        end

    end
    offsetX = minoffsetX;
    offsetY = minoffsetY;
    sdif = mindiff;
    
else

    for offsetY = 0:slenY
        for offsetX = 0:slenX
            cdiff = abs(seg1(1 + offsetY : cwlY , 1 + offsetX : cwlX) - seg2(1 : cwlY - offsetY, 1 : cwlX - offsetX));
            cdiff = sum(sum(cdiff)) / (cwlY - offsetY) * (cwlX - offsetX) ;
            if (cdiff < mindiff)
                mindiff = cdiff;
                minoffsetX = offsetX;
                minoffsetY = offsetY;
            end
        end
    end

    for offsetY = 1:slenY
        for offsetX = 1:slenX
            cdiff = abs(seg1(1 : cwlY - offsetY, 1 : cwlX - offsetX) - seg2(1 + offsetY : cwlY, 1 + offsetX : cwlX));
            cdiff = sum(sum(cdiff)) / (cwlY - offsetY) * (cwlX - offsetX) ;
            if (cdiff < mindiff)
                mindiff = cdiff;
                minoffsetX = -offsetX;
                minoffsetY = -offsetY;
            end
        end
    end

    offsetX = minoffsetX;
    offsetY = minoffsetY;
    sdif = mindiff;
end