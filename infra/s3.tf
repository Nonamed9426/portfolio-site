# 사이트 원본 버킷. 공개 차단 + CloudFront(OAC)만 읽기 가능
resource "aws_s3_bucket" "site" {
  bucket = "joonheouk.cloud"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 이 CloudFront 배포에서 온 요청만 GetObject 허용
resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.site.arn}/*"
        Condition = {
          ArnLike = { "AWS:SourceArn" = aws_cloudfront_distribution.site.arn }
        }
      }
    ]
  })
}