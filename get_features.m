function features=get_features(file,header)

signals = read_challenge_signals(file, header);
ecg = signals(:,2);
ecg = ecg(~isnan(ecg));

% Segurança
if length(ecg) < 100
    features = nan(1,6);
    return
end

% 1. Variabilidade
f_var = std(ecg);

% 2. Diferença sucessiva (instabilidade)
f_diff = mean(abs(diff(ecg)));

% 3. Entropia espectral (caos vs coerência)
[pxx,~] = pwelch(ecg);
pxx = pxx / sum(pxx);
f_entropy = -nansum(pxx .* log(pxx + eps));

% 4. Kurtosis (picos patológicos)
f_kurt = kurtosis(ecg);

% 5–6. Demografia
f_age = get_age(header);
f_sex = get_sex(header);

% Vetor final de features (IDCF implícito)
features = [
    f_var,...
    f_diff,...
    f_entropy,...
    f_kurt,...
    f_age,...
    f_sex
];
