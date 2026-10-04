resource "aws_route53_zone" "main" {
  name    = "joonheouk.cloud"
  comment = "" # 콘솔 생성 시 비어 있음. 안 적으면 "Managed by Terraform"으로 바뀜

  lifecycle {
    prevent_destroy = true
  }
}

# 도메인 → CloudFront (alias). IPv4 / IPv6
resource "aws_route53_record" "apex_a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "joonheouk.cloud"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex_aaaa" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "joonheouk.cloud"
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

# ACM DNS 검증 레코드. 인증서 자동 갱신에 필요하므로 지우면 안 됨
resource "aws_route53_record" "acm_validation" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_91e318dbba51bf4cd4c79f0d8bc28e08.joonheouk.cloud"
  type    = "CNAME"
  ttl     = 300
  records = ["_0ae0da30b862439a563a182a6c34247a.wzccmgtwzk.acm-validations.aws."]
}

resource "aws_route53_record" "acm_validation_www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_782350b4ba573f7032b07f5c33da27c2.www.joonheouk.cloud"
  type    = "CNAME"
  ttl     = 300
  records = ["_325af5f8bfbb3ce8a27fc4efedca26d9.wzccmgtwzk.acm-validations.aws."]
}