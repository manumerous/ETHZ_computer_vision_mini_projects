function C = chi2_cost(s1,s2)
C = zeros(size(s1,1), size(s2,1)) ;
if(size(s1,2) ~= size(s2,2))
    error ('not matching sizes')
end

%cost matrix calcultation
for i = 1:size(s1,1)
    for j = 1:size(s2,1)
        for k = 1:size(s1,2)
            C(i,j) = C(i,j) + 0.5 * ((s1(i,k)...
            -s2(j,k))^2 /(s1(i,k)+s2(j,k)+0.0001)) ;
        end
    end
end

end