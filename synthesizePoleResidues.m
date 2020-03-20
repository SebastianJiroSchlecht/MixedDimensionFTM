function response = synthesizePoleResidues(impulseResponseLength, factor, residues, poles, direct, type)

%% for conjugate pole pairs
numberOfPoles = size(poles,2);
numberOfOutputs = size(residues,2);
numberOfInputs = size(residues,3);

%% alternative
t = (-1:impulseResponseLength-2)';
response = zeros( impulseResponseLength, numberOfOutputs, numberOfInputs );


switch type
    case 'fast'
        c = factor .* exp(1i * t .* angle(poles) );
        e = exp(  log(abs(poles)) .* t );
        ce = c.*e;
        
        for itIn = 1:numberOfInputs
            thisRes = residues(:,:,itIn);
            response(:,:,itIn) = real(ce * thisRes);
        end
    case 'lowMemory'
        for it = 1:numberOfPoles
            c = factor(it) .* exp(1i * t .* angle(poles(it)) );
            e = exp(  log(abs(poles(it))) .* t );
            ce = c.*e;
            
            for itIn = 1:numberOfInputs
                thisRes = residues(it,:,itIn);
                response(:,:,itIn) = response(:,:,itIn) + real(ce * thisRes);
            end
        end
end



response(1,:,:) = direct;


