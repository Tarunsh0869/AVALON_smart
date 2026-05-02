using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using avalon_backend.Data;
using avalon_backend.DTOs;

namespace avalon_backend.Controllers;

[ApiController]
[Route("api/questions")]
[Authorize]
public class QuestionsController(AppDbContext db) : ControllerBase
{
    // GET api/questions/{categoryId}
    [HttpGet("{categoryId}")]
    public async Task<IActionResult> GetQuestions(int categoryId)
    {
        var questions = await db.Questions
            .Where(q => q.CategoryId == categoryId)
            .ToListAsync();

        var result = questions.Select(q => new QuestionDto(
            q.Id,
            q.QuestionText,
            JsonSerializer.Deserialize<List<string>>(q.OptionsJson) ?? []
        ));

        return Ok(result);
    }
}
