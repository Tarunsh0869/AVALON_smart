using System.ComponentModel.DataAnnotations;

namespace avalon_backend.Entities;

public class User
{
    public int Id { get; set; }

    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [Required, MaxLength(150)]
    public string Email { get; set; } = string.Empty;

    [Required]
    public string PasswordHash { get; set; } = string.Empty;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public ICollection<QuizAttempt> QuizAttempts { get; set; } = [];
    public ICollection<Leaderboard> LeaderboardEntries { get; set; } = [];
}
