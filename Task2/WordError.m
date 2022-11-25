function out = WordError(bitin,bitout)
    bitin = [bitin, zeros(1,32-mod(length(bitin),32))];
    bitout = [bitout, zeros(1,32-mod(length(bitout),32))];
    pointer = 1;
    sum = 0;
    while pointer<length(bitin)
        if any(xor(bitin(pointer:pointer+31),bitout(pointer:pointer+31)))
            sum = sum+1;
        end
        pointer = pointer+32;
    end
    out = sum/(length(bitin)/32);
end