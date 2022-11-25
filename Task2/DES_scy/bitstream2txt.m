function out = bitstream2txt(bitstream)
    dec = [];
    zero = 0;
    for i = length(bitstream)/16:-1:length(bitstream)/16-4
        patch = bitstream(1,i*16-15:i*16);
        if sum(patch)==0
            zero = zero + 1;
        end
    end

    for i = 1:length(bitstream)/16-zero
        bin = bitstream(1, i*16-15:i*16);
        dec = [dec, bin2dec(int2str(bin))];
    end
    out = char(dec);
end

