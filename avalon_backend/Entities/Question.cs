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

    // e.g. "A" — NEVER exposed to Flutter
    [Required, MaxLength(5)]
    public string CorrectOption { get; set; } = string.Empty;
}
