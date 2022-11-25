clear all 
close all
clc

%需要手动调节的参数：
T = 21;
K = 3;
f_s = 2e5; % 初值不要设太低
df_s = 3e4; % 增量可以小些
n_0 = 1e-5;
if_tail = 1; % 收尾

% 绘图相关、控制运算量等超参数
n = 1000;
points = 41;
avertime = 5;
bitnum = 3;

% 参数、变量自动初始化
mode = bitnum - 1;
info = rand(1, n)<.5;
errateh = zeros(points, 1);
errates = zeros(points, 1);
wordErrateh = zeros(points, 1);
wordErrates = zeros(points, 1);
bitstream_in = Convol_Code(info, mode, if_tail);
Ebn0  = zeros(1,points);

for ii = 1:points
    f_s = f_s + df_s;
    % f_s = f_s*2;
    for jj = 1:avertime
        [recv_sign,E_b,input_signal,output_signal] = complex_bsc_channel(bitstream_in, bitnum, T, K, f_s,n_0);
        
        judge_out = judging(recv_sign,bitnum,bitstream_in,0);
        info_decode = Convol_Decode(judge_out, mode, 1);
        errateh(ii) = errateh(ii) + sum(abs(info_decode(1:n)-info))/n;
        wordErrateh(ii) = wordErrateh(ii) + WordError(info,info_decode(1:n));
        
        
        judge_out = judging(recv_sign,bitnum,bitstream_in,1);
        info_decode2 = Convol_DecodePro(judge_out, mode);
        errates(ii) = errates(ii) + sum(abs(info_decode2(1:n)-info))/n;
        wordErrates(ii) = wordErrates(ii) + WordError(info,info_decode2(1:n));
    end
    Ebn0(ii) = E_b/n_0;
end

figure;
plot(Ebn0, errateh/avertime, LineWidth = 1.5); 
hold on 
plot(Ebn0, errates/avertime, LineWidth = 1.5); 
xlabel("E_b/n_0");
ylabel("误码率");
legend("硬判","软判");
title("误码率：3bit映射/收尾/ 1/3效率");

figure;
plot(Ebn0, wordErrateh/avertime, LineWidth = 1.5); 
hold on 
plot(Ebn0, wordErrates/avertime, LineWidth = 1.5); 
xlabel("E_b/n_0");
ylabel("误字率");
legend("硬判","软判");
title("误字率：3bit映射/收尾/ 1/3效率");

