<?php
require "../../vendor/autoload.php";

use Kreait\Firebase\JWT\CustomTokenGenerator;

$clientEmail = 'firebase-adminsdk-wggts@points-a1a14.iam.gserviceaccount.com';
$privateKey = 'nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDbAMjz3dOl2LBz\nqDCkeGQ5f/PJP+6kBPS+5uDYO5BGO9URbuXDhzQ1L343/CgFMH3tgiMiRieqdz7r\npp82vKeu3BiRSb08998A9yHLGrK7NeiAL8XLQxfKTk7vGOABzGnOKZgIzGRCykRA\nIKjqcBI2aT63m1N08Lk/DMeTom9RX1phj4jAAYQ8YV2rR+xC9Un7OkY+RMKUg7DH\nQCi9yaLYl+Mk02c6mb9wyCaeptw7OgRi8ZnQtNbVvN9flZsgO10ZoqF/JTm159Ff\nNg0QRhv3Bly/2KsNeiBzBRcn8mKCtRgyuaoPIsuD+x2ZAD+Uwa0yaUN4VZcHdprx\nCH67lRYtAgMBAAECgf9+qCA6sKxv2n6j8z31p+PdJGoEJMq0n356sLbKkIu1aB38\ndxhOQ9U07TR1uqaHBHZBnxAkezV1i53mVi/av10emSvVE8IzVdIGrq2x87CjXAoM\nw1taCA/k4mUZjTscsrhFdQGjMXWuR2jcH1yuAD8y41XiS+Rb5/kB4XBujh9E4RUu\ngNJeuLF9ZBQ+H5jArg3wsqm0X+6OIpJhRJlblXHHHYmn3zWUou5vCjqTlTiX6/FU\ncrdYuxlsoZ1eAcef8ke7OfRkkpMjQQF89H0R4/3AnKu+HuVfv0nz4ezuyBZ0oW3I\nDiZLWCJ0QJ2nuheDbHd6P6OPBrOdNnjVlyLXnlECgYEA/pOXC6Ovv+fUc6/7N3Xk\n2FJFMp+ifBuelkIdEHtGwkJT/2pBx8NzT9p3/kRKkpvjDQFDs6wzhiCZLn7qiM0k\n0FxYF+G8M/irTSGLuCT8jzTh1u4OBkgRP5Ol1A74jxmVZwsVev3+/lJrV+uN8Z2O\nD5Xd+cUYype3u09xr9CA9ekCgYEA3DpGGW1qWEgb7KHm30geg5uNiadoBONn6O1Z\n4qIQI68jKfXNUUIzGFbd8wfJSBGYtHkdWFQlerSlBCoKNHx7rFLw+eUeulpNdpDr\nyfkjBSmc7C7A/XGW/mbO/5k9/jpA1yeSoMYgqI8gmxcxOqBWIrq4CuwDACmT4cJV\ncUe4f6UCgYEAtsyd0jLIWUGLsUJ1Xj6eg6KXo6EzGHDwsC5rFlGe3pCoJihTcbDr\n1TQno4HAFoQvRkBZL+P/31j7BYMGwBKmU6NrckKaVKtDvg/PdvvACsjLPf0UPvhy\nwjcwBRR28LJLMIGp+/X0qwPdpnUzKIKc5p4TlW0svxSwTqTeGoPahjkCgYEAljU4\n8sbqLeShBzk2Wzy5c1J5q1X/YLYqfXjGQgn/sBcYiNoafD4G06cMI2NAKmO2IAIr\nvb9HAPaNRtXVuA7f252GtytLVheZljEqYcwH0tGbMoyBHVyIfGRq83L2EZxx9U4M\neJQqWk2lE6Mx9Ka/mVh5hxmKwmWZc/Y0iNs+P/ECgYEAvnVCozN0pOj/o65W95Ar\nBdN58pQ1tKiDdbHDnJT9GJeXp2DNbMS1xAqg9x4zSxVH74iBl5eOnSTViqLFTTY1\npidRzrM7VL3icji9uedhcDCbgsqS82vTKZAr8dThjYaNODzFhszj5wfDICJXu4tW\nN8Pn8QCQNnn53f2PbZVN5X4=';

$generator = CustomTokenGenerator::withClientEmailAndPrivateKey($clientEmail, $privateKey);
$token = $generator->createCustomToken('points123', ['first_claim' => 'first_value' /* ... */]);

echo  outputData($token);
?>