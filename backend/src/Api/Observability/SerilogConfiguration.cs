using Serilog;
using Serilog.Formatting.Compact;

namespace SpecPour.Api.Observability;

/// <summary>
/// Structured logging (R16): compact JSON to console for local/container log
/// collection, plus OTLP export so logs land in the same collector pipeline as traces
/// and metrics. Correlation-ID and sensitive-field scrubbing are always-on enrichers,
/// not opt-in, so no call site can accidentally skip them.
/// </summary>
public static class SerilogConfiguration
{
    public static WebApplicationBuilder AddSpecPourSerilog(this WebApplicationBuilder builder)
    {
        builder.Services.AddHttpContextAccessor();

        builder.Host.UseSerilog((context, services, loggerConfiguration) =>
        {
            var otlpEndpoint = context.Configuration["OTEL_EXPORTER_OTLP_ENDPOINT"]
                ?? Environment.GetEnvironmentVariable("OTEL_EXPORTER_OTLP_ENDPOINT");

            loggerConfiguration
                .MinimumLevel.Information()
                .Enrich.FromLogContext()
                .Enrich.WithProperty("Application", "SpecPour.Api")
                .Enrich.With(new CorrelationIdLogEnricher(services.GetRequiredService<IHttpContextAccessor>()))
                .Enrich.With<SensitiveFieldScrubbingEnricher>()
                .WriteTo.Console(new CompactJsonFormatter());

            if (!string.IsNullOrWhiteSpace(otlpEndpoint))
            {
                loggerConfiguration.WriteTo.OpenTelemetry(options =>
                {
                    options.Endpoint = otlpEndpoint;
                    options.Protocol = Serilog.Sinks.OpenTelemetry.OtlpProtocol.Grpc;
                });
            }
        });

        return builder;
    }
}
