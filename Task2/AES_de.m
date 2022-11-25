function out = AES_de(info_decode,n,key)
    infomation = [];    
    strlength = n/8;
    for k = 1:strlength/16
        info = zeros(1,strlength);
        for i = 1:16
            bitblock = info_decode(i*8-7+k*128-128:i*8+k*128-128);
            bitstr = string(double(bitblock));
            b = '';
            for j =1:8
                b = strcat(b,bitstr(j));
            end
            ascii = bin2dec(b);
            info(i) = ascii;    
        end            
        demsg = IAES(info, key);
        infomation = [infomation,demsg];
    end
    info_decrypt = infomation;
    info_decryption = zeros(1,n);
    for i = 1:length(info_decrypt)
        info_decryption(i*8-7:i*8) = DecToBin2(info_decrypt(i),8);
    end
    out = info_decryption; 
end

