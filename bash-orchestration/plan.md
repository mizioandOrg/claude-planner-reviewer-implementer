# Improvement Plan — Iteration 1

## Changes to CoffeeMakerProblem/CoffeeMaker.WebApi/CoffeeMaker.WebApi.csproj

- **Line 4, `<TargetFramework>`**: Change `net7.0` to `net8.0`
  - Reason: The task requires upgrading to .NET 8.

- **Line 10, `Microsoft.AspNetCore.OpenApi` version**: Change `Version="7.0.0"` to `Version="8.0.11"`
  - Reason: `Microsoft.AspNetCore.OpenApi` is an ASP.NET Core framework package that ships with the runtime. Version 8.0.11 is the latest stable .NET 8 patch release and is fully compatible with `net8.0`. Using a 7.x version with a net8.0 target will cause a restore/build failure.

- **Line 11, `Swashbuckle.AspNetCore` version**: Change `Version="6.4.0"` to `Version="6.9.0"`
  - Reason: Swashbuckle.AspNetCore 6.4.0 does not support .NET 8's updated Swagger/OpenAPI pipeline. Version 6.9.0 is the latest stable 6.x release and is confirmed compatible with .NET 8 and ASP.NET Core 8.

No other lines require modification. `<Nullable>enable</Nullable>` and `<ImplicitUsings>enable</ImplicitUsings>` remain unchanged on lines 5 and 6. The `<ItemGroup>` blocks for `ProjectReference` entries are untouched.

## Critique Responses

No critique.md issues to address (critique.md contains only the placeholder text from initial setup).
