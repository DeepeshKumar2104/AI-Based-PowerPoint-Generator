
# Set base directory
$basePath = "AuthService"
New-Item -Path $basePath -ItemType Directory -Force
Set-Location $basePath

# Create solution and src folder
New-Item -Path "src" -ItemType Directory -Force
cd src

# Create solution and projects
dotnet new sln -n AuthService
dotnet new webapi -n AuthService.API
dotnet new classlib -n AuthService.Application
dotnet new classlib -n AuthService.Core
dotnet new classlib -n AuthService.Infrastructure
dotnet new xunit -n AuthService.Tests

# Add projects to solution
dotnet sln add ./AuthService.API/AuthService.API.csproj
dotnet sln add ./AuthService.Application/AuthService.Application.csproj
dotnet sln add ./AuthService.Core/AuthService.Core.csproj
dotnet sln add ./AuthService.Infrastructure/AuthService.Infrastructure.csproj
dotnet sln add ./AuthService.Tests/AuthService.Tests.csproj

# Add references
dotnet add ./AuthService.API/AuthService.API.csproj reference ./AuthService.Application/AuthService.Application.csproj
dotnet add ./AuthService.Application/AuthService.Application.csproj reference ./AuthService.Core/AuthService.Core.csproj
dotnet add ./AuthService.Application/AuthService.Application.csproj reference ./AuthService.Infrastructure/AuthService.Infrastructure.csproj
dotnet add ./AuthService.Tests/AuthService.Tests.csproj reference ./AuthService.Application/AuthService.Application.csproj
dotnet add ./AuthService.Tests/AuthService.Tests.csproj reference ./AuthService.Core/AuthService.Core.csproj

# Create folders and files for each project
$structure = @{
    "AuthService.API" = @{
        "Controllers" = @("AuthController.cs")
        "Models" = @("User.cs")
    }
    "AuthService.Application" = @{
        "Interfaces" = @("IAuthService.cs")
        "Services" = @("AuthService.cs")
        "DTOs" = @("AuthRequest.cs")
    }
    "AuthService.Core" = @{
        "Entities" = @("User.cs")
    }
    "AuthService.Infrastructure" = @{
        "Data" = @("AuthRepository.cs")
        "JWT" = @("JwtHelper.cs")
        "Context" = @("ApplicationDbContext.cs")
    }
    "AuthService.Tests" = @{
        "" = @("AuthServiceTests.cs", "AuthServiceMockTests.cs")
    }
}

foreach ($proj in $structure.Keys) {
    foreach ($folder in $structure[$proj].Keys) {
        $path = if ($folder -eq "") { "src/$proj" } else { "src/$proj/$folder" }
        New-Item -Path $path -ItemType Directory -Force
        foreach ($file in $structure[$proj][$folder]) {
            New-Item -Path "$path/$file" -ItemType File -Force
        }
    }
}

# Create docker folder and files
cd ../
New-Item -Path "docker" -ItemType Directory -Force
New-Item -Path "docker/Dockerfile" -ItemType File -Force
New-Item -Path "docker/docker-compose.yml" -ItemType File -Force

# Create root-level files
New-Item -Path "README.md" -ItemType File -Force
New-Item -Path "requirements.txt" -ItemType File -Force

Write-Host "✅ Clean Architecture project setup complete!"
