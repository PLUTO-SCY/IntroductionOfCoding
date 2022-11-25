function out = AES_en(origininfo,key)
% 输入是01序列
% 输出是01序列
    strlength = length(origininfo)/8;
    infomation = [];
    for k = 1:strlength/16
        info = zeros(1,strlength);
        for i = 1:16
            bitblock = origininfo(i*8-7+k*128-128:i*8+k*128-128);
            bitstr = string(double(bitblock));
            b = '';
            for j =1:8
                b = strcat(b,bitstr(j));
            end
            ascii = bin2dec(b);
            info(i) = ascii;    
        end
        info = AES(info, key);
        infomation = [infomation,info];
    end
    info_encryption = zeros(1,length(origininfo));
    for i = 1:length(infomation)
        info_encryption(i*8-7:i*8) = DecToBin2(infomation(i),8);
    end
    out = info_encryption;
end

