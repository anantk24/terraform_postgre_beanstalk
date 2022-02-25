
resource "aws_s3_bucket" "s3-bucket-dao-aurora-test" {
  bucket = "dao-aurora-test"
}
resource "aws_s3_object" "s3-object-dao-aurora-test" {
  bucket = aws_s3_bucket.s3-bucket-dao-aurora-test.id
  key = "beanstalk/dao-aurora-test"
  source = "target/app.jar"
}
resource "aws_elastic_beanstalk_application" "beanstalk-dao-aurora-test" {
  name = "dao-aurora-test"
  description = "The description of dao aurora application"
}
resource "aws_elastic_beanstalk_application_version" "beanstalk-dao-aurora-test-version" {
  application = aws_elastic_beanstalk_application.beanstalk-dao-aurora-test.name
  bucket = aws_s3_bucket.s3-bucket-dao-aurora-test.id
  key = aws_s3_object.s3-object-dao-aurora-test.id
  name = "dao_aurora_test-1.0.4"
}
resource "aws_elastic_beanstalk_environment" "beanstalk-dao-aurora-test-env" {
  name = "dao-aurora-test-prod"
  application = aws_elastic_beanstalk_application.beanstalk-dao-aurora-test.name
  solution_stack_name = "64bit Amazon Linux 2 v3.2.11 running Corretto 8"
  version_label = aws_elastic_beanstalk_application_version.beanstalk-dao-aurora-test-version.name
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