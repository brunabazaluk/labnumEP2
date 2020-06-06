function decompress(originalImg, method, k, h)

	% Selecionamos o interpolador e a respectiva 
	% função que controi a matriz de coeficientes
	% usada para interpolar.
	[interpolation,construct] = metodo(method);
	original = imread(originalImg);

	% Tamanho da imagem comprimida
	n = columns(original);

	% Quantidade de canais de cores, em RGB = 3
	canais = 3;

	% Quando a imagem é preto e branco, por algum motivo
	% que não conseguimos descobrir, ele remover os 3 canais
	% do RGB e deixa somente um canal com valor maximo entre
	% 0 e 1. Então escalamos a imagem preto e branco do valor
	% 0 e 1 para 0 e 255.
	% Como é a mesma matriz para todos os canais, então somentes
	% copiamos ela nos 3 canais.
	if ( max(max(original)) == 1 )
		temp = original * 255;
		original = zeros(n,n,canais);
		original(:, :, 1) = temp(:, :);
		original(:, :, 2) = temp(:, :);
		original(:, :, 3) = temp(:, :);
	end

	% Tamanho da imagem final, a descomprimida
	m = n + (n-1)*k;
	
	% Criando a imagem descompremida e colocando 
	% os valores dos pixels que ja sabemos nos lugares
	% certos.
	D = zeros(m,m,canais);
	D(1:k+1:end, 1:k+1:end, :) = original;

	% Iniciando a interpolação de fato, fazemos isso primeiro
	% para cada canal.
	for w = 1:canais
		D_ = D(:, :, w);
		printf("Interpolando cor %d ...\n", w);

		% Interpolamos usando como referencia o canto superior 
		% esquerdo de cada quadro de lado h.
		for i=1:h-1:m
			for j = 1:h-1:m
				A = construct(D_, h, i, j, m);

				% Interpolando todos os pixels que estão dentro
				% do quadrado interpolado. 
				for i_ = i:min(i+h-1, m)
					for j_ = j:min(j+h-1, m)
						pij = interpolation(A, i_, i, j_, j);
						D(i_, j_, w) = pij;
					end
				end
			end
		end
	end
	printf("Salvando imagem..\n");

	imwrite(uint8(D),"decompressed.png", "Quality", 100);
end

% Função helpe que retorna o interpolador e a
% matriz de interpolação dependendo do método.
function [inter,A] = metodo(method)

	if(method == 1)
		inter = @interpolaLinear;
		A = @bilinear;

	else
		inter = @interpolaCubica;
		A = @bicubica;
	end
endfunction

% As funções daqui para baixo basicamente foram
% traduzidas do que estava escrito no EP para 
% Octave.

%---------------- Bilinear ------------------%
function A = bilinear(M, h, xi, yj, m)
	xi1 = min(xi+h-1, m);
	yj1 = min(yj+h-1, m);

	F = [ M(xi,yj) M(xi,yj1) M(xi1,yj) M(xi1,yj1)];

	H = [1 0 0 0;
		 1 0 h 0;
		 1 h 0 0;
		 1 h h h*h];
	A = inv(H) * F';
endfunction

function pij = interpolaLinear(A,x,xi,y,yj)
	v = [1; x-xi; y-yj; (x-xi)*(y-yj)];
	pij = A' * v;
endfunction

%---------------- Fim Bilinear ------------------%

%------------------ Bicubica --------------------%
function B = constroi_B(h)
    B = [ 1 0 0 0; 1 h h^2 h^3; 0 1 0 0; 0 1 2*h 3*h^2];
end

function A = bicubica(M, h, xi, yj, m)

	xi1 = min(xi+h-1, m);
	yj1 = min(yj+h-1, m);
	xi2 = min(xi1+h-1,m);
	yj2 = min(yj1+h-1,m);

	F = [ M(xi,yj) M(xi,yj1) del_fy(xi,yj,xi1,yj1,h,M,m) del_fy(xi,yj1,xi1,yj2,h,M,m);
		  M(xi1,yj) M(xi1,yj1) del_fy(xi1,yj,xi2,yj1,h,M,m) del_fy(xi1,yj1,xi2,yj2,h,M,m);
		  del_fx(xi,yj,xi1,yj1,h,M,m) del_fx(xi,yj1,xi1,yj2,h,M,m) deldel_fxy(xi,yj,xi1,yj1,h,M,m) deldel_fxy(xi,yj1,xi1,yj2,h,M,m);
		  del_fx(xi1,yj,xi2,yj1,h,M,m) del_fx(xi1,yj1,xi2,yj2,h,M,m) deldel_fxy(xi1,yj,xi2,yj1,h,M,m) deldel_fxy(xi1,yj1,xi2,yj2,h,M,m);
		];

	B = constroi_B(h);
	A = inv(B) * F * inv(B');

end

function [del] = del_fx(xi,yj,xi1,yj1,h,M,m)
	xi_1 = max(xi-h+1,1);
	yj_1 = max(yj-h+1,1);

	if(xi==1)
		del = ( M(2,yj) - M(1,yj) ) / (h);

	elseif(xi==m)
		del = ( M(m,yj) - M(m-1,yj) ) / (h);

	else
		del = ( M(xi1,yj) - M(xi_1,yj) ) / (2*h);
	end
end
function [del] = del_fy(xi,yj,xi1,yj1,h,M,m)
	xi_1 = max(xi-h+1,1);
	yj_1 = max(yj-h+1,1);

	if(yj==1)
		del = ( M(xi,2) - M(xi,1) ) / (h);

	elseif(yj==m)
		del = ( M(xi,m) - M(xi,m-1) ) / (h);

	else
		del = ( M(xi,yj1) - M(xi, yj_1) ) / (2*h);
	end
end

function [del] = deldel_fxy(xi,yj,xi1,yj1,h,M,m)
	xi_1 = max(xi-h+1,1);
	yj_1 = max(yj-h+1,1);
	yj1 = min(yj+h-1, m);

	a = del_fy(xi1,yj,0,yj1,h,M,m);
	b = del_fy(xi_1,yj,0,yj1,h,M,m);

	del = ( a - b ) / ( 2*h );

end

function p_ij = interpolaCubica(A, x, xi, y, yj)
    xv = [1 (x - xi) (x - xi)^2 (x - xi)^3];
    yv = [1 (y - yj) (y - yj)^2 (y - yj)^3];

    p_ij = xv * A * yv';
end

%------------------ Fim Bicubica --------------------%