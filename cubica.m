% Gerador de imagens test: https://png-pixel.com/
function cubica()
    img = imread("10x10.png");
    red = img(:, :, 1);
    green = img(:,:, 2);
    blue = img(:, :, 3);

    
    # lado h = 3
    h = 3;
    x_i = 1;
    y_j = 10;

    # mostrando quadrado com pixel inferiro esquerdo (1,10) de lado h
    disp(blue(x_i:x_i+h, y_j-h:y_j));

    # Constroi matriz de coefiecientes para a matriz vermelha
    A = constroi_matriz_de_coeficientes(h, red, x_i, y_j);
    
    % Valor do pixel aproximado.
    p_ij = interpola(8, 8, x_i, y_j, A);
    
end

function B = constroi_B(h)
    B = [ 1 0 0 0; 1 h h^2 h^3; 0 1 0 0; 0 1 2*h 3*h^2];
end

function A = constroi_matriz_de_coeficientes(h, imagem, x_i, y_j)
    % Calcular a matriz de derivadas,
    % obter B, B transposto e suas 
    % inversas.
    A = 2;
    disp(A);
end

function p_ij = interpola(x, y, x_i, y_j, A)
    xv = [1 (x - x_i) (x - x_i)^2 (x - x_i)^3];
    yv = [1 (y - y_j) (y - y_j)^2 (y - y_j)^3];

    p_ij = xv * A * yv';
end