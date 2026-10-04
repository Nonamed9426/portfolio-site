# 콘솔로 만든 기존 리소스를 Terraform 관리 대상으로 등록 (2026-10-04)
# import 완료 후 다음 커밋에서 삭제. 이 파일은 "어떻게 가져왔는지"의 기록

import {
  to = aws_s3_bucket.site
  id = "joonheouk.cloud"
}

import {
  to = aws_s3_bucket_public_access_block.site
  id = "joonheouk.cloud"
}

import {
  to = aws_s3_bucket_policy.site
  id = "joonheouk.cloud"
}

import {
  to = aws_cloudfront_origin_access_control.site
  id = "E1E0YLQRT5M9L9"
}

import {
  to = aws_cloudfront_distribution.site
  id = "E1NNI4T8V6DW3U"
}

import {
  provider = aws.us_east_1
  to       = aws_acm_certificate.site
  id       = "arn:aws:acm:us-east-1:727244434299:certificate/5fe0856c-2ee7-4807-9f94-cb71e64af245"
}

import {
  to = aws_route53_zone.main
  id = "Z0060154JHPH7N3OYCK4"
}

import {
  to = aws_route53_record.apex_a
  id = "Z0060154JHPH7N3OYCK4_joonheouk.cloud_A"
}

import {
  to = aws_route53_record.apex_aaaa
  id = "Z0060154JHPH7N3OYCK4_joonheouk.cloud_AAAA"
}

import {
  to = aws_route53_record.acm_validation
  id = "Z0060154JHPH7N3OYCK4__91e318dbba51bf4cd4c79f0d8bc28e08.joonheouk.cloud_CNAME"
}

# 인증서가 www.joonheouk.cloud도 포함 (SAN) → 자동 갱신에 이 검증 레코드가 필요함
import {
  to = aws_route53_record.acm_validation_www
  id = "Z0060154JHPH7N3OYCK4__782350b4ba573f7032b07f5c33da27c2.www.joonheouk.cloud_CNAME"
}