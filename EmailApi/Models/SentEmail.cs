using System.ComponentModel.DataAnnotations;

namespace EmailApi.Models;

public class SentEmail
{
    public int Id { get; set; }

    [Required]
    public string Sender { get; set; } = string.Empty;

    [Required]
    public string Subject { get; set; } = string.Empty;

    [Required]
    public string Body { get; set; } = string.Empty;

    public string Recipient { get; set; } = string.Empty;

    public DateTime SentAt { get; set; } = DateTime.UtcNow;
}
