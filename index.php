<?php
$plat = "swf";
if (isset($_GET["js"])) {
  $plat = "js";
}
?><!DOCTYPE html><html><head>
  <title>LD40 game</title>
  <meta charset="utf-8">
  <style>
*{margin:0;padding:0;}
body{background:#fff;color:#333;font-family:sans-serif;font-size:13px;}
header{margin:20px auto 5px;width:400px;}
section{background:#eee;width:400px;margin:0 auto;padding:5px;}
canvas,embed,object{display:block;}
section h2{font-size:15px;font-weight:normal;letter-spacing:1px;}
section h2,section p{padding:5px 0;}
footer{font-size:11px;margin:5px auto 20px;text-align:right;width:400px;}
  </style><?php
if ($plat == "js") {
  echo '
  <script type="text/javascript" src="game.js"></script>';
}
?>
</head><body>
  <header><h1>LD40 game</h1></header><section>
<?php
if ($plat == "js") {
  ?><canvas id="surf" width="400" height="300"></canvas><?php
} else {
  ?><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,28,0" width="400" height="300"><param name="movie" value="game.swf" /><embed src="game.swf" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="400" height="300"></embed></object><?php
}
?>
  <h2>Controls</h2>
  <p>TBA</p>
  <h2>Notes</h2>
  <p>TBA</p>
  </section><footer>&copy; 2017 Aurel Bílý, Ján Špidus<br>for Ludum Dare 40</footer>
</body></html>
