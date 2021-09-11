PackageName "ROCCAT Swarm"

#Common Script Vars
$templatename = "roccatswarm"
$tempfolder = "$temp/$templatename/"
$verfile = "$templatename.ver"
$oldversion = GetLastVersion $verfile

if (CheckSkip $oldversion) {return}

$downloadapi = (Invoke-WebRequest "https://api.roccat-neon.com/device/Support/Downloads/en/202/v2").Content
$apijson = ConvertFrom-Json $downloadapi

$item = $apijson.download;

if (ItemNotDefined $item $templatename "item") {return}

$version = $item.version
$release = "Released $($item.release)"

if (VersionNotValid $version $templatename) {return}

if (VersionNotNew $oldversion $version) {return}

$changelogjson = $item.changelog.'ROCCAT® Swarm'[0].changelog;

$changelogdata = Join-String -InputObject $changelogjson -Separator "`r`n"

$changelog = @"
$release

$changelogdata
"@

DebugOut "Changelog: $changelog"

$downloadurl = $item.url

$fileinfo = HashSizeAndContentsFromZipFileURL $downloadurl
$filehash = $fileinfo[0]
$filesize = $fileinfo[1]
$files = $fileinfo[2]

$exes = $files | Where-Object { $_.FullName -like '*.exe' }
$installfile = $exes[0].FullName

if (!(BuildTemplateParam $templatename $filehash $downloadurl $version $changelog $installfile "")) {return}
if (!(PackAndClean)) {return}

NotePackageUpdate $version $verfile $templatename (GetFileSize $filesize)
