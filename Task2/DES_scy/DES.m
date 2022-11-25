function secret = DES(message, key,encodeordecode)

    DES_param;  %生成DES加密所需要的参数
    SubKeyList=DES_get_key(key,KeyTable1,KeyTable2);

    message_afterIP = message(IP); %首先做IP置换
    L = message_afterIP(1:32);
    R = message_afterIP(33:64); %左右分开
    
    % 加密/解密 选择
    if encodeordecode=="decode"
        SubKeyList = flipud(SubKeyList);
    elseif encodeordecode~="encode"
        error("输入不符合要求");
    end

    for i = 1:16 %迭代计算16次
        tmp = R;
        tmp = tmp(Ext); %32位扩展成48位，有重复项
        tmp = xor(tmp, SubKeyList(i,:)); %与子密钥异或
        sout = zeros(1,32);
        for k = 1:8 %S变换,6位一组
            row = 2 * double(tmp((k-1) * 6 + 1)) + double(tmp((k-1) * 6 + 6)); %行数由高低两位指定
            column = 8 * double(tmp((k-1) * 6 + 2)) + 4 * double(tmp((k-1) * 6 + 3))...
            + 2 * double(tmp((k-1) * 6 + 4)) + double(tmp((k-1) * 6 + 5)); %列数由四位指定
            num = S(k,row * 16 + column+1); %从S盒中取出对应数字            
            sout(4*k+1-4:4*k+1-1) = decToBin(num);
        end
        %最终输出结果为32位
        sout = xor(sout(P), L); %P盒变换后与左半边做异或
        L = R;
        R = sout; %交换左右
    end
    
    message_Reorganization = [R,L];  %左右两边拼接
    secret = message_Reorganization(IPInv);  %逆IP变化
end
