# CloudFront용 인증서 (반드시 us-east-1). www는 CloudFront에서 아직 안 받지만 인증서엔 포함돼 있음
resource "aws_acm_certificate" "site" {
  provider = aws.us_east_1

  domain_name               = "joonheouk.cloud"
  subject_alternative_names = ["joonheouk.cloud", "www.joonheouk.cloud"]
  validation_method         = "DNS"

  lifecycle {
    prevent_destroy = true
  }
}