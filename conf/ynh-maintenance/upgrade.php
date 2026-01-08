<?php
$app = '__APP__';
$command = sprintf('sudo /usr/local/bin/%s-ynh-upgrade %s', escapeshellarg($app), escapeshellarg($app));
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
