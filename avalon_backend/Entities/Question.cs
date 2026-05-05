using System.ComponentModel.DataAnnotations;

namespace avalon_backend.Entities;

public class Question
{
    public int Id { get; set; }

    public int CategoryId { get; set; }
    public Category Category { get; set; } = null!;

    [Required]
    public string QuestionText { get; set; } = string.Empty;

    // Stored as JSON string: ["A","B","C","D"]
    [Required]
    public string OptionsJson { get; set; } = string.Empty;

    // Correct answer text — NEVER exposed to Flutter
    [Required, MaxLength(200)]
    public string CorrectOption { get; set; } = string.Empty;
}
