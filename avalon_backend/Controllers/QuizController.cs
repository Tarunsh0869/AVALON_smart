using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using avalon_backend.Data;
using avalon_backend.DTOs;
using avalon_backend.Entities;

namespace avalon_backend.Controllers;

[ApiController]
[Route("api/quiz")]
[Authorize]
public class QuizController(AppDbContext db) : ControllerBase
{
    // POST api/quiz/submit
    [HttpPost("submit")]
    public async Task<IActionResult> Submit(SubmitQuizDto dto)
    {
        // Read userId from JWT token — Flutter cannot fake this
        var userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

        // Load correct answers from DB for submitted question IDs
        var questionIds = dto.Answers.Select(a => a.QuestionId).ToList();
        var questions   = await db.Questions
            .Where(q => questionIds.Contains(q.Id) && q.CategoryId == dto.CategoryId)
            .ToListAsync();

        if (questions.Count == 0)
            return BadRequest(new { message = "No valid questions found." });

        // Calculate score on backend — Flutter never knows correct answers
        var score = questions.Count(q =>
        {
            var answer = dto.Answers.FirstOrDefault(a => a.QuestionId == q.Id);
            return answer != null &&
                   answer.SelectedOption.ToString().Trim().Equals(q.CorrectOption.Trim(), StringComparison.OrdinalIgnoreCase);
        });

        // Save attempt
        db.QuizAttempts.Add(new QuizAttempt
        {
            UserId         = userId,
            CategoryId     = dto.CategoryId,
            Score          = score,
            TotalQuestions = questions.Count
        });

        // Upsert leaderboard — update only if new score is better
        var entry = await db.Leaderboards
            .FirstOrDefaultAsync(l => l.UserId == userId && l.CategoryId == dto.CategoryId);

        if (entry is null)
        {
            db.Leaderboards.Add(new Leaderboard
            {
                UserId     = userId,
                CategoryId = dto.CategoryId,
                BestScore  = score,
                UpdatedAt  = DateTime.UtcNow
            });
        }
        else if (score > entry.BestScore)
        {
            entry.BestScore = score;
            entry.UpdatedAt = DateTime.UtcNow;
        }

        await db.SaveChangesAsync();

        var message = score == questions.Count ? "Perfect score! 🎉" :
                      score >= questions.Count / 2 ? "Good job! Keep it up." :
                      "Keep practicing!";

        return Ok(new SubmitQuizResponseDto(score, questions.Count, message));
    }
}
