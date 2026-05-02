using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using avalon_backend.Data;
using avalon_backend.DTOs;

namespace avalon_backend.Controllers;

[ApiController]
[Route("api/categories")]
public class CategoriesController(AppDbContext db) : ControllerBase
{
    // GET api/categories
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var categories = await db.Categories
            .Select(c => new CategoryDto(c.Id, c.Name, c.IconName))
            .ToListAsync();

        return Ok(categories);
    }
}
