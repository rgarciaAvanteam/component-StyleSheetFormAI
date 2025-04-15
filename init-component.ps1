# Script d'initialisation du composant
# init-component.ps1

param (
    [Parameter(Mandatory=$true)]
    [string]$ComponentName,
    
    [Parameter(Mandatory=$true)]
    [string]$DisplayName,
    
    [Parameter(Mandatory=$true)]
    [string]$Description,
    
    [Parameter(Mandatory=$true)]
    [string]$Category,
    
    [Parameter(Mandatory=$false)]
    [string]$MinVersion = "5.0.0"
)

# Fonction pour remplacer les placeholders dans un fichier
function Replace-Placeholders {
    param (
        [string]$FilePath,
        [hashtable]$Replacements
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Error "Le fichier $FilePath n'existe pas!"
        return
    }
    
    $content = Get-Content -Path $FilePath -Raw
    
    foreach ($key in $Replacements.Keys) {
        $content = $content -replace $key, $Replacements[$key]
    }
    
    Set-Content -Path $FilePath -Value $content
}

# Créer un dictionnaire de remplacements
$replacements = @{
    "COMPONENT_NAME" = $ComponentName
    "COMPONENT_DISPLAY_NAME" = $DisplayName
    "COMPONENT_DESCRIPTION" = $Description
    "COMPONENT_CATEGORY" = $Category
    "COMPONENT_TAG" = $Category.ToLower()
    "DATE_CREATION" = (Get-Date -Format "yyyy-MM-dd")
}

# Appliquer les remplacements aux fichiers
$filesToUpdate = @(
    "manifest.json",
    "README.md",
    "CHANGELOG.md",
    "install.ps1"
)

foreach ($file in $filesToUpdate) {
    Write-Host "Mise à jour de $file..."
    Replace-Placeholders -FilePath $file -Replacements $replacements
}

Write-Host "Initialisation du composant terminée avec succès!"
Write-Host "N'oubliez pas de mettre à jour les fichiers dans le répertoire src/ avec votre code source."