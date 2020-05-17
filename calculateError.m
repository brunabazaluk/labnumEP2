function calculateError(originalImg, decompressedImg)
    imgOriginal = cast(imread(originalImg), "double");
    imgDecompresse = cast(imread(decompressedImg), "double");

    erroTotal = 0;

    for i=1:3
        mcor_original = imgOriginal(:, :, i);
        mcor_decompress = imgDecompresse(:, :, i);

        erroTotal = erroTotal + (norm(mcor_original)-norm(mcor_decompress))/norm(mcor_original);
    end

    erro = erroTotal / 3
end