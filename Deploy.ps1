# Deploy.ps1 - Complete redeploy with Tomcat start

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Starting Tomcat..." -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Cyan

# Set CATALINA_HOME environment variable
$env:CATALINA_HOME = "C:\tomcat9"

# Start Tomcat
& "C:\tomcat9\bin\startup.bat"
Start-Sleep -Seconds 5

# Build
Write-Host ""
Write-Host "Building project..." -ForegroundColor Yellow
mvnd clean package

# Deploy
Write-Host ""
Write-Host "Deploying to Tomcat..." -ForegroundColor Yellow
Copy-Item "target\Lab_project3.war" "C:\tomcat9\webapps\Lab_project3.war" -Force

# Clear old extracted folder
Write-Host "Clearing old files..." -ForegroundColor Yellow
Remove-Item "C:\tomcat9\webapps\Lab_project3" -Recurse -Force -ErrorAction SilentlyContinue

# Wait for redeploy
Write-Host ""
Write-Host "Waiting 3 seconds for full JSP recompilation..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

# Open browser
Write-Host ""
Write-Host "Opening application..." -ForegroundColor Green
Start-Process "http://localhost:8080/Lab_project3"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "Complete redeploy finished!" -ForegroundColor Green
Write-Host "All JSP/HTML changes recompiled" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green