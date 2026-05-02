using Microsoft.EntityFrameworkCore;
using avalon_backend.Entities;

namespace avalon_backend.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<User> Users => Set<User>();
    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Question> Questions => Set<Question>();
    public DbSet<QuizAttempt> QuizAttempts => Set<QuizAttempt>();
    public DbSet<Leaderboard> Leaderboards => Set<Leaderboard>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Unique email per user
        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();

        // ONE leaderboard row per user per category — prevents duplicates
        modelBuilder.Entity<Leaderboard>()
            .HasIndex(l => new { l.UserId, l.CategoryId })
            .IsUnique();

        // Index for fast leaderboard queries sorted by score
        modelBuilder.Entity<Leaderboard>()
            .HasIndex(l => l.BestScore);

        // Index for fast question lookup by category
        modelBuilder.Entity<Question>()
            .HasIndex(q => q.CategoryId);

        // Seed categories
        modelBuilder.Entity<Category>().HasData(
            new Category { Id = 1, Name = "Python",       IconName = "code" },
            new Category { Id = 2, Name = "SQL",          IconName = "storage" },
            new Category { Id = 3, Name = "UI/UX",        IconName = "palette" },
            new Category { Id = 4, Name = "Data Science", IconName = "analytics" }
        );
    }
}
