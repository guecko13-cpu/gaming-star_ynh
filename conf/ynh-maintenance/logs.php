<?php
$dataDir = '__DATA_DIR__';
$maintenanceLog = $dataDir . '/logs/maintenance.log';
$updateLog = $dataDir . '/logs/update.log';

$maintenanceContent = '';
$updateContent = '';
if (file_exists($maintenanceLog)) {
    $lines = file($maintenanceLog);
    $maintenanceContent = implode('', array_slice($lines, -200));
}
if (file_exists($updateLog)) {
    $lines = file($updateLog);
    $updateContent = implode('', array_slice($lines, -200));
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Logs maintenance - Gaming Star</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <main class="panel">
        <h1>Logs maintenance</h1>
        <h2>maintenance.log</h2>
        <pre><?php echo htmlspecialchars($maintenanceContent, ENT_QUOTES); ?></pre>
        <h2>update.log</h2>
        <pre><?php echo htmlspecialchars($updateContent, ENT_QUOTES); ?></pre>
        <a class="button" href="index.php">Retour</a>
    </main>
</body>
</html>
