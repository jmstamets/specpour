using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Compliance.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add`.</summary>
public sealed class ComplianceDbContextFactory : IDesignTimeDbContextFactory<ComplianceDbContext>
{
    public ComplianceDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<ComplianceDbContext>()
            .UseNpgsql(connectionString);

        return new ComplianceDbContext(optionsBuilder.Options);
    }
}
