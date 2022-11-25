function out = test_decoder(key, secretall)

    decoder_message = [];
    for i = 1:length(secretall)/64
        secret = secretall(i*64-63:i*64);
        decoder_message = [decoder_message, DES(secret,key,"decode")];
    end
    out = decoder_message;

end

