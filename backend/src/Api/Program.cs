using Serilog;
using SpecPour.Api;
using SpecPour.Api.Health;
using SpecPour.Api.Observability;
using SpecPour.Api.RateLimiting;
using SpecPour.BuildingBlocks.Events.Outbox;
using SpecPour.BuildingBlocks.Http;
using SpecPour.BuildingBlocks.Time;

var builder = WebApplication.CreateBuilder(args);

builder.AddSpecPourSerilog();

var connectionString = builder.Configuration.GetSpecPourConnectionString();

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

builder.Services.AddSpecPourProblemDetails();
builder.Services.AddSpecPourRateLimiting();
builder.Services.AddSpecPourHealthChecks(connectionString);
// AddAuthentication() is registered by IdentityModule (T017: cookie scheme for the
// interactive OAuth authorize step + OpenIddict's own server/validation schemes).
builder.Services.AddAuthorization();
builder.Services.AddSpecPourOpenTelemetry(builder.Configuration);
builder.Services.AddSpecPourOutboxDispatcher(connectionString);
// T026: acceptance tests override this with a settable TestClock via
// WebApplicationFactory's ConfigureTestServices — production always gets real time.
builder.Services.AddSingleton<IClock, SystemClock>();

foreach (var module in ModuleRegistry.All)
{
    module.RegisterServices(builder.Services, builder.Configuration);
}

var app = builder.Build();

// Configure the HTTP request pipeline. Order matters (T014):
// correlation ID -> request logging -> exception/problem+json -> rate limiting ->
// authn -> authz -> health checks -> module endpoints.
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

// Every non-2xx response must be problem+json (T007's global convention,
// contracts/openapi/openapi.yaml). Without this, ASP.NET Core's authentication
// challenge (401 on a missing/invalid bearer token) writes only a bare status code
// and a WWW-Authenticate header with an EMPTY body — UseStatusCodePages wraps the
// downstream pipeline and, whenever it sees an error status with no body written
// yet, asks AddProblemDetails() (registered above) to fill one in. Must be
// registered before UseAuthentication/UseAuthorization so it can see their result.
app.UseStatusCodePages();

app.UseRateLimiter();

app.UseAuthentication();
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
