<?php
$token = 'AgAAAAA9BPUAAAbBg7fnixszQk_rhxlZlwDrXug';
 
$archive = $argv[1];
$yd_file = '/backups/' . $archive;
 
$path = __DIR__;
 
$ch = curl_init('https://cloud-api.yandex.net/v1/disk/resources/download?path=' . urlencode($yd_file)); 
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: OAuth ' . $token)); 
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); 
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
curl_setopt($ch, CURLOPT_HEADER, false); 
$res = curl_exec($ch); 
curl_close($ch);
 
$res = json_decode($res, true); 
if (empty($res['error'])) {
	$file_name = $path . '/' . basename($yd_file);
	$file = @fopen($file_name, 'w');
 
	$ch = curl_init($res['href']);
	curl_setopt($ch, CURLOPT_FILE, $file);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: OAuth ' . $token));
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_exec($ch);
	curl_close($ch);
	fclose($file);
}
?>
