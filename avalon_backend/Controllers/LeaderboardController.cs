using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using avalon_backend.Data;
using avalon_backend.DTOs;

namespace avalon_backend.Controllers;

[ApiController]
[Route("api/leaderboard")]
public class LeaderboardController(AppDbContext db) : ControllerBase
{
    // GET api/leaderboard
    [HttpGet]
    public async Task<IActionResult> GetTop()
    {
        var entries = await db.Leaderboards
            .Include(l => l.User)
            .Include(l => l.Category)
            .OrderByDescending(l => l.BestScore)
            .Take(20)
            .ToListAsync();

        var result = entries.Select((l, index) =>
            new LeaderboardDto(index + 1, l.UserId, l.User.Name, l.Category.Name, l.BestScore));

        return Ok(result);
    }
}
