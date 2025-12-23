function [binary_output, probability_output] = team_run_model(data_record, classification_model, verbose)

signals = read_challenge_signals(data_record);
header  = fileread(strrep(data_record, '.mat', '.hea'));

features = get_features(data_record, header);

IDCF = compute_idcf(features);
IDCF = max(0, min(1, IDCF));   % segurança numérica

probability_output = IDCF;

if IDCF < 0.5
    binary_output = 'True';    % patológico / colapso
else
    binary_output = 'False';   % regime coerente
end

end
