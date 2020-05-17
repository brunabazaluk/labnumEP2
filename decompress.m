function decompress(originalImg, k, h)
	original = imread(originalImg);
	n=columns(original);
	m = n + (n-1)*k;
	D=zeros(m,m,3);
	D(1:k+1:end, 1:k+1:end, :) = original;

	for w = 1:3
		D_ = D(:, :, w);
		printf("Interpolando cor %d ...\n", w);
		for i=1:h:m
			for j = 1:h:m
				A = bilinear(D_, h, i, j, m);
				%printf("(%d, %d) => %d \n", i, j, D_(i, j));
				for i_ = i:min(i+h-1, m)
					for j_ = j:min(j+h-1, m)
						pij = interpolaLinear(A, i_, i, j_, j);

						%if i == i_ && j == j_
						%	printf("- (%d, %d)=> %d (Esperado %d)\n", i_, j_, pij, D_(i_, j_));
						%end
						D(i_, j_, w) = uint8(pij);
					end
				end
				%printf("\n");
			end
		end
		%disp("-----------------")
	end
	printf("Salvando imagem..\n");
	D = uint8(D);

	imwrite(D,"descomprimida.png");
end
function A = bilinear(M, h, xi, yj, m)
	xi1 = min(xi+h-1, m);
	yj1 = min(yj+h-1, m);

	%printf("Ponto interpoladores: (x_i, y_i) = (%d, %d)\n", xi, yj)
	%printf("Ponto interpoladores + 1: (x_{i+1}, y_{i+1}) = (%d, %d)\n", xi1, yj1)
	%printf("Valores nas matrizes: %d %d %d %d\n", M(xi,yj), M(xi,yj1), M(xi1,yj), M(xi1,yj1) )

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
