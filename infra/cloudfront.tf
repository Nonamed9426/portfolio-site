locals {
  # 콘솔이 자동으로 붙인 origin ID. 바꾸면 배포가 변경되므로 그대로 유지
  s3_origin_id = "joonheouk.cloud.s3.ap-northeast-2.amazonaws.com-muobrvewr0b"

  # 콘솔 배포 생성 시 함께 만들어진 WAF. WAF 자체는 이 코드에서 관리하지 않고 연결만 유지
  web_acl_arn = "arn:aws:wafv2:us-east-1:727244434299:global/webacl/CreatedByCloudFront-b46c6102/d1604b48-1cb8-4c3a-b85e-aac295c85a4e"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "oac-joonheouk.cloud.s3.ap-northeast-2.amazonaws.com-muobuc2g0ms"
  description                       = "Created by CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "site" {
  enabled             = true
  comment             = "자기소개서"
  aliases             = ["joonheouk.cloud"]
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  http_version        = "http2"
  price_class         = "PriceClass_All"
  web_acl_id          = local.web_acl_arn

  tags = {
    Name = "joonheouk-portfolio"
  }

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.site.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  lifecycle {
    prevent_destroy = true
  }
}