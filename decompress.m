function decompress(originalImg, k, h)
	original = imread(originalImg);
	n=columns(original);
	m = n + (n-1)*k;
	D=zeros(m,m,3);
	%columns(D)
	%columns(original)
	%columns(D(1:k+1:end, 1:k+1:end,:))
	D(1:k+1:end, 1:k+1:end, :) = original;

	for i = 1:h:m-h
		for j = 1:h:m-h
			for w = 1:3
				D_ = D(:,:,w);
				A = bilinear(D_, h, i, j);
				%mudar a funcao p passar o quadrado e interpolar tudo que ta la
				pij=interpolaLinear(A,i,i+h,j,j+h);
			end
		end
	end

	imwrite(D,"descomprimida.png");
end
function A = bilinear(M, h, xi, yj)
	
	%VOLTA AQUI P VER O NEGOCIO
	%garantir q xi1 e tals ta dentro da matriz ainda
	
	xi1 = xi+h;
	yj1 = yj+h;

	F = [ M(xi,yj) M(xi,yj1) M(xi1,yj) M(xi1,yj1)];

	H = [1 0 0 0;
		 1 0 h 0;
		 1 h 0 0;
		 1 h h h*h];
	%solucao de F = Hx (x os coef a)

	A = F * inv(H);
endfunction


function pij = interpolaLinear(A,x,xi,y,yj)
	v = [1 x-xi y-yj (x-xi)*(y-yj)];
	pij = A * v';
endfunction

