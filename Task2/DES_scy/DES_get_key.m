function SubkeyList = DES_get_key(key, KeyTable1, KeyTable2)
    % 由64位密钥生成16个48位子密钥
    SubkeyList = zeros(16, 48); %每行就是一个子密钥
    key0 = key(KeyTable1);     %IP置换
    for i = 1:16
        temp1 = key0(1:28);
        temp2 = key0(29:56); %将key0分成左右两个部分，分别执行循环移位
        if (i == 1 || i == 2 || i == 9 || i == 16)
            temp1 = [temp1(2:end), temp1(1)];
            temp2 = [temp2(2:end), temp2(1)];
        else
            temp1 = [temp1(3:end), temp1(1:2)];
            temp2 = [temp2(3:end), temp2(1:2)]; 
        end
        key0 = [temp1, temp2]; %重组
        keyFinal=key0(KeyTable2); %再度IP置换
        SubkeyList(i, :) = keyFinal; %填入当前密钥
    end
end
