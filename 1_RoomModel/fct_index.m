function index = fct_index(ftm)

index = zeros(ftm.Mux*ftm.Muy,2);

index(:,2) = repmat(1:ftm.Muy,1,ftm.Mux);
index(:,1) = repelem(1:length(ftm.mux), ftm.Muy);
end