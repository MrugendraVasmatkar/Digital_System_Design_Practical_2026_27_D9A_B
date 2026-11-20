param([int]$N = 5, [string]$OutFile)
$ErrorActionPreference = "Stop"
$sb = New-Object System.Text.StringBuilder
$W = New-Object System.Collections.ArrayList   # wires
$P = New-Object System.Collections.ArrayList   # ports
function R10($v) { [int]([math]::Round($v / 10.0, [MidpointRounding]::AwayFromZero)) * 10 }
function E($s) { [void]$sb.AppendLine("    " + $s) }
function Esc($s) { [System.Security.SecurityElement]::Escape($s) }
function Port($x, $y, $t) { [void]$P.Add([pscustomobject]@{X = $x; Y = $y; T = $t }) }
function Wire($x1, $y1, $x2, $y2) {
  if ($x1 -ne $x2 -and $y1 -ne $y2) { throw "diagonal $x1,$y1 -> $x2,$y2" }
  if ($x1 -eq $x2 -and $y1 -eq $y2) { return }
  [void]$W.Add([pscustomobject]@{X1 = $x1; Y1 = $y1; X2 = $x2; Y2 = $y2 })
  E "<wire from=""($x1,$y1)"" to=""($x2,$y2)""/>"
}
function Path($pts) { for ($i = 0; $i -lt $pts.Count - 1; $i++) { Wire $pts[$i][0] $pts[$i][1] $pts[$i + 1][0] $pts[$i + 1][1] } }
function Txt($x, $y, $t, $f = "SansSerif plain 12") { E "<comp lib=""8"" loc=""($x,$y)"" name=""Text""><a name=""text"" val=""$(Esc $t)""/><a name=""font"" val=""$f""/></comp>" }
function InPin($x, $y, $l, $w = 1) { $a = if ($w -gt 1) { "<a name=""width"" val=""$w""/>" } else { "" }; E "<comp lib=""0"" loc=""($x,$y)"" name=""Pin""><a name=""label"" val=""$l""/>$a</comp>"; Port $x $y "in:$l" }
function OutPin($x, $y, $l, $w = 1) { $a = if ($w -gt 1) { "<a name=""width"" val=""$w""/>" } else { "" }; E "<comp lib=""0"" loc=""($x,$y)"" name=""Pin""><a name=""facing"" val=""west""/><a name=""output"" val=""true""/><a name=""label"" val=""$l""/>$a</comp>"; Port $x $y "out:$l" }
function Gate($type, $x, $y, $w = 1, $neg = @()) {
  $sz = if ($type -eq "NOT Gate") { 20 } else { 30 }
  $a = "<a name=""size"" val=""$sz""/>"
  if ($type -ne "NOT Gate") { $a += "<a name=""inputs"" val=""2""/>" }
  if ($w -gt 1) { $a += "<a name=""width"" val=""$w""/>" }
  foreach ($n in $neg) { $a += "<a name=""negate$($n-1)"" val=""true""/>" }
  E ("<comp lib=""1"" loc=""($x,$y)"" name=""$type"">$a</comp>")
  Port $x $y "$type.out"
  if ($type -eq "NOT Gate") { Port ($x - 20) $y "$type.in" } else { Port ($x - 30) ($y - 10) "$type.in1"; Port ($x - 30) ($y + 10) "$type.in2" }
}
function Reg($x, $y, $w, $falling = $false) {
  $a = "<a name=""width"" val=""$w""/>"; if ($falling) { $a += "<a name=""trigger"" val=""falling""/>" }
  E "<comp lib=""4"" loc=""($x,$y)"" name=""Register"">$a</comp>"
  Port $x ($y + 30) "reg.D"; Port $x ($y + 50) "reg.EN"; Port $x ($y + 70) "reg.CK"; Port ($x + 30) ($y + 90) "reg.R"; Port ($x + 60) ($y + 30) "reg.Q"
}
# splitter: returns array of fan port points (top->bottom, fan index 0..n-1); bus at (x,y)
function Split($x, $y, $facing, $n, $mapTopMsb = $true, $bits = $null) {
  $a = "<a name=""fanout"" val=""$n""/><a name=""incoming"" val=""$n""/>"
  if ($facing -eq "west") { $a = "<a name=""facing"" val=""west""/>" + $a }
  if ($mapTopMsb) { for ($b = 0; $b -lt $n; $b++) { $a += "<a name=""bit$b"" val=""$($n - 1 - $b)""/>" } }
  E "<comp lib=""0"" loc=""($x,$y)"" name=""Splitter"">$a</comp>"
  Port $x $y "split.bus"
  $pts = @()
  for ($k = 0; $k -lt $n; $k++) {
    if ($facing -eq "east") { $pts += , @(($x + 20), ($y - 10 * ($n - $k))) } else { $pts += , @(($x - 20), ($y + 10 + 10 * $k)) }
    Port $pts[$k][0] $pts[$k][1] "split.fan"
  }
  return , $pts
}
function Led($x, $y, $l, $c) { E "<comp lib=""5"" loc=""($x,$y)"" name=""LED""><a name=""color"" val=""$c""/><a name=""label"" val=""$l""/></comp>"; Port $x $y "led" }
# jog route: cluster points (10 spacing, at x=xc) to spread points; generic orthogonal fan with ranked jogs
function Jog($cl, $sp) {
  $n = $cl.Count; $dys = @(); for ($k = 0; $k -lt $n; $k++) { $dys += ($sp[$k][1] - $cl[$k][1]) }
  $sign = if ($sp[0][0] -gt $cl[0][0]) { 1 } else { -1 }
  $up = @(); $dn = @(); for ($k = 0; $k -lt $n; $k++) { if ($dys[$k] -lt 0) { $up += $k } elseif ($dys[$k] -gt 0) { $dn += $k } }
  $ranks = @{}
  $r = 0; foreach ($k in ($up | Sort-Object { [math]::Abs($dys[$_]) } -Descending)) { $ranks[$k] = $r; $r++ }
  $r = 0; foreach ($k in ($dn | Sort-Object { [math]::Abs($dys[$_]) } -Descending)) { $ranks[$k] = $r; $r++ }
  for ($k = 0; $k -lt $n; $k++) {
    if ($dys[$k] -eq 0) { Wire $cl[$k][0] $cl[$k][1] $sp[$k][0] $sp[$k][1] }
    else { $xj = $cl[$k][0] + $sign * 10 * ($ranks[$k] + 1); Path @(@($cl[$k][0], $cl[$k][1]), @($xj, $cl[$k][1]), @($xj, $sp[$k][1]), @($sp[$k][0], $sp[$k][1])) }
  }
}
# rail: vertical wire at x from ytop through sorted tap ys
function Rail($x, $ytop, $taps) { $ys = @($ytop) + ($taps | Sort-Object); for ($i = 0; $i -lt $ys.Count - 1; $i++) { Wire $x $ys[$i] $x $ys[$i + 1] } }

