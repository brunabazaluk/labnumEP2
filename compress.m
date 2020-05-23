function compress(originalImg, k)
    img = imread(originalImg);

    x = 1:k+1:rows(img);
    y = 1:k+1:columns(img);

    imagem_comprimida = img(x, y, :);

    imwrite(imagem_comprimida, "compressed.png")
end