using System.ComponentModel.DataAnnotations;

namespace avalon_backend.Entities;

public class Category
{
    public int Id { get; set; }

    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [MaxLength(50)]
    public string IconName { get; set; } = string.Empty;

    // Navigation
    public ICollection<Question> Questions { get; set; } = [];
    public ICollection<Leaderboard> LeaderboardEntries { get; set; } = [];
}
