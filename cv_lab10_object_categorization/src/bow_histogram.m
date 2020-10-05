function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
 n = size(vCenters,1);
  histo = zeros(n,1);
  feature_size = size(vFeatures,1);
  
  for i=1:feature_size
      %look for closest
      [~,matchIdx] = min(sum((vCenters-repmat(vFeatures(i,:),[n,1])).^2,2));
      histo(matchIdx) = histo(matchIdx)+1;
  end
 
end
