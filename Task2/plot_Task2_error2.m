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
n = 2000;
points = 41;
avertime = 7;

% 参数、变量自动初始化
info = rand(1, n)<.5;
errateh = zeros(points, 1);
errate2 = zeros(points, 1);
errate1 = zeros(points, 1);
wordErrateh = zeros(points, 1);
wordErrate2 = zeros(points, 1);
wordErrate1 = zeros(points, 1);

bitstream_in = Convol_Code(info, 1, if_tail);
bitstream_in1 = Convol_Code(info, 1, if_tail);
bitstream_in2 = Convol_Code(info, 2, if_tail);
Ebn0  = zeros(1,points);

for ii = 1:points
    f_s = f_s + df_s;
    % f_s = f_s*2;
    for jj = 1:avertime
        [recv_sign,E_b,input_signal,output_signal] = complex_bsc_channel(bitstream_in, 2, T, K, f_s,n_0);
        judge_out = judging(recv_sign,2,bitstream_in,1);
        info_decode = Convol_DecodePro(judge_out, 1);
        errateh(ii) = errateh(ii) + sum(abs(info_decode(1:n)-info))/n;
        wordErrateh(ii) = wordErrateh(ii) + WordError(info,info_decode(1:n));
        
        [recv_sign,E_b,input_signal,output_signal] = complex_bsc_channel(bitstream_in2, 3, T, K, f_s,n_0);
        judge_out = judging(recv_sign,3,bitstream_in2,1);
        info_decode2 = Convol_DecodePro(judge_out, 2);
        errate2(ii) = errate2(ii) + sum(abs(info_decode2(1:n)-info))/n;
        wordErrate2(ii) = wordErrate2(ii) + WordError(info,info_decode2(1:n));
    end
    Ebn0(ii) = E_b/n_0;
end

figure;
plot(Ebn0, errateh/avertime, LineWidth = 1.5); 
hold on 
plot(Ebn0, errate2/avertime, LineWidth = 1.5); 
xlabel("E_b/n_0");
ylabel("误码率");
legend("2bit映射1/2效率","3比特映射1/3效率");
title("误码率：收尾/软判");

figure;
plot(Ebn0, wordErrateh/avertime, LineWidth = 1.5); 
hold on 
plot(Ebn0, wordErrate2/avertime, LineWidth = 1.5); 
xlabel("E_b/n_0");
ylabel("误字率");
legend("2比特映射1/2效率","3比特映射1/3效率");
title("误字率：收尾/软判");

