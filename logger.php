<?php $date = date("c"); $ip = $_SERVER["REMOTE_ADDR"]; $coords = $_GET["coords"] ?? "N/A"; file_put_contents("coords.log", "$date | $ip | $coords\n", FILE_APPEND); ?>
