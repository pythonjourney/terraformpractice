terraform {
  

  required_version = "1.10.3"
  required_providers {
    aws = {

        source = "hashicorp/aws"
        
    }

    
  }
}

provider "aws" {
  
  region = "us-east-1"
}