# ---------- layout ----------
$yb = 160 + 40 * ($N - 1)            # bottom pin y
# Section titles
Txt 200 70 "1. INPUT SWITCHES" "SansSerif bold 16"
Txt 560 70 "2. INPUT REGISTERS" "SansSerif bold 16"
Txt 960 70 "3. XOR COMPARE (D = X xor P)" "SansSerif bold 16"
Txt 1200 70 "4. ONE-BIT CHANGE DETECTOR" "SansSerif bold 16"
# S1 pins
$pins = @(); for ($i = $N - 1; $i -ge 0; $i--) { $y = 160 + 40 * ($N - 1 - $i); InPin 100 $y "X$i"; $pins += , @(100, $y) }
# combiner splitter west-facing, bus at (300, SYb)
$centerPins = (160 + $yb) / 2
$SYb = R10 ($centerPins - 10 - 5 * ($N - 1) / 1.0 + 5 * ($N - 1) - 10 * ($N) / 2 + 5)  # placeholder, fixed below
$SYb = (R10 $centerPins) - 10 - 10 * [math]::Floor($N / 2)
$fi = Split 300 $SYb "west" $N
Jog $fi $pins
$busY = $SYb
# CUR / PREV registers
$RY = $busY - 30
Reg 380 $RY $N
Wire 300 $busY 380 $busY
Txt 410 ($RY + 5) "CURRENT INPUT REGISTER" "SansSerif bold 12"
Reg 560 $RY $N
Txt 590 ($RY + 5) "PREVIOUS INPUT REGISTER" "SansSerif bold 12"
$qy = $RY + 30
Wire 440 $qy 470 $qy; Wire 470 $qy 500 $qy; Wire 500 $qy 560 $qy
# monitor CUR up
Wire 470 $qy 470 ($qy - 100); OutPin 470 ($qy - 100) "CUR" $N
# XOR (bus)
$xgx = 760; $xgy = $qy - 50
Gate "XOR Gate" $xgx $xgy $N
Path @(@(500, $qy), @(500, ($xgy - 10)), @(($xgx - 30), ($xgy - 10)))
Wire 620 $qy 650 $qy; Wire 650 $qy 650 ($xgy + 10); Wire 650 ($xgy + 10) ($xgx - 30) ($xgy + 10)
Wire 650 $qy 650 ($qy + 120); OutPin 650 ($qy + 120) "PREV" $N
# D splitter east
$dsx = 820
Wire $xgx $xgy 790 $xgy; Wire 790 $xgy $dsx $xgy
$ds = Split $dsx $xgy "east" $N
OutPin 790 ($xgy - 120) "D" $N
Wire 790 $xgy 790 ($xgy - 120)
# rails
$RX = 900
$railX = @(); for ($j = 0; $j -lt $N; $j++) { $railX += ($RX + 20 * ($N - 1 - $j)) }
# j=0 top = D(N-1). rail index by bit b = N-1-j
$tapsByRail = @{}; for ($j = 0; $j -lt $N; $j++) { $tapsByRail[$j] = New-Object System.Collections.ArrayList }
function RailIdx($bit) { return ($N - 1 - $bit) }
function Tap($bit, $y, $xTo) { $j = RailIdx $bit; [void]$tapsByRail[$j].Add($y); Wire $railX[$j] $y $xTo $y }
# ANY tree (top) leaves are D taps
$anyTop = 240; $colX = @(1180, 1280, 1380, 1480)
$ANDX = 1100   # AND gates x; inputs at 1070
# --- ANY OR tree ---
$items = @(); for ($b = $N - 1; $b -ge 0; $b--) { $items += , @{K = 'tun'; Bit = $b } }
$lvl = 0; $gcount = 0
while ($items.Count -gt 1) {
  $gx = $colX[$lvl]; $next = @(); $i = 0
  while ($i + 1 -lt $items.Count) {
    $a = $items[$i]; $b = $items[$i + 1]
    if ($a.K -eq 'tun' -and $b.K -eq 'tun') { $gy = $anyTop + 90 * $gcount; $gcount++ }
    elseif ($a.K -eq 'pt' -and $b.K -eq 'pt') { $gy = R10 (($a.Y + $b.Y) / 2) }
    else { $gy = $a.Y + 10 }
    Gate "OR Gate" $gx $gy
    $ins = @(($gy - 10), ($gy + 10)); $k = 0
    foreach ($it in @($a, $b)) {
      if ($it.K -eq 'tun') { Tap $it.Bit $ins[$k] ($gx - 30) }
      else { $xm = $gx - 60; if ($it.Y -eq $ins[$k]) { Wire $it.X $it.Y ($gx - 30) $ins[$k] } else { Path @(@($it.X, $it.Y), @($xm, $it.Y), @($xm, $ins[$k]), @(($gx - 30), $ins[$k])) } }
      $k++
    }
    $next += , @{K = 'pt'; X = $gx; Y = $gy }
    $i += 2
  }
  if ($i -lt $items.Count) { $next += , $items[$i] }
  $items = $next; $lvl++
}
$any = $items[0]
Txt 1330 ($anyTop - 40) "at least one bit changed (OR of D)" "SansSerif plain 12"
# --- AND pairs ---
$andTop = $anyTop + 90 * [math]::Ceiling($N / 2) + 60
$pairs = @(); for ($i = $N - 1; $i -ge 1; $i--) { for ($j = $i - 1; $j -ge 0; $j--) { $pairs += , @($i, $j) } }
$items = @(); $pn = 0
foreach ($pr in $pairs) {
  $gy = $andTop + 50 * $pn; Gate "AND Gate" $ANDX $gy
  Tap $pr[0] ($gy - 10) ($ANDX - 30); Tap $pr[1] ($gy + 10) ($ANDX - 30)
  $items += , @{K = 'pt'; X = $ANDX; Y = $gy }; $pn++
}
Txt 1230 ($andTop - 30) "pairwise Di AND Dj (i<j)" "SansSerif plain 12"
$lvl = 0
$colA = @(1200, 1300, 1400, 1500, 1600, 1700, 1800)
while ($items.Count -gt 1) {
  $gx = $colA[$lvl]; $next = @(); $i = 0
  while ($i + 1 -lt $items.Count) {
    $a = $items[$i]; $b = $items[$i + 1]; $gy = R10 (($a.Y + $b.Y) / 2)
    Gate "OR Gate" $gx $gy
    $ins = @(($gy - 10), ($gy + 10)); $k = 0
    foreach ($it in @($a, $b)) {
      $xm = $gx - 60
      if ($it.Y -eq $ins[$k]) { Wire $it.X $it.Y ($gx - 30) $ins[$k] } else { Path @(@($it.X, $it.Y), @($xm, $it.Y), @($xm, $ins[$k]), @(($gx - 30), $ins[$k])) }
      $k++
    }
    $next += , @{K = 'pt'; X = $gx; Y = $gy }; $i += 2
  }
  if ($i -lt $items.Count) { $next += , $items[$i] }
  $items = $next; $lvl++
}
$multi = $items[0]
# NOT + final AND
$nx = $multi.X + 70; $ny = $multi.Y
Wire $multi.X $ny ($nx - 20) $ny
Gate "NOT Gate" $nx $ny
$fax = $nx + 130; $fay = $ny - 10
Gate "AND Gate" $fax $fay
Wire $nx $ny ($fax - 30) $ny
$vx = $fax - 70
Path @(@($any.X, $any.Y), @($vx, $any.Y), @($vx, ($fay - 10)), @(($fax - 30), ($fay - 10)))
Txt ($nx + 30) ($ny + 40) "V = ANY AND NOT(MULTI)" "SansSerif bold 12"
# rails finalize (after all taps)
for ($j = 0; $j -lt $N; $j++) {
  $bit = $N - 1 - $j
  $port = $ds[$j]
  Wire $port[0] $port[1] $railX[$j] $port[1]
  Rail $railX[$j] $port[1] ($tapsByRail[$j])
}
# V node: FA out
$Vx = $fax; $Vy = $fay
Wire $Vx $Vy ($Vx + 50) $Vy
Wire ($Vx + 50) $Vy ($Vx + 50) ($Vy - 60); OutPin ($Vx + 50) ($Vy - 60) "V"
Wire ($Vx + 50) $Vy ($Vx + 110) $Vy
$Jx = $Vx + 110
Txt ($Jx + 150) 70 "5. MOORE FSM  (IDLE=00  VALID=01  INVALID=10)" "SansSerif bold 16"
# NS logic: V node at (Jx, Vy)
$spx = $Jx + 280; $spy = $Vy - 10           # NS combiner west-facing, bus (spx,spy)
$nf = Split $spx $spy "west" 2 $false
# map: top = NS0 (bit0 fan0), bottom = NS1 (bit1 fan1): set default mapping (bit b -> fan b)
Wire $Jx $Vy ($nf[0][0]) ($nf[0][1])
Wire $Jx $Vy $Jx ($Vy + 40)
Gate "NOT Gate" ($Jx + 90) ($Vy + 40)
Wire $Jx ($Vy + 40) ($Jx + 70) ($Vy + 40)
Path @(@(($Jx + 90), ($Vy + 40)), @(($nf[1][0] - 40), ($Vy + 40)), @(($nf[1][0] - 40), $nf[1][1]), @($nf[1][0], $nf[1][1]))
# state register
$sx = $spx + 60; $sy = $spy - 30
Reg $sx $sy 2 $true
Wire $spx $spy $sx ($spy)
Txt ($sx + 30) ($sy - 5) "STATE REGISTER" "SansSerif bold 12"
$stq = $sy + 30
Wire ($sx + 60) $stq ($sx + 90) $stq; Wire ($sx + 90) $stq ($sx + 140) $stq
Wire ($sx + 90) $stq ($sx + 90) ($stq - 90); OutPin ($sx + 90) ($stq - 90) "STATE" 2
$ssx = $sx + 140
$sf = Split $ssx $stq "east" 2 $true
# top = S1 (bit1), bottom = S0
$r1 = $ssx + 120; $r0 = $ssx + 100
Wire $sf[0][0] $sf[0][1] $r1 $sf[0][1]
Wire $sf[1][0] $sf[1][1] $r0 $sf[1][1]
$dx = $ssx + 230; $dy0 = $stq + 60
$tapS1 = New-Object System.Collections.ArrayList; $tapS0 = New-Object System.Collections.ArrayList
$defs = @(@("IDLE", @(1, 2), "#ffd700"), @("VALID", @(1), "#00c800"), @("INVALID", @(2), "#ff0000"))
# IDLE: both negated; VALID: S1 negated (in1); INVALID: S0 negated (in2)
$g = 0
foreach ($d in $defs) {
  $gy = $dy0 + 110 * $g
  Gate "AND Gate" $dx $gy 1 $d[1]
  [void]$tapS1.Add($gy - 10); Wire $r1 ($gy - 10) ($dx - 30) ($gy - 10)
  [void]$tapS0.Add($gy + 10); Wire $r0 ($gy + 10) ($dx - 30) ($gy + 10)
  Wire $dx $gy ($dx + 50) $gy
  Wire ($dx + 50) $gy ($dx + 90) $gy
  Led ($dx + 90) $gy $d[0] $d[2]
  Wire ($dx + 50) $gy ($dx + 50) ($gy + 40)
  OutPin ($dx + 50) ($gy + 40) "$($d[0])_OUT"
  $g++
}
Rail $r1 $sf[0][1] $tapS1
Rail $r0 $sf[1][1] $tapS0
Txt ($dx + 40) 70 "6. INDICATORS" "SansSerif bold 16"
# controls
$cy = $dy0 + 110 * 3 + 60
InPin 100 $cy "RESET"; InPin 100 ($cy + 30) "CLK"; InPin 100 ($cy + 60) "SAMPLE"
Txt 480 ($cy - 30) "CONTROLS: SAMPLE=1 then pulse CLK (0-1-0). RESET clears both registers and FSM." "SansSerif plain 12"
$lastX = $sx + 30
$regs = @(@(380, $RY), @(560, $RY), @($sx, $sy))
$tR = New-Object System.Collections.ArrayList; $tC = New-Object System.Collections.ArrayList; $tS = New-Object System.Collections.ArrayList
$xsR = @(); $xsC = @(); $xsS = @()
foreach ($r in $regs) {
  $x = $r[0]; $y = $r[1]
  $xsS += ($x - 40); $xsC += ($x - 20); $xsR += ($x + 30)
  Path @(@(($x - 40), ($y + 50)), @($x, ($y + 50)))
  Path @(@(($x - 20), ($y + 70)), @($x, ($y + 70)))
}
# control horizontal lines with drops
function CtlLine($y, $xs, $topYs) {
  $pts = @(100) + ($xs | Sort-Object)
  for ($i = 0; $i -lt $pts.Count - 1; $i++) { Wire $pts[$i] $y $pts[$i + 1] $y }
  for ($i = 0; $i -lt $xs.Count; $i++) { Wire $xs[$i] $y $xs[$i] $topYs[$i] }
}
CtlLine ($cy + 60) $xsS @(($RY + 50), ($RY + 50), ($sy + 50))
CtlLine ($cy + 30) $xsC @(($RY + 70), ($RY + 70), ($sy + 70))
CtlLine $cy $xsR @(($RY + 90), ($RY + 90), ($sy + 90))
# ---------- emit file ----------
$hdr = @'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<project source="5.0.0" version="1.0">
  <lib desc="#Wiring" name="0"/>
  <lib desc="#Gates" name="1"/>
  <lib desc="#Plexers" name="2"/>
  <lib desc="#Arithmetic" name="3"/>
  <lib desc="#Memory" name="4"/>
  <lib desc="#I/O" name="5"/>
  <lib desc="#TTL" name="6"/>
  <lib desc="#TCL" name="7"/>
  <lib desc="#Base" name="8"/>
  <lib desc="#BFH-Praktika" name="9"/>
  <lib desc="#Input/Output-Extra" name="10"/>
  <lib desc="#Soc" name="11"/>
  <main name="main"/>
  <options>
    <a name="gateUndefined" val="ignore"/>
    <a name="simlimit" val="1000"/>
    <a name="simrand" val="0"/>
  </options>
  <circuit name="main">
    <a name="appearance" val="logisim_evolution"/>
    <a name="circuit" val="main"/>
