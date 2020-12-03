clc; clear variables; close all;
a = imread('pieces.png');
a = im2double(a);
%% ex1

K = 2;
image_seuil = k_means(a,K);
figure(10);
imagesc(image_seuil);
[h,w] = size(a);
nombre_pixels = h*w;
[count,bitLocation] = imhist(a);



%histogramme cummule
count_norm = count / nombre_pixels;  
count_cummule = count_norm;
for i = 1:1:length(bitLocation)-1
    count_cummule(i+1) = count_cummule(i) + count_cummule(i+1);
end

  

figure(2);
bar(bitLocation,count_norm);
hold on;
plot(bitLocation,count_cummule);


b = a;%nouvelle image post-egalisation
%calcule de l'egalisation d'histogramme
for i=1:1:h
    for j=1:1:w
        b(i,j) = count_cummule(round(b(i,j)*255) + 1);% PAR 255 POUR PAS DEPASSER ET + 1 POUR INDICE 0
    end 
end
%affichage des deux images post et pre egalisation 
figure(3);
subplot(1,2,1)
imshow(b);
subplot(1,2,2)
imshow(a);
[count_egal,bitLocation_egal] = imhist(b);

%Calcul de l'histogramme cummule post-egalisation

count_egal_norm = count_egal / nombre_pixels;  
count_cummule_egal = count_egal_norm;
for i = 1:1:length(bitLocation_egal)-1
    count_cummule_egal(i+1) = count_cummule_egal(i) + count_cummule_egal(i+1);
end

%Affichage de l'histogramme post-egalisation
figure(4);
bar(bitLocation_egal,count_egal_norm);
hold on;
plot(bitLocation_egal, count_cummule_egal);


%segmentation 
image_egal_seuil = k_means(b,K);
figure(5);
imshow(b);

