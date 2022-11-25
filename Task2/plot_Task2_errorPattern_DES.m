clear all 
close all
clc

addpath DES_scy

%需要手动调节的参数：
T = 21;
K = 3;
f_s = 2e5; % 初值不要设太低
df_s = 3e4; % 增量可以小些
n_0 = 5e-5;
if_tail = 1; % 收尾
ii = 11;

% 绘图相关、控制运算量等超参数
n = 2000;
bitnum = 3;

% 参数、变量自动初始化
key = test_getkey(); %初始化加密密钥

mode = bitnum - 1;
origininfo = rand(1, n)<.5;
info = test_encoder(key,origininfo);
bitstream_in = Convol_Code(info, mode, if_tail);
errateh = 0;
wordErrateh = 0;
errates = 0;
wordErrates = 0;


f_s = f_s + df_s*ii;
% f_s = f_s*2;

    [recv_sign,E_b,input_signal,output_signal] = complex_bsc_channel(bitstream_in, bitnum, T, K, f_s,n_0);

    
    judge_out = judging(recv_sign,bitnum,bitstream_in,0);
    info_decode = Convol_Decode(judge_out, mode, 1);
    info_decrypt = test_decoder(key, info_decode);
    errateh = errateh + sum(abs(info_decrypt(1:n)-origininfo))/n;
    wordErrateh = wordErrateh + WordError(origininfo,info_decrypt(1:n));
    

    %{
    judge_out = judging(recv_sign,bitnum,bitstream_in,1);
    info_decode2 = Convol_DecodePro(judge_out, mode);
    info_decrypt2 = test_decoder(key, info_decode2);
    errates = errates + sum(abs(info_decrypt2(1:n)-origininfo))/n;
    wordErrates = WordError(origininfo,info_decrypt2(1:n));
    %}

Ebn0 = E_b/n_0;

error_pattern_plaintext = origininfo~=info_decrypt(1:n);
error_pattern_ciphertext = info~=info_decode(1:length(info));

figure;
subplot(2,1,1);
error_im2(:,:,1)=error_pattern_ciphertext*255;
error_im2(:,:,2)=(1-error_pattern_ciphertext)*255;
error_im2(:,:,3)=0;
image(error_im2);
title("DES:密文误码图案");

subplot(2,1,2);
error_im(:,:,1)=error_pattern_plaintext*255;
error_im(:,:,2)=(1-error_pattern_plaintext)*255;
error_im(:,:,3)=0;
image(error_im);
title("DES:明文误码图案");

display(E_b);
fprintf("Eb/n0的值是%d:  ",E_b/n_0);

