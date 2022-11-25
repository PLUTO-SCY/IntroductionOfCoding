clear all 
close all
clc


%需要手动调节的参数：
T = 21;
K = 3;
f_s = 2e5; % 初值不要设太低
df_s = 3e4; % 增量可以小些
n_0 = 5e-6;
if_tail = 1; % 收尾
ii = 11;

% 绘图相关、控制运算量等超参数
n = 2048;
bitnum = 3;

mode = bitnum - 1;
origininfo = rand(1, n)<.5;

% key = double('lIFe!wont!chAnGe');
key = double('xxxxxxxxxxxxxxxx');
keybit = zeros(1,16);
for i = 1:16
    keybit(i*8-7:i*8) = DecToBin2(key(i),8);
end
keythroughchannel = RSA_key(key,n_0);
% keythroughchannel = key;
% keythroughchannel(5) = char(keythroughchannel(5)-5);
keythroughchannelbit = zeros(1,128);
for i = 1:16
    keythroughchannelbit(i*8-7:i*8) = DecToBin2(keythroughchannel(i),8);
end


% 把加密函数封装成AES_en
strlength = n/8;
info_encryption = AES_en(origininfo,key);

bitstream_in = Convol_Code(info_encryption, mode, if_tail);
errateh = 0;
wordErrateh = 0;
errates = 0;
wordErrates = 0;


f_s = f_s + df_s*ii;
% f_s = f_s*2;

    [recv_sign,E_b,input_signal,output_signal] = complex_bsc_channel(bitstream_in, bitnum, T, K, f_s,n_0);

    
    judge_out = judging(recv_sign,bitnum,bitstream_in,0);
    info_decode = Convol_Decode(judge_out, mode, 1);
    
    % 译码
    info_decode = info_decode(1:n);
%     info_decode = info_encryption; % *****************
    info_decryption = AES_de(info_decode,n,keythroughchannel);
    info_decrypt = info_decryption;    
    
    
    errateh = errateh + sum(abs(info_decrypt(1:n)-origininfo))/n;
    wordErrateh = wordErrateh + WordError(origininfo,info_decrypt(1:n));
   

Ebn0 = E_b/n_0;

error_pattern_plaintext = origininfo~=info_decrypt(1:n);
error_pattern_ciphertext = info_encryption~=info_decode(1:n);
error_pattern_key = keythroughchannelbit~=keybit;

figure;
subplot(3,1,1);
error_im3(:,:,1)=error_pattern_key*255;
error_im3(:,:,2)=(1-error_pattern_key)*255;
error_im3(:,:,3)=0;
image(error_im3);
title("RSA key误码图案");

subplot(3,1,2);
error_im2(:,:,1)=error_pattern_ciphertext*255;
error_im2(:,:,2)=(1-error_pattern_ciphertext)*255;
error_im2(:,:,3)=0;
image(error_im2);
title("AES:密文误码图案");

subplot(3,1,3);
error_im(:,:,1)=error_pattern_plaintext*255;
error_im(:,:,2)=(1-error_pattern_plaintext)*255;
error_im(:,:,3)=0;
image(error_im);
title("AES:明文误码图案");

display(E_b);
fprintf("Eb/n0的值是%d:  ",E_b/n_0);
