a = imread('flower.png');
a = im2double(a);
% figure(1);
% imshow(a);
[h,w] = size(a);

%q1
%filtre de sobel 
%h1_x = [1,2,1]' filtre de lissage
%h2_x = [-1 0 1] filtre derivatif qui permet de detecter les contours
%h_sobel_dx = h1*h2 

%h1_y = [-1,0,1]'
%h2_y = [1,2,1]


%l'utilisation d'u filtre de lissage permet d'inserer du bruit sur les
%details non pertinants, afin de permettrer au filtre de contours d'etre
%plus efficace

h1_dx = [1,2,1]';
h2_dx = [-1 0 1];
h_sobel_dx = h1_dx*h2_dx;
Gx = imfilter(a,h_sobel_dx);

h1_y = [1,0,-1]';
h2_y = [1,2,1];
h_sobel_dy = h1_y * h2_y;
Gy = imfilter(a,h_sobel_dy);

G = sqrt(Gx.^2 + Gy.^2);


% figure(2);
% subplot(3,1,1);
% imshow(Gx,[]);
% colorbar;
% subplot(3,1,2);
% imshow(Gy,[]);
% colorbar;
% subplot(3,1,3);
% imshow(G,[]);
% colorbar;
%la norme est maximale au niveau des contours 


a_b = imnoise(a,'gaussian',0,0.01);
% figure(3);
% imshow(J);
% colorbar;

Gx_b = imfilter(a_b,h_sobel_dx);
Gy_b = imfilter(a_b,h_sobel_dy);
G_b =  sqrt(Gx_b.^2 + Gy_b.^2);

% figure(4);
% subplot(3,1,1);
% imshow(Gx_b,[]);
% colorbar;
% subplot(3,1,2);
% imshow(Gy_b,[]);
% colorbar;
% subplot(3,1,3);
% imshow(G_b,[]);
% colorbar;

precision = 10e-5;
Gx_b_n =  Gx_b./((G_b+precision));
Gy_b_n =  Gy_b./(G_b+precision);
vecteur_i = 1:1:h;
vecteur_j = 1:1:w;
[J,I] = meshgrid(vecteur_i,vecteur_j);
I1_d = round(I + 2*Gy_b_n);
J1_d = round(J + 2*Gx_b_n);
I1_g = round(I - 2*Gy_b_n);
J1_g = round(J - 2*Gx_b_n);

I1_d = I1_d(:,1)';
I1_d(1) = 1;
J1_d = J1_d(1,:);
I1_g = I1_g(:,1)';
J1_g = J1_g(1,:);

epsilon = 0.5;

for i=vecteur_i
    if I1_d(i)> 255
        I1_d(i) = 255;
    end
    if I1_g(i)> 255
        I1_g(i) = 255;
    end
    if J1_d(i)> 255
        J1_d(i) = 255;
    end
    if J1_d(i) < 1;
        J1_d(i) = 1; 
    end 
    if J1_g(i) < 1
        J1_g(i) = 1;
    end 
    if J1_g(i)> 255
        J1_g(i) = 255;
    end
end

G_b_c = zeros(h);
for i=vecteur_i
    for j=vecteur_j
        if abs(G_b(i,j) - G_b(I1_d(i),J1_d(j)))< epsilon & abs(G_b(i,j) - G_b(I1_g(i),J1_g(j)))< epsilon
            G_b_c(i,j) = G_b(i,j);
        else
            G_b_c(i,j) = 1;
        end
            
    end
end
%subplot(1,2,1);
%imshow(G_b,[]);
%subplot(1,2,2);
%imshow(G_b_c,[]);

%%Algo K means
%imshow(a);
K = 2;
centres = zeros(1,K);
moyenne = zeros(1,K);
labels = zeros(256,256);
for i = 1:1:K
    centres(1,i) = rand();
end


epsilon2 = 0.001;
on_continue = 1;

while(on_continue)
    for i=vecteur_i
        for j=vecteur_j
            [~,index]  = min(abs(centres-a(i,j)));
            labels(i,j) = index;
        end
    end
    
    for k = 1:1:K
        %matrice_moyenne = [];
        %for i1= vecteur_i
            %for j1 = vecteur_j
                %if labels(i1,j1) == k
                     %matrice_moyenne = [matrice_moyenne, a(i1,j1)];
                %end 
            %end 
        %end
        moyenne(k) = mean(a(labels == k)); 
    end
    if mean(centres - moyenne) < epsilon2
        on_continue = 0;
    end
    centres = moyenne;
        
end
imshow(labels/K)

