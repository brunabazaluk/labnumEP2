function zoo(m)
    img = zeros(m,m,3);
    k = 0;

    for y=1:m
        for x=1:m
            x_real = -2*pi + (x/m)*4*pi;
            y_real = -2*pi + (y/m)*4*pi;

            img(y, x, 1) = floor( (255/2) * (sin(x_real) + 1) );
            img(y, x, 2) = floor( (255/2) * ((sin(x_real) + sin(y_real))/2  + 1) );
            img(y, x, 3) = floor( (255/2) * (sin(x_real) + 1) );
        end
    end

    imwrite(uint8(img), "test.png", "Compression", "none");

end