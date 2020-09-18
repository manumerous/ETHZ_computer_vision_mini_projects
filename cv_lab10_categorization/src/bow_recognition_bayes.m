function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

feature_size = size(vBoWPos,2);
pHcar =0;
pHnotCar = 0;

for i=1:feature_size
    if(sigmaPos(i)<0.5)
        sigmaPos(i) = 0.5;
    end
    
    %calculate logarithm
    p_pos = log(normpdf(histogram(i),muPos(i),sigmaPos(i)));
    %check whether is number
    if ~isnan(p_pos)
        pHcar = pHcar + p_pos;
    end
    
    %same for negative
    
    if(sigmaNeg(i) < 0.5)
        sigmaNeg(i) = 0.5;
    end
    
    p_neg = log(normpdf(histogram(i), muNeg(i),sigmaNeg(i)));
    %check whether is number
    if ~isnan(p_neg)
        pHnotCar = pHnotCar + p_neg;
    end
end
%take exp again
pHCar = exp(pHcar);
pHnotCar = exp(pHnotCar);

pCarH = 0.5*pHCar;
pnotCarH = 0.5*pHnotCar;

label = 1;
if pnotCarH > pCarH
    label = 0;
end
end