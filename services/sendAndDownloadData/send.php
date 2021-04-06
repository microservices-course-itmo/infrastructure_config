<?php
$token = ;
 
$archive = $argv[1];
$file = __DIR__ . '/' . $archive;

$path = '/backups/';
 
$ch = curl_init('https://cloud-api.yandex.net/v1/disk/resources/upload?path=' . urlencode($path . basename($file))); 
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: OAuth ' . $token)); 
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); 
curl_setopt($ch, CURLOPT_HEADER, false); 
$res = curl_exec($ch); 
curl_close($ch);
 
$res = json_decode($res, true); 
if (empty($res['error'])) {
	// Если ошибки нет, то отправляем файл на полученный URL.
	$fp = fopen($file, 'r');
 
 	$ch = curl_init($res['href']);
	curl_setopt($ch, CURLOPT_PUT, true);
	curl_setopt($ch, CURLOPT_UPLOAD, true);
	curl_setopt($ch, CURLOPT_INFILESIZE, filesize($file));
	curl_setopt($ch, CURLOPT_INFILE, $fp);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_exec($ch);
	$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
	curl_close($ch);
 
	if ($http_code == 201) {
		echo 'Файл успешно загружен.';
	}
} 
?>
