# Front Row Seat: serves this folder at http://localhost:<port>/ and opens it in your browser.
# index.html is rebuilt from page.html on every page load, so edits to page.html show on refresh.
param([int]$Port = 8765, [switch]$NoOpen)

$root = [IO.Path]::GetFullPath($PSScriptRoot)
$utf8 = New-Object Text.UTF8Encoding($false)
function Build-Index {
  $body = [IO.File]::ReadAllText((Join-Path $root 'page.html'), $utf8)
  $html = '<!doctype html><html lang="en"><head><meta charset="utf-8">' +
          '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"></head><body>' +
          "`n$body`n</body></html>`n"
  [IO.File]::WriteAllText((Join-Path $root 'index.html'), $html, $utf8)
}
Build-Index

$listener = New-Object Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
try { $listener.Start() } catch {
  Write-Host "Port $Port is already in use. Close the other Front Row window, or run: play.cmd 8766"
  exit 1
}
Write-Host "Front Row Seat is running at http://localhost:$Port/"
Write-Host "Close this window to stop it."
if (-not $NoOpen) { Start-Process "http://localhost:$Port/" }

$types = @{
  '.html' = 'text/html; charset=utf-8'; '.js' = 'text/javascript'; '.css' = 'text/css'; '.json' = 'application/json'
  '.png' = 'image/png'; '.jpg' = 'image/jpeg'; '.svg' = 'image/svg+xml'
  '.mp4' = 'video/mp4'; '.webm' = 'video/webm'; '.m3u8' = 'application/vnd.apple.mpegurl'; '.ts' = 'video/mp2t'
}
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  try {
    $name = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
    if ($name -eq '' -or $name -eq 'index.html') { $name = 'index.html'; Build-Index }
    $path = [IO.Path]::GetFullPath((Join-Path $root $name))
    if ($path.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $path -PathType Leaf)) {
      $bytes = [IO.File]::ReadAllBytes($path)
      $ext = [IO.Path]::GetExtension($path).ToLower()
      $ctx.Response.ContentType = $(if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' })
      $ctx.Response.Headers.Add('Cache-Control', 'no-store')
      $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else { $ctx.Response.StatusCode = 404 }
  } catch { } finally { try { $ctx.Response.Close() } catch { } }
}
