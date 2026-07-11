using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace SpecPour.Modules.Notifications.Infrastructure;

/// <summary>Design-time factory for `dotnet ef migrations add`.</summary>
public sealed class NotificationsDbContextFactory : IDesignTimeDbContextFactory<NotificationsDbContext>
{
    public NotificationsDbContext CreateDbContext(string[] args)
    {
        var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__Postgres")
            ?? "Host=localhost;Port=5432;Database=specpour;Username=specpour;Password=specpour_dev_only";

        var optionsBuilder = new DbContextOptionsBuilder<NotificationsDbContext>()
            .UseNpgsql(connectionString);

        return new NotificationsDbContext(optionsBuilder.Options);
    }
}
