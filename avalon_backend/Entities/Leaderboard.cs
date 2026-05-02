using System.ComponentModel.DataAnnotations;

namespace avalon_backend.Entities;

public class Leaderboard
{
    public int Id { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;

    public int CategoryId { get; set; }
    public Category Category { get; set; } = null!;

    public int BestScore { get; set; }

    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}
