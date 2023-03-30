terraform {
    required_providers {
       aws = {
        version = "~>3.0"
        source = "hashicorp/aws"
        }
    }
}

provider aws {
    region = "us-east-1"
    access_key = "AKIAQQ32Y7HVPP2RLWNZ"
    secret_key = "hgs6lv/pwa1/9pvHxU68R92eCLCpNAA71DvkDPAc"
}


resource "aws_s3_bucket" "example" {
    bucket = "dataupload-bucket"
    website {
        index_document = "index.html"
        error_document = "error.html"
  }
}
resource "aws_s3_bucket_acl" "example" {
    bucket = aws_s3_bucket.example.id
    acl = "public-read"
}
resource "aws_s3_bucket_public_access_block" "access-block" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object" "singleobject" {
  bucket = aws_s3_bucket.example.id
  key    = "index.html"
  source =  "C:\\Users\\Vani_Kadali\\Desktop\\index.html"
  //have to specify the content type while uploading file using terraform
    content_type = "text/html"
  }

resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.public_read_access.json
}

data "aws_iam_policy_document" "public_read_access" {
  statement  {
    effect = "Allow"

    actions = [  
      "s3:GetObject",
      "s3:GetObjectAcl",
     ]
    principals {
        type = "*"
        identifiers = ["*"]
    }
    resources = [
      "arn:aws:s3:::dataupload-bucket/*"
    ]
}

}