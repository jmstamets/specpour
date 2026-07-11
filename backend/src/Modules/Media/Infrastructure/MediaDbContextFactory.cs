using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Media.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add`.</summary>
public sealed class MediaDbContextFactory : IDesignTimeDbContextFactory<MediaDbContext>
{
    public MediaDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<MediaDbContext>()
            .UseNpgsql(connectionString);

        return new MediaDbContext(optionsBuilder.Options);
    }
}
