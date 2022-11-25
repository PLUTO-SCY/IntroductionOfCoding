function out = txt2bitstream(message)

    int16 = double(message);
    bitstream = [];
    for i = 1:length(int16)
        bin = fliplr(decToBin(int16(i)));
        if length(bin)<16
            addzero = zeros(1,16-length(bin));
            bin = [addzero, bin];
        end
        bitstream = [bitstream, bin];
    end
    if mod(length(bitstream),64)~=0
        zerolen = ceil(length(bitstream)/64)*64-length(bitstream);
        addzero = zeros(1,zerolen);
        bitstream = [bitstream, addzero];
    end
    out = bitstream;
end