'@
[IO.File]::WriteAllText($OutFile, $hdr + "`r`n" + $sb.ToString() + "  </circuit>`r`n</project>`r`n", (New-Object System.Text.UTF8Encoding($false)))
# ---------- validation ----------
$ends = @{}
foreach ($wi in $W) { foreach ($pt in @(@($wi.X1, $wi.Y1), @($wi.X2, $wi.Y2))) { $k = "$($pt[0]),$($pt[1])"; $ends[$k] = 1 + [int]$ends[$k] } }
$portk = @{}; foreach ($pp in $P) { $k = "$($pp.X),$($pp.Y)"; if (-not $portk.ContainsKey($k)) { $portk[$k] = New-Object System.Collections.ArrayList }; [void]$portk[$k].Add($pp.T) }
$warn = 0
foreach ($k in $ends.Keys) { if ($ends[$k] -eq 1 -and -not $portk.ContainsKey($k)) { "FLOATING wire end at $k"; $warn++ } }
foreach ($k in $portk.Keys) { if (-not $ends.ContainsKey($k)) { "UNWIRED port $k : $($portk[$k] -join ',')"; $warn++ } }
foreach ($wi in $W) {
  foreach ($k in (@($ends.Keys) + @($portk.Keys))) {
    $xy = $k.Split(','); $x = [int]$xy[0]; $y = [int]$xy[1]
    if ($wi.X1 -eq $wi.X2 -and $x -eq $wi.X1 -and $y -gt [math]::Min($wi.Y1, $wi.Y2) -and $y -lt [math]::Max($wi.Y1, $wi.Y2)) { "T-TOUCH (unsplit) at $k on wire ($($wi.X1),$($wi.Y1))-($($wi.X2),$($wi.Y2))"; $warn++ }
    if ($wi.Y1 -eq $wi.Y2 -and $y -eq $wi.Y1 -and $x -gt [math]::Min($wi.X1, $wi.X2) -and $x -lt [math]::Max($wi.X1, $wi.X2)) { "T-TOUCH (unsplit) at $k on wire ($($wi.X1),$($wi.Y1))-($($wi.X2),$($wi.Y2))"; $warn++ }
  }
}
$cross = 0
for ($a = 0; $a -lt $W.Count; $a++) { for ($b = $a + 1; $b -lt $W.Count; $b++) {
    $u = $W[$a]; $v = $W[$b]
    $uh = ($u.Y1 -eq $u.Y2); $vh = ($v.Y1 -eq $v.Y2)
    if ($uh -eq $vh) {
      if ($uh -and $u.Y1 -eq $v.Y1) { $lo = [math]::Max([math]::Min($u.X1, $u.X2), [math]::Min($v.X1, $v.X2)); $hi = [math]::Min([math]::Max($u.X1, $u.X2), [math]::Max($v.X1, $v.X2)); if ($hi -gt $lo) { "OVERLAP horizontal y=$($u.Y1) x $lo..$hi"; $warn++ } }
      if (-not $uh -and $u.X1 -eq $v.X1) { $lo = [math]::Max([math]::Min($u.Y1, $u.Y2), [math]::Min($v.Y1, $v.Y2)); $hi = [math]::Min([math]::Max($u.Y1, $u.Y2), [math]::Max($v.Y1, $v.Y2)); if ($hi -gt $lo) { "OVERLAP vertical x=$($u.X1) y $lo..$hi"; $warn++ } }
    }
    else {
      $h = if ($uh) { $u } else { $v }; $vt = if ($uh) { $v } else { $u }
      if ($vt.X1 -gt [math]::Min($h.X1, $h.X2) -and $vt.X1 -lt [math]::Max($h.X1, $h.X2) -and $h.Y1 -gt [math]::Min($vt.Y1, $vt.Y2) -and $h.Y1 -lt [math]::Max($vt.Y1, $vt.Y2)) { $cross++ }
    }
  } }
"validation: $warn problems, $cross wire crossings (no-dot crossings)"
"size: wires=$($W.Count) ports=$($P.Count)"



