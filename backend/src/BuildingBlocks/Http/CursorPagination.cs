using System.Globalization;
using System.Text;

namespace SpecPour.BuildingBlocks.Http;

/// <summary>
/// Shared implementation of the base64-encoded-offset cursor convention used by
/// every list endpoint in this codebase (contracts/api-v1-surface.md: "Pagination:
/// cursor-based (`cursor`, `limit`)"). Notifications' InboxEndpoint (T023) and
/// Search's PostgresFullTextSearchAdapter (T022) each independently wrote the same
/// two methods before this existed; new list endpoints (T037+) should use this
/// instead of re-deriving it a third+ time.
/// </summary>
public static class CursorPagination
{
    public static int Decode(string? cursor) =>
        string.IsNullOrEmpty(cursor) ? 0 : int.Parse(Encoding.UTF8.GetString(Convert.FromBase64String(cursor)), CultureInfo.InvariantCulture);

    public static string Encode(int offset) =>
        Convert.ToBase64String(Encoding.UTF8.GetBytes(offset.ToString(CultureInfo.InvariantCulture)));
}
