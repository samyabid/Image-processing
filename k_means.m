function image_seuil = k_means(image,K) 
    [h,w] = size(image);
    vecteur_i = 1:1:h;
    vecteur_j = 1:1:w;
    centres = zeros(1,K);
    moyenne = zeros(1,K);
    image_seuil = zeros(h,w);
    for i = 1:1:K
        centres(1,i) = rand();
    end


    epsilon2 = 0.1;
    on_continue = 1;

    while(on_continue)
        for i=vecteur_i
            for j=vecteur_j
                [~,index]  = min(abs(centres-image(i,j)));
                image_seuil(i,j) = index;
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
            moyenne(k) = mean(image(image_seuil == k)); 
        end
        if mean(centres - moyenne) < epsilon2
            on_continue = 0;
        end
        centres = moyenne;

    end

end
