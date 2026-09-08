<?php
/**
 * Telemetria e Ranking Remoto de Aplicativos Mais Populares - unbk.com.br
 * 
 * Funcionalidades:
 * - GET: Retorna o ranking JSON dos 25 aplicativos mais instalados por todos os usuários.
 * - POST: Registra os aplicativos selecionados durante o clique de "Instalar Selecionados"
 *         no script setup.ps1 de forma 100% anônima, atualizando o ranking coletivo.
 */

// Headers CORS para permitir consumo pelo PowerShell e Web
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Preflight CORS para navegadores
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$votesFile = __DIR__ . '/votes.json';
$popularFile = __DIR__ . '/popular.json';

// -----------------------------------------------------------------------------
// 1. REQUISIÇÃO GET: Retornar os Mais Populares
// -----------------------------------------------------------------------------
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (file_exists($popularFile)) {
        echo file_get_contents($popularFile);
    } else {
        // Fallback caso popular.json ainda não exista
        $defaultPopular = [
            "WPFInstallchrome", "WPFInstallbrave", "WPFInstall7zip", "WPFInstallnanazip", "WPFInstallwinrar",
            "WPFInstalldiscord", "WPFInstallwhatsapp", "WPFInstallspotify", "WPFInstallvlc",
            "WPFInstallsteam", "WPFInstallepicgames", "WPFInstallHydraLauncher", "WPFInstallNvidiaApp",
            "WPFInstallExitLag", "WPFInstallmsiafterburner", "WPFInstallnotepadplus", "WPFInstallanydesk",
            "WPFInstallpdf24creator", "WPFInstallvc2015_64", "WPFInstallvc2015_32",
            "WPFInstallKaspersky", "WPFInstallMalwarebytes", "WPFInstallAdwCleaner", "WPFInstallBitdefender"
        ];
        echo json_encode($defaultPopular, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    }
    exit;
}

// -----------------------------------------------------------------------------
// 2. REQUISIÇÃO POST: Registrar Votos dos Apps Instalados
// -----------------------------------------------------------------------------
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $rawInput = file_get_contents('php://input');
    $payload = json_decode($rawInput, true);

    if (!isset($payload['apps']) || !is_array($payload['apps'])) {
        http_response_code(400);
        echo json_encode(['status' => 'error', 'message' => 'Parâmetro "apps" é obrigatório e deve ser uma lista.']);
        exit;
    }

    // Carrega contagem de votos existente
    $votes = [];
    if (file_exists($votesFile)) {
        $content = file_get_contents($votesFile);
        $votes = json_decode($content, true) ?: [];
    }

    $validCount = 0;
    foreach ($payload['apps'] as $appKey) {
        // Validação estrita para aceitar apenas identificadores alfanuméricos válidos
        if (is_string($appKey) && preg_match('/^WPFInstall[a-zA-Z0-9_\-\.]{2,50}$/', $appKey)) {
            $votes[$appKey] = ($votes[$appKey] ?? 0) + 1;
            $validCount++;
        }
    }

    if ($validCount > 0) {
        // Salva histórico cumulativo com lock exclusivo
        file_put_contents($votesFile, json_encode($votes, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE), LOCK_EX);

        // Ordena por maior número de instalações
        arsort($votes);

        // Extrai o Top 25 aplicativos
        $topKeys = array_slice(array_keys($votes), 0, 25);

        // Atualiza o arquivo popular.json de acesso direto ultrarrápido
        file_put_contents($popularFile, json_encode($topKeys, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE), LOCK_EX);
    }

    echo json_encode([
        'status' => 'success',
        'votes_recorded' => $validCount,
        'total_unique_apps' => count($votes),
        'timestamp' => time()
    ]);
    exit;
}
