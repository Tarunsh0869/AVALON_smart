using System.ComponentModel.DataAnnotations;

namespace avalon_backend.Entities;

public class QuizAttempt
{
    public int Id { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;

    public int CategoryId { get; set; }
    public Category Category { get; set; } = null!;

    // Score calculated by backend only
    public int Score { get; set; }
    public int TotalQuestions { get; set; }

    public DateTime AttemptedAt { get; set; } = DateTime.UtcNow;
}
