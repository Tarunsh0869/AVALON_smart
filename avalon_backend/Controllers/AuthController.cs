using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using avalon_backend.Data;
using avalon_backend.DTOs;
using avalon_backend.Entities;
using avalon_backend.Services;

namespace avalon_backend.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController(AppDbContext db, JwtService jwt) : ControllerBase
{
    // POST api/auth/register
    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterDto dto)
    {
        if (await db.Users.AnyAsync(u => u.Email == dto.Email))
            return Conflict(new { message = "Email already registered." });

        var user = new User
        {
            Name         = dto.Name,
            Email        = dto.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password)
        };

        db.Users.Add(user);
        await db.SaveChangesAsync();

        return Ok(new AuthResponseDto(jwt.GenerateToken(user), user.Name, user.Id));
    }

    // POST api/auth/login
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginDto dto)
    {
        var user = await db.Users.FirstOrDefaultAsync(u => u.Email == dto.Email);

        if (user is null || !BCrypt.Net.BCrypt.Verify(dto.Password, user.PasswordHash))
            return Unauthorized(new { message = "Invalid email or password." });

        return Ok(new AuthResponseDto(jwt.GenerateToken(user), user.Name, user.Id));
    }
}
