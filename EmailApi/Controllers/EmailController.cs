using System.Net;
using System.Net.Mail;
using System.Security.Claims;
using EmailApi.Data;
using EmailApi.Dtos;
using EmailApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EmailApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class EmailController : ControllerBase
{
    private readonly ApplicationDbContext _context;
    private readonly IConfiguration _configuration;

    public EmailController(ApplicationDbContext context, IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
    }

    [HttpPost("send")]
    public async Task<IActionResult> SendEmail([FromBody] SendEmailDto dto)
    {
        var smtpSettings = _configuration.GetSection("Smtp");
        var senderEmail = smtpSettings["Email"]!;

        try
        {
            using var client = new SmtpClient(smtpSettings["Host"], int.Parse(smtpSettings["Port"]!));
            client.Credentials = new NetworkCredential(senderEmail, smtpSettings["Password"]);
            client.EnableSsl = true;

            var mailMessage = new MailMessage
            {
                From = new MailAddress(senderEmail),
                Subject = dto.Subject,
                Body = dto.Body,
                IsBodyHtml = false
            };
            mailMessage.To.Add(dto.To);

            await client.SendMailAsync(mailMessage);

            var sentEmail = new SentEmail
            {
                Sender = User.FindFirstValue(ClaimTypes.Email) ?? senderEmail,
                Recipient = dto.To,
                Subject = dto.Subject,
                Body = dto.Body,
                SentAt = DateTime.UtcNow
            };

            _context.SentEmails.Add(sentEmail);
            await _context.SaveChangesAsync();

            return Ok(new { Message = "Email sent and saved successfully" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { Message = "Failed to send email", Error = ex.Message });
        }
    }
}
