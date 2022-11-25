close all,clear all,clc
% bitstream = [0,0,0,1,1,1,1,0];
bitstream = [0,0,0,0,0,1,0,1,1,0,1,0,1,1,0,1,1,1,1,0,1,1,0,0];

bitstream = repmat(bitstream,1,30);   % 重复了30次

bit_num = 3;
T = 21;
K = 3;
f_s = 1e5;
n_0 = 1e-5;


recv_sign_1 = simple_bsc_channel(...
    bitstream, bit_num, T, K, ...
    f_s,n_0);

[recv_sign_2,E_b,input_signal,output_signal] = complex_bsc_channel(...
    bitstream, bit_num, T, K, ...
    f_s,n_0);

%% for test channel
    bit_out_ez = judging(recv_sign_1,bit_num,bitstream,0);
    disp(sum(abs(bitstream - bit_out_ez)));
    bit_out_cp = judging(recv_sign_2,bit_num,bitstream,0);
    disp(sum(abs(bitstream - bit_out_cp)));


%% for plot psd

figure;
for id = 1:8
      subplot(8,1,id)
      plot(1:T,input_signal((id-1)*T+1:id*T));
end


[idx_i,psd_i] = draw_power_density(input_signal);
[idx_o,psd_o] = draw_power_density(output_signal);
figure;
subplot(2,1,1);
plot(idx_i,psd_i);
title('输入信号功率谱');
xlabel('w/2pi');
ylabel('功率谱密度');

subplot(2,1,2);
plot(idx_o,psd_o);
title('输出信号功率谱');
xlabel('w/2pi');
ylabel('功率谱密度');

% plot the input and ouput signal

% figure;
% subplot(2,1,1)
% plot(1:length(input_signal),input_signal);
% subplot(2,1,2)
% plot(1:length(output_signal),output_signal);
