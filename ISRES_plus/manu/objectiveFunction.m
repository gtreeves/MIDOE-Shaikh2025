function [error,phi] = objectiveFunction(k)

% load('sample.mat')
%
% Reset k so it can be used in the model
%
k(:,1:4)  = 10.^(k(:,1:4));
k(:,9:12) = 10.^k(:,9:12);

nsets = size(k,1);
error = zeros(nsets,1);
phi   = zeros(nsets,1);      %no penalty

exp = load('Manu/Mats/ExpDataManu.mat');

for i=1:nsets
    p = k(i,:);
    [NC13, NC14] = manu_model(p);

    eNC13 = (exp.NC13 - NC13(:,1:3)).^2;
    eNC13(isnan(eNC13)) = 0;
    eNC14 = (exp.NC14-NC14).^2;
    eNC14(isnan(eNC14)) = 0;

    error(i) = (sum(eNC13(:))+sum(eNC14(:)))/(numel(eNC13)+numel(eNC14));
end

end