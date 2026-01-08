<?php
$app = '__APP__';
$user = $_SERVER['HTTP_YNH_USER'] ?? 'inconnu';
$dataDir = '__DATA_DIR__';

$metadata = [
    'package_version' => 'inconnue',
    'upstream_repo' => 'inconnu',
    'upstream_ref' => 'inconnu',
];
$metadataFile = $dataDir . '/config/maintenance.json';
if (file_exists($metadataFile)) {
    $json = json_decode(file_get_contents($metadataFile), true);
    if (is_array($json)) {
        $metadata = array_merge($metadata, $json);
    }
}

$status = [
    'status' => 'unknown',
    'message' => 'Aucun statut disponible',
];
$statusFile = $dataDir . '/logs/maintenance.status.json';
if (file_exists($statusFile)) {
    $json = json_decode(file_get_contents($statusFile), true);
    if (is_array($json)) {
        $status = array_merge($status, $json);
    }
}

$health = file_exists('__INSTALL_DIR__/index.php') ? 'OK' : 'Fichier index.php manquant';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Maintenance - Gaming Star</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <main class="panel">
        <h1>Maintenance Gaming Star</h1>
        <p>Utilisateur YunoHost : <strong><?php echo htmlspecialchars($user, ENT_QUOTES); ?></strong></p>
        <div class="meta">
            <div><span>Version package :</span> <?php echo htmlspecialchars($metadata['package_version'], ENT_QUOTES); ?></div>
            <div><span>Repo upstream :</span> <?php echo htmlspecialchars($metadata['upstream_repo'], ENT_QUOTES); ?></div>
            <div><span>Ref upstream :</span> <?php echo htmlspecialchars($metadata['upstream_ref'], ENT_QUOTES); ?></div>
            <div><span>Statut :</span> <?php echo htmlspecialchars($status['status'], ENT_QUOTES); ?></div>
            <div><span>Message :</span> <?php echo htmlspecialchars($status['message'], ENT_QUOTES); ?></div>
            <div><span>Dernier upgrade :</span> <?php echo htmlspecialchars($status['last_upgrade'] ?? 'n/a', ENT_QUOTES); ?></div>
            <div><span>Dernier check :</span> <?php echo htmlspecialchars($status['last_check'] ?? 'n/a', ENT_QUOTES); ?></div>
            <div><span>Healthcheck :</span> <?php echo htmlspecialchars($health, ENT_QUOTES); ?></div>
        </div>
        <form method="post" action="action.php">
            <input type="hidden" name="action" value="start-upgrade">
            <button type="submit">Lancer upgrade</button>
        </form>
        <form method="post" action="action.php">
            <input type="hidden" name="action" value="check-upstream">
            <button type="submit">Vérifier upstream</button>
        </form>
        <form method="post" action="action.php">
            <input type="hidden" name="action" value="clear-lock">
            <button type="submit">Débloquer</button>
        </form>
        <form method="get" action="logs.php">
            <button type="submit">Voir logs</button>
        </form>
    </main>
</body>
</html>
