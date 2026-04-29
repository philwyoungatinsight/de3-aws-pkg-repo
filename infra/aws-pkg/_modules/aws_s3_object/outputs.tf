output "bucket_name" {
  description = "Bucket that contains the object."
  value       = aws_s3_object.this.bucket
}

output "object_name" {
  description = "Key (path) of the object in the bucket."
  value       = aws_s3_object.this.key
}

output "etag" {
  description = "ETag of the uploaded object (MD5 of the content)."
  value       = aws_s3_object.this.etag
}
