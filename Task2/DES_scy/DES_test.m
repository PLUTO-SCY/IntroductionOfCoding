clear all;
close all;
clc;

message=(randi([0,1],16,64)>0.5);
message = '且使我有雒阳负郭田二顷，吾岂能佩六国相印乎！——苏秦';  % 设置密文
bitstream = txt2bitstream(message); %把文本转换成01符号序列，长度一定为64的倍数

% result = bitstream2txt(bitstream)

key = test_getkey();        %随机生成key
ciphertext = test_encoder(key,bitstream);  % 加密模块
decryptedtext = test_decoder(key,ciphertext);  % 解密模块

diff=(sum(bitstream~=decryptedtext)); 
fprintf("明文与解密密文之间的汉明距离:");
disp(diff);                      % 输出解密后的结果与初始明文所对应01序列之间的距离。 

display(bitstream2txt(decryptedtext))  %把解密后的01序列再转变成文本输出
