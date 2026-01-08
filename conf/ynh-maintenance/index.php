<?php
$app = '__APP__';
$user = $_SERVER['HTTP_YNH_USER'] ?? 'inconnu';
$dataDir = '__DATA_DIR__';
$metadata = [
    'package_version' => 'inconnue',
    'upstream_ref' => 'inconnu',
];
$metadataFile = $dataDir . '/config/maintenance.json';
if (file_exists($metadataFile)) {
    $json = json_decode(file_get_contents($metadataFile), true);
    if (is_array($json)) {
        $metadata = array_merge($metadata, $json);
    }
}
$statusFile = $dataDir . '/logs/upgrade.status';
$upgradeStatus = file_exists($statusFile) ? trim(file_get_contents($statusFile)) : 'aucune exécution';
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
            <div><span>Version app :</span> <?php echo htmlspecialchars($metadata['upstream_ref'], ENT_QUOTES); ?></div>
            <div><span>Statut upgrade :</span> <?php echo htmlspecialchars($upgradeStatus, ENT_QUOTES); ?></div>
        </div>
        <form method="post" action="upgrade.php">
            <button type="submit">Lancer upgrade</button>
        </form>
        <form method="get" action="logs.php">
            <button type="submit">Voir logs</button>
        </form>
    </main>
</body>
</html>
