<?php
$app = '__APP__';
$action = $_POST['action'] ?? '';
$allowed = ['start-upgrade', 'check-upstream', 'clear-lock'];
if (!in_array($action, $allowed, true)) {
    header('Location: index.php');
    exit;
}
$command = sprintf(
    'sudo /usr/local/sbin/%s-maintenance %s %s',
    escapeshellarg($app),
    escapeshellarg($action),
    escapeshellarg($app)
);
$descriptor = [
    0 => ['pipe', 'r'],
    1 => ['pipe', 'w'],
    2 => ['pipe', 'w'],
];
$process = proc_open($command, $descriptor, $pipes);
if (is_resource($process)) {
    foreach ($pipes as $pipe) {
        fclose($pipe);
    }
    proc_close($process);
}
header('Location: index.php');
exit;
