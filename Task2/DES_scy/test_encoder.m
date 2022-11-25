function out = test_encoder(key, bitstream)
    if mod(length(bitstream),64)~=0
        zerolen = ceil(length(bitstream)/64)*64-length(bitstream);
        addzero = zeros(1,zerolen);
        bitstream = [bitstream, addzero];
    end    
    message = reshape(bitstream,64,[]); % 64等长裁剪
    message = message';  
    secretall = [];
    
    for i = 1:size(message,1)
        secret = DES(message(i,:),key,"encode");
        secretall = [secretall,secret];
    end
    out = secretall;

end

