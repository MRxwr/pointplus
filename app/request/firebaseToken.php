<?php
require "../../vendor/autoload.php";

use Kreait\Firebase\Factory;

$factory = (new Factory)->withServiceAccount('/path/to/firebase_credentials.json');

$token = $factory->createAuth();

echo outputData($token);
?>