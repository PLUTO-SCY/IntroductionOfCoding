clear 
% 检验AES正确性
tic
key = double('Life_will_change');
msg = double('Wake_up& Get_out')
emsg = AES(msg, key)
demsg = IAES(emsg, key)
char(demsg)
toc
%检验RSA正确性，调用python
clear classes
obj = py.importlib.import_module('RSA');
py.importlib.reload(obj);

key = double('Life_will_change');
tic
RSA = cell(py.RSA.generateRSA());
emsg = py.RSA.encrypt(key, RSA{1}, RSA{3});
c = cell(emsg);
res = zeros(1,128);
for i =1:128
    res(i) = c{i};
end
emsg = py.list(res);
demsg = py.RSA.decrypt(emsg, RSA{2}, RSA{3});
c = cell(demsg);
res = zeros(1,16);
for i =1:16
    res(i) = c{i};
end
res
char(double(res))
toc

