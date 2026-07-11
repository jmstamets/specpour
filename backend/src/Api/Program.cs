using Serilog;
using SpecPour.Api;
using SpecPour.Api.Health;
using SpecPour.Api.Observability;
using SpecPour.Api.RateLimiting;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Http;

var builder = WebApplication.CreateBuilder(args);

builder.AddSpecPourSerilog();

var connectionString = builder.Configuration.GetSpecPourConnectionString();

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

builder.Services.AddSpecPourProblemDetails();
builder.Services.AddSpecPourRateLimiting();
builder.Services.AddSpecPourHealthChecks(connectionString);
// AddAuthentication()/UseAuthentication() land with OpenIddict (T017); AddAuthorization()
// alone is safe to register now — no endpoint calls RequireAuthorization() yet.
builder.Services.AddAuthorization();
builder.Services.AddSpecPourOpenTelemetry(builder.Configuration);
builder.Services.AddSpecPourOutboxDispatcher(connectionString);

foreach (var module in ModuleRegistry.All)
{
    module.RegisterServices(builder.Services, builder.Configuration);
}

var app = builder.Build();

// Configure the HTTP request pipeline. Order matters (T014):
// correlation ID -> request logging -> exception/problem+json -> rate limiting ->
// authz -> health checks -> module endpoints.
app.UseMiddleware<CorrelationIdMiddleware>();
app.UseSerilogRequestLogging();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.MapOpenApi();
}
else
{
    app.UseExceptionHandler();
}

app.UseRateLimiter();

app.UseAuthorization();

app.UseHttpsRedirection();

app.MapSpecPourHealthChecks();

foreach (var module in ModuleRegistry.All)
{
    module.MapEndpoints(app);
}

app.Run();

// Exposes the top-level-statements Program type to WebApplicationFactory<Program> in
// the Acceptance/Contract test harnesses (T026/T027), which live in another assembly.
public partial class Program;
