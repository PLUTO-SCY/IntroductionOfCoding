clear all 
close all
clc

%需要手动调节的参数：
K = [10:0.1:11];
T = zeros(size(K));
for i = 1:length(K)
    T(i) = 21;
end
axis = [];
for i = 1:length(K)
    axstr = "T="+string(T(i))+",K="+string(K(i));
    axis = [axis,axstr];
end
f_s = 2e5; % 初值不要设太低
df_s = 3e4; % 增量可以小些
n_0 = 1e-5;
if_tail = 1; % 收尾

% 绘图相关、控制运算量等超参数
n = 3000;
points = 41;
avertime = 7;
bitnum = 2;

% 参数、变量自动初始化
epoch = length(T);
mode = bitnum - 1;
info = rand(1, n)<.5;
errates = zeros(epoch,points);
wordErrates = zeros(epoch,points);
bitstream_in = Convol_Code(info, mode, if_tail);
Ebn0  = zeros(1,points);


for ii = 1:points
    f_s = f_s + df_s;
    % f_s = f_s*2;
    for jj = 1:avertime
        for e = 1:epoch
            [recv_sign,E_b,input_signal,output_signal] = complex_bsc_channel(bitstream_in, bitnum, T(e), K(e), f_s,n_0);
            judge_out = judging(recv_sign,bitnum,bitstream_in,1);
            info_decode2 = Convol_DecodePro(judge_out, mode);
            errates(e,ii) = errates(e,ii) + sum(abs(info_decode2(1:n)-info))/n;
            wordErrates(e,ii) = wordErrates(e,ii) + WordError(info,info_decode2(1:n));
%             if ii == 40 & jj == 2
%                 figure;
%                 plot(info~=info_decode2(1:n));
%                 b = 1;
%             end
         end
    end
    Ebn0(ii) = E_b/n_0;
end

% T = [21 20 25 22 17];
% K = [ 3  7  5  9  7];
figure;
plot(Ebn0, errates(1,:)/avertime, LineWidth = 1.5); 
for i = 2:epoch
    hold on 
    plot(Ebn0, errates(i,:)/avertime, LineWidth = 1.5); 
end
xlabel("E_b/n_0");
ylabel("误码率");
legend(axis);
title("误码率：2bit映射1/2效率/收尾/软判");

figure;
plot(Ebn0, wordErrates(1,:)/avertime, LineWidth = 1.5); 
for i = 2:epoch
    hold on 
    plot(Ebn0, wordErrates(i,:)/avertime, LineWidth = 1.5); 
end
xlabel("E_b/n_0");
ylabel("误字率");
legend(axis);
title("误字率：2bit映射1/2效率/收尾/软判 ");

