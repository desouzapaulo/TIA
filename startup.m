% Substitua 'caminho/pasta1', 'caminho/pasta2', etc., pelos caminhos reais das suas pastas
pastas = {'D:\Paulo-bolsista\Data-Analyzer\Analyzer', 'D:\Paulo-bolsista\Data-Analyzer\data', 'D:\Paulo-bolsista\Data-Analyzer\Data-Analyzer'};

% Loop para adicionar cada pasta ao caminho
for i = 1:length(pastas)
    addpath(genpath(pastas{i}));
end