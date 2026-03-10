# Problem Definition — .NET 8 to .NET 10 Upgrade

## Task Description

Upgrade a web API project from .NET 8 to .NET 10. Update the target framework,
NuGet packages, and any code using deprecated APIs. Ensure the project builds
and all tests pass after the upgrade.

## Context Files (read-only)

- docs/migration-notes.md
- CHANGELOG.md

## Target Files (to modify)

- src/WebApi/WebApi.csproj
- src/WebApi/Program.cs
- src/WebApi/appsettings.json
- tests/WebApi.Tests/WebApi.Tests.csproj
- global.json
- Dockerfile

## Rules & Constraints

- Use the new .NET 10 minimal hosting model where applicable
- Prefer `app.MapGroup()` over individual route registrations
- Do not downgrade any package to an older major version
- Keep `<Nullable>enable</Nullable>` and `<ImplicitUsings>enable</ImplicitUsings>`
- Dockerfile must use the official `mcr.microsoft.com/dotnet/aspnet:10.0` base image

## Review Criteria

1. Target framework is set to `net10.0` in all .csproj files
2. global.json specifies a valid .NET 10 SDK version
3. All NuGet packages are updated to .NET 10 compatible versions
4. No references to deprecated .NET 8 APIs remain
5. Dockerfile base images are updated to .NET 10 tags
6. No breaking changes to public API contracts (request/response models unchanged)
7. All rules and constraints above are respected
8. Test project targets and packages are updated consistently with the main project
9. Every issue from the previous critique.md is explicitly addressed in the plan
10. Changes are specific with exact version numbers and code snippets (not vague)

## Implementation Instructions

After applying changes, run:
```
dotnet restore
dotnet build --no-restore
dotnet test --no-build
```
