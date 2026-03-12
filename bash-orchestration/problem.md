# Problem Definition

## Task Description

Upgrade `CoffeeMaker.WebApi` from .NET 7 to .NET 8. Update the target framework in `CoffeeMaker.WebApi.csproj` and update all NuGet package references to versions compatible with .NET 8. The other two projects (`CoffeeMaker.Adapters`, `CoffeeMaker.Hardware.Api`) are out of scope and must not be changed. The project must restore and build successfully after the upgrade.

## Context Files (read-only)

- CoffeeMakerProblem/CoffeeMaker.Adapters/CoffeeMaker.Adapters.csproj
- CoffeeMakerProblem/CoffeeMaker.Hardware.Api/CoffeeMaker.Hardware.Api.csproj

## Target Files (to modify)

- CoffeeMakerProblem/CoffeeMaker.WebApi/CoffeeMaker.WebApi.csproj

## Rules & Constraints

- Change `<TargetFramework>` from `net7.0` to `net8.0`
- Update all NuGet packages to versions compatible with .NET 8 (e.g. `Microsoft.AspNetCore.OpenApi` 8.x, `Swashbuckle.AspNetCore` 6.5+)
- Keep `<Nullable>enable</Nullable>` and `<ImplicitUsings>enable</ImplicitUsings>`
- Do not modify any file outside the target files list
- All specified package versions must be exact (no floating versions like `*`)

## Review Criteria

1. `<TargetFramework>` is set to `net8.0` in `CoffeeMaker.WebApi.csproj`
2. `Microsoft.AspNetCore.OpenApi` is updated to a .NET 8 compatible version (8.x)
3. `Swashbuckle.AspNetCore` is updated to a version compatible with .NET 8 (6.5 or later)
4. No other NuGet packages remain pinned to .NET 7 era versions
5. `<Nullable>enable</Nullable>` is still present and unchanged
6. `<ImplicitUsings>enable</ImplicitUsings>` is still present and unchanged
7. No changes are proposed to `CoffeeMaker.Adapters.csproj` or `CoffeeMaker.Hardware.Api.csproj`
8. All specified package versions are exact (no wildcards or ranges)
9. Every issue from `critique.md` (if any) is explicitly addressed in the plan
10. The plan contains no vague placeholders — all version numbers are specific and justified

## Implementation Instructions

After applying changes, run from the solution root:
```
cd CoffeeMakerProblem
dotnet restore
dotnet build --no-restore
```
