function out = DecToBin2(x,len) 
% Convert Decimal to Binary vector. Big-Endian.

    y = double(dec2bin(abs(x)))-'0';
    temp = len-length(y);
    if temp>0
        temp = zeros(1,temp);
        y = [temp,y];
    end
    out = y;
    
end