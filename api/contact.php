<?php

/**
 * Contact Form Handler
 * 
 * Features:
 * - PHPMailer integration
 * - Honeypot protection
 * - Rate limiting
 * - Cloudflare Turnstile verification (optional)
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
  http_response_code(200);
  exit();
}

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['success' => false, 'message' => 'Method not allowed']);
  exit();
}

require_once __DIR__ . '/../vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Load environment variables
$envFile = __DIR__ . '/../.env';
if (file_exists($envFile)) {
  $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
  foreach ($lines as $line) {
    if (strpos(trim($line), '#') === 0) continue;
    if (strpos($line, '=') === false) continue;
    list($key, $value) = explode('=', $line, 2);
    $_ENV[trim($key)] = trim($value);
  }
}

/**
 * Rate Limiting
 */
function checkRateLimit($ip)
{
  $rateLimitFile = __DIR__ . '/rate-limit.json';
  $rateLimit = (int)($_ENV['RATE_LIMIT'] ?? 5);
  $timeWindow = 3600; // 1 hour

  $data = [];
  if (file_exists($rateLimitFile)) {
    $data = json_decode(file_get_contents($rateLimitFile), true);
  }

  $currentTime = time();

  // Clean old entries
  foreach ($data as $storedIp => $timestamps) {
    $data[$storedIp] = array_filter($timestamps, function ($timestamp) use ($currentTime, $timeWindow) {
      return ($currentTime - $timestamp) < $timeWindow;
    });
    if (empty($data[$storedIp])) {
      unset($data[$storedIp]);
    }
  }

  // Check current IP
  if (!isset($data[$ip])) {
    $data[$ip] = [];
  }

  if (count($data[$ip]) >= $rateLimit) {
    return false;
  }

  // Add current request
  $data[$ip][] = $currentTime;
  file_put_contents($rateLimitFile, json_encode($data));

  return true;
}

/**
 * Verify Cloudflare Turnstile (optional)
 */
function verifyTurnstile($token)
{
  $secret = $_ENV['TURNSTILE_SECRET_KEY'] ?? '';

  if (empty($secret) || empty($token)) {
    return true; // Skip verification if not configured
  }

  $response = file_get_contents('https://challenges.cloudflare.com/turnstile/v0/siteverify', false, stream_context_create([
    'http' => [
      'method' => 'POST',
      'header' => 'Content-Type: application/x-www-form-urlencoded',
      'content' => http_build_query([
        'secret' => $secret,
        'response' => $token,
        'remoteip' => $_SERVER['REMOTE_ADDR']
      ])
    ]
  ]));

  $result = json_decode($response, true);
  return $result['success'] ?? false;
}

/**
 * Sanitize input
 */
function sanitizeInput($data)
{
  return htmlspecialchars(strip_tags(trim($data)));
}

// Get client IP
$clientIp = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? $_SERVER['REMOTE_ADDR'];

// Check rate limit
if (!checkRateLimit($clientIp)) {
  http_response_code(429);
  echo json_encode([
    'success' => false,
    'message' => 'Too many requests. Please try again later.'
  ]);
  exit();
}

// Get form data
$data = json_decode(file_get_contents('php://input'), true);

if (!$data) {
  // Fallback to POST data
  $data = $_POST;
}

// Honeypot check
if (!empty($data['website'])) {
  http_response_code(400);
  echo json_encode(['success' => false, 'message' => 'Invalid submission']);
  exit();
}

// Verify Turnstile token (if configured)
$turnstileToken = $data['cf-turnstile-response'] ?? '';
if (!verifyTurnstile($turnstileToken)) {
  http_response_code(400);
  echo json_encode(['success' => false, 'message' => 'Verification failed. Please try again.']);
  exit();
}

// Validate required fields
$name = sanitizeInput($data['name'] ?? '');
$email = sanitizeInput($data['email'] ?? '');
$message = sanitizeInput($data['message'] ?? '');

if (empty($name) || empty($email) || empty($message)) {
  http_response_code(400);
  echo json_encode(['success' => false, 'message' => 'Please fill in all required fields.']);
  exit();
}

// Validate email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
  http_response_code(400);
  echo json_encode(['success' => false, 'message' => 'Invalid email address.']);
  exit();
}

// Prepare email content
$emailSubject = 'New Contact Form Submission';
$emailBodyHTML = "
    <html>
    <head>
        <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background-color: #4F46E5; color: white; padding: 20px; text-align: center; }
            .content { background-color: #f4f4f4; padding: 20px; }
            .field { margin-bottom: 15px; }
            .label { font-weight: bold; color: #4F46E5; }
            .value { margin-top: 5px; }
        </style>
    </head>
    <body>
        <div class='container'>
            <div class='header'>
                <h2>New Contact Form Submission</h2>
            </div>
            <div class='content'>
                <div class='field'>
                    <div class='label'>Name:</div>
                    <div class='value'>{$name}</div>
                </div>
                <div class='field'>
                    <div class='label'>Email:</div>
                    <div class='value'>{$email}</div>
                </div>
                <div class='field'>
                    <div class='label'>Message:</div>
                    <div class='value'>" . nl2br($message) . "</div>
                </div>
                <div class='field'>
                    <div class='label'>IP Address:</div>
                    <div class='value'>{$clientIp}</div>
                </div>
                <div class='field'>
                    <div class='label'>Date & Time:</div>
                    <div class='value'>" . date('Y-m-d H:i:s') . "</div>
                </div>
            </div>
        </div>
    </body>
    </html>
";

$emailBodyText = "
New Contact Form Submission

Name: {$name}
Email: {$email}
Message: {$message}

IP Address: {$clientIp}
Date & Time: " . date('Y-m-d H:i:s');

// Send email using PHPMailer
try {
  $mail = new PHPMailer(true);

  // Server settings
  $mail->isSMTP();
  $mail->Host = $_ENV['SMTP_HOST'] ?? 'localhost';
  $mail->SMTPAuth = true;
  $mail->Username = $_ENV['SMTP_USERNAME'] ?? '';
  $mail->Password = $_ENV['SMTP_PASSWORD'] ?? '';
  $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
  $mail->Port = (int)($_ENV['SMTP_PORT'] ?? 587);
  $mail->CharSet = 'UTF-8';

  // Recipients
  $mail->setFrom(
    $_ENV['SMTP_FROM'] ?? 'noreply@example.com',
    $_ENV['SMTP_FROM_NAME'] ?? 'Contact Form'
  );
  $mail->addAddress($_ENV['SMTP_TO'] ?? 'admin@example.com');
  $mail->addReplyTo($email, $name);

  // Content
  $mail->isHTML(true);
  $mail->Subject = $emailSubject;
  $mail->Body = $emailBodyHTML;
  $mail->AltBody = $emailBodyText;

  $mail->send();

  echo json_encode([
    'success' => true,
    'message' => 'Thank you for your message. We will get back to you soon.'
  ]);
} catch (Exception $e) {
  http_response_code(500);
  echo json_encode([
    'success' => false,
    'message' => 'An error occurred while sending the message. Please try again later.'
  ]);

  // Log error (optional)
  error_log("Mailer Error: {$mail->ErrorInfo}");
}
