
resource "aws_s3_bucket" "s3-bucket-aurora-test" {
  bucket = "aurora-test"
}
resource "aws_s3_object" "s3-object-aurora-test" {
  bucket = aws_s3_bucket.s3-bucket-aurora-test.id
  key = "beanstalk/aurora-test"
  source = "target/app.jar"
}
resource "aws_elastic_beanstalk_application" "beanstalk-aurora-test" {
  name = "aurora-test"
  description = "The description of  aurora application"
}
resource "aws_elastic_beanstalk_application_version" "beanstalk-aurora-test-version" {
  application = aws_elastic_beanstalk_application.beanstalk-aurora-test.name
  bucket = aws_s3_bucket.s3-bucket-aurora-test.id
  key = aws_s3_object.s3-object-aurora-test.id
  name = "aurora_test-1.0.4"
}
resource "aws_elastic_beanstalk_environment" "beanstalk-aurora-test-env" {
  name = "aurora-test-prod"
  application = aws_elastic_beanstalk_application.beanstalk-aurora-test.name
  solution_stack_name = "64bit Amazon Linux 2 v3.2.11 running Corretto 8"
  version_label = aws_elastic_beanstalk_application_version.beanstalk-aurora-test-version.name
  setting {
    name = "SERVER_PORT"
    namespace = "aws:elasticbeanstalk:application:environment"
    value = "5000"
  }
  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = "t2.micro"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
  // ...
}
