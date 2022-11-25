clear all 
close all
clc

addpath RSA_zhl

clear classes
obj = py.importlib.import_module('RSA');
py.importlib.reload(obj);

%需要手动调节的参数：
T = 21;
K = 3;
f_s = 2e5; % 初值不要设太低
df_s = 3e4; % 增量可以小些
n_0 = 1e-5;
if_tail = 1; % 收尾
ii = 11;
bitnum = 3;
mode = bitnum - 1;
n = 168;


key = double('Life_will_change');
RSA = cell(py.RSA.generateRSA());
emsg = py.RSA.encrypt(key, RSA{1}, RSA{3});
c = cell(emsg);
res = zeros(1,16);
for i =1:16
    res(i) = c{i};
end
emsg = res;
info_encryption = zeros(1,168);
for i = 1:length(emsg)
    info_encryption(i*8-7:i*8) = DecToBin2(emsg(i),8);
end
bitstream_in = Convol_Code(info_encryption, mode, if_tail);

                f_s = f_s + df_s*ii;
                % f_s = f_s*2;

                [recv_sign,E_b,input_signal,output_signal] = complex_bsc_channel(bitstream_in, bitnum, T, K, f_s,n_0);


                judge_out = judging(recv_sign,bitnum,bitstream_in,0);
                info_decode = Convol_Decode(judge_out, mode, 1);

                % 译码
                info_decode = info_decode(1:n);
                
                info = zeros(1,16);
                for i = 1:16
                    bitblock = info_decode(i*8-7:i*8);
                    bitstr = string(double(bitblock));
                    b = '';
                    for j =1:8
                        b = strcat(b,bitstr(j));
                    end
                    ascii = bin2dec(b);
                    info(i) = ascii;    
                end            
                decodeeeee = py.list(info);             
                
        

demsg = py.RSA.decrypt(decodeeeee, RSA{2}, RSA{3});
c = cell(demsg);
res = zeros(1,16);
for i =1:16
    res(i) = c{i};
end
res = char(double(res));


