Import-Module ActiveDirectory

# --- VARIABLES GENERALES ---
$Domain = "DC=articwolves,DC=local"
$RootOUName = "articwolves_oficina"
$RootOUPath = "OU=$RootOUName,$Domain"
$DeptOUPath = "OU=Departamentos,$RootOUPath"
$GruposOUPath = "OU=Grupos_Seguridad,$RootOUPath"

# El usuario tendrá que cambiarla al iniciar sesión por primera vez
$Password = ConvertTo-SecureString "jma@2113" -AsPlainText -Force

Write-Host "Iniciando la creación de la estructura en Active Directory..." -ForegroundColor Cyan

# --- 2. CREAR UNIDADES ORGANIZATIVAS (OUs) ---
Write-Host "Creando Unidades Organizativas..."
New-ADOrganizationalUnit -Name $RootOUName -Path $Domain
New-ADOrganizationalUnit -Name "Departamentos" -Path $RootOUPath
New-ADOrganizationalUnit -Name "Grupos_Seguridad" -Path $RootOUPath
New-ADOrganizationalUnit -Name "Servidores" -Path $RootOUPath
New-ADOrganizationalUnit -Name "Equipos_Clientes" -Path $RootOUPath

# Crear las OUs de cada departamento dentro de la OU "Departamentos"
$Departamentos = @("01_Directiva", "02_Finanzas", "03_Marketing", "04_IT", "05_Recepcion", "06_Almacen")
foreach ($Dept in $Departamentos) {
    New-ADOrganizationalUnit -Name $Dept -Path $DeptOUPath
}

# --- 3. CREAR GRUPOS DE SEGURIDAD ---
Write-Host "Creando Grupos de Seguridad..."
$Grupos = @("G_Directiva", "G_Finanzas", "G_Marketing", "G_IT_Admins", "G_Recepcion", "G_Almacen")
foreach ($Grupo in $Grupos) {
    New-ADGroup -Name $Grupo -GroupScope Global -GroupCategory Security -Path $GruposOUPath
}

# --- 4. CREAR USUARIOS Y AÑADIRLOS A SUS GRUPOS ---
Write-Host "Creando Usuarios..."

# Creamos una pequeña función para no repetir el mismo código largo por cada usuario
function Crear-Usuario ($Nombre, $Apellido, $SamAccount, $OU, $Grupo) {
    $UserPath = "OU=$OU,$DeptOUPath"
    $UPN = "$SamAccount@articwolves.local"
    
    # Crea el usuario en la OU correspondiente
    New-ADUser -Name "$Nombre $Apellido" -GivenName $Nombre -Surname $Apellido -SamAccountName $SamAccount -UserPrincipalName $UPN -Path $UserPath -AccountPassword $Password -Enabled $true -ChangePasswordAtLogon $true
    
    # Lo mete en su grupo de seguridad
    Add-ADGroupMember -Identity $Grupo -Members $SamAccount
    Write-Host " -> Usuario $SamAccount creado y añadido a $Grupo" -ForegroundColor Green
}

# Ejecutamos la función para crear nuestra plantilla de usuarios
Crear-Usuario -Nombre "Carlos" -Apellido "Director" -SamAccount "carlos.director" -OU "01_Directiva" -Grupo "G_Directiva"
Crear-Usuario -Nombre "Laura" -Apellido "Contable" -SamAccount "laura.contable" -OU "02_Finanzas" -Grupo "G_Finanzas"
Crear-Usuario -Nombre "Sofia" -Apellido "Creativa" -SamAccount "sofia.creativa" -OU "03_Marketing" -Grupo "G_Marketing"
Crear-Usuario -Nombre "Admin" -Apellido "IT" -SamAccount "admin.it" -OU "04_IT" -Grupo "G_IT_Admins"
Crear-Usuario -Nombre "Soporte" -Apellido "Tecnico" -SamAccount "soporte.tecnico" -OU "04_IT" -Grupo "G_IT_Admins"
Crear-Usuario -Nombre "Recepcion" -Apellido "Principal" -SamAccount "recepcion.principal" -OU "05_Recepcion" -Grupo "G_Recepcion"
Crear-Usuario -Nombre "Operario" -Apellido "Uno" -SamAccount "operario.01" -OU "06_Almacen" -Grupo "G_Almacen"

Write-Host "¡Estructura de Active Directory creada con éxito! Abre 'Usuarios y equipos de Active Directory' para comprobarlo." -ForegroundColor Yellow