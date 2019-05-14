function [ Strain, Force, Stress, cumulativeBF] = FibreBwbModel(FibreE, nFibres, k , gam, FibreDiam, DistType)
% This function runs a virtual experiment in whic a fibre bundle with
% nFibres parallel fibres are pulled in a strain controlled manner. The
% arguments are:
%     FibreE:    Elastic Modulus of the fibre
%     nFibre:    Number of fibres in the bundle
%     k and gam: Shape and scale Weibull factors respectively
%     FibreDiam: Fibre diameter
%     DistType:  either 'wbl' for Weibull distribution or 'norm' for normal
%     distribution
% The outputs are:
% A Matrix where the columns contain the Strain, Force, Stress, and
% cumulative number of broken fibres for each stran step.
% 
% by: Gustavo Quino: me@gquino.com


    FibreArea = pi/4*(FibreDiam)^2;
    if strcmp(DistType , 'norm')
        Fibre.Strength  = random (DistType,TS_mean,TS_stdv,1, nFibres);
    elseif strcmp(DistType , 'wbl')
        % gam = TS_mean/gamma(1+1/k);
        Fibre.Strength  = random ('wbl', gam ,k ,1 ,nFibres);
    end


% Applying the strain 

    Strain_0 = 0; %Initial strain
    
    Strain   = Strain_0:0.00001:0.08;
    nSteps   = length(Strain);
    Force    = zeros(1,nSteps);
    nBFibres = zeros(1,nSteps);
    Stress   = zeros(1,nSteps);
    for step = 1:nSteps
        Force  (step) = sum(FibreE * FibreArea * Strain(step));
        Stress (step) = Force (step) / (FibreArea * nFibres);
        % Checking failure criterion in every single fibre
        for fibre = 1:nFibres
            if Fibre.Strength(fibre) < FibreE(fibre) * Strain(step) 
                FibreE(fibre) = 0;
                Fibre.Strength(fibre) = 0;
                nBFibres(step) = nBFibres(step) + 1;
            end
        end
    end
    cumulativeBF = cumsum(nBFibres);
end
