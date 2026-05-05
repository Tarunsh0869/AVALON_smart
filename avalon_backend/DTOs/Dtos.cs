using System.ComponentModel.DataAnnotations;

namespace avalon_backend.DTOs;

// ── Auth ──────────────────────────────────────────────────────────────────────

public record RegisterDto(
    [Required, MaxLength(100)] string Name,
    [Required, EmailAddress]   string Email,
    [Required, MinLength(6)]   string Password
);

public record LoginDto(
    [Required, EmailAddress] string Email,
    [Required]               string Password
);

public record AuthResponseDto(string Token, string Name, int UserId);

// ── Categories ────────────────────────────────────────────────────────────────

public record CategoryDto(int Id, string Name, string IconName);

// ── Questions (correct answer is EXCLUDED) ────────────────────────────────────

public record QuestionDto(int Id, string QuestionText, List<string> Options);

// ── Submit Quiz ───────────────────────────────────────────────────────────────

// Flutter sends: [{"questionId": 1, "selectedOption": "Paris"}, ...]
public record AnswerDto(int QuestionId, string SelectedOption);

public record SubmitQuizDto(int CategoryId, List<AnswerDto> Answers);

public record SubmitQuizResponseDto(int Score, int Total, string Message);

// ── Leaderboard ───────────────────────────────────────────────────────────────

public record LeaderboardDto(int Rank, int UserId, string UserName, string Category, int BestScore);
