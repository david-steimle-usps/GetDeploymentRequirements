## GetDeploymentRequirements.ps1

### Description
The `GetDeploymentRequirements.ps1` script is a PowerShell script designed to retrieve deployment requirements for applications in a Microsoft Configuration Manager (MECM) environment. It uses the Configuration Manager PowerShell module to query and extract details about applications, their deployment types, and associated requirements.

### Parameters
- **`SiteCode`**: A string parameter that specifies the site code of the Configuration Manager site to connect to. This is used to set the context for querying the Configuration Manager environment.

### Features
1. **Imports Configuration Manager Module**: The script imports the Configuration Manager PowerShell module to access MECM cmdlets.
2. **Sets Configuration Manager Context**: It sets the working location to the specified site code.
3. **Retrieves Application Details**:
   - Queries all applications using `Get-CMApplication`.
   - Extracts details such as application name, CI_ID, CI_UniqueID, and deployment type.
4. **Retrieves Deployment Requirements**:
   - For each application, it retrieves deployment requirements using `Get-CMDeploymentTypeRequirement`.
   - Stores the results in a custom `DeploymentRequirement` class.
5. **Generates a Report**:
   - Outputs a list of deployment requirements for all applications in the specified site.

### Output
The script generates a report containing the following details for each application:
- Application Name
- CI_ID
- CI_UniqueID
- Deployment Type
- Requirement Name

### Usage
1. Open a PowerShell session with the necessary permissions to access the Configuration Manager environment.
2. Run the script with the `SiteCode` parameter:
   ```powershell
   .\GetDeploymentRequirements.ps1 -SiteCode "YourSiteCode"