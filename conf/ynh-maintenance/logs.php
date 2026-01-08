<?php
$dataDir = '__DATA_DIR__';
$logFile = $dataDir . '/logs/upgrade.log';
$logContent = '';
if (file_exists($logFile)) {
    $lines = file($logFile);
    $logContent = implode('', array_slice($lines, -200));
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Logs upgrade - Gaming Star</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <main class="panel">
        <h1>Logs upgrade</h1>
        <pre><?php echo htmlspecialchars($logContent, ENT_QUOTES); ?></pre>
        <a class="button" href="index.php">Retour</a>
    </main>
</body>
</html>
