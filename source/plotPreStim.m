function plotPreStim(Model,K,K_dirFact,sodiumFunction,h_i,j_i)

close all;

if(isempty(K_dirFact))
    [N,D]=rat(K);
    K_dirFact = max(D);
end
digits = floor(log10(max(K*K_dirFact))+1);

for i=1:length(K)
    K_str = ['K_' num2str(round(K(i)*K_dirFact),['%0' num2str(digits) 'd'])];

    if(~isempty(dir([Model '/' K_str '/base-preStim/post/preStim_00000151.var'])))
       % a=load([Model '/' K_str '/base-preStim/post/preStim_00000151.var']);
       % b=load([Model '/' K_str '/base-preStim/post/preStim_00000176.var']);
        c=load([Model '/' K_str '/base-preStim/post/preStim_00000201.var']);
       % d=load([Model '/' K_str '/base-preStim/post/preStim_00000226.var']);
       % e=load([Model '/' K_str '/base-preStim/post/preStim_00000251.var']);

       % val_a=sodiumFunction(a(:,2));
       % val_b=sodiumFunction(b(:,2));
        val_c=sodiumFunction(c(:,2));
       % val_d=sodiumFunction(d(:,2));
       % val_e=sodiumFunction(e(:,2));

        real_c = c(:,h_i).*c(:,j_i);

        f=figure;
        plot(abs(val_c-real_c)./real_c*100)
        saveas(f,[Model '/' K_str '-preStim.pdf'])
        close(f);
    end
end
