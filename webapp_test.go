package mytest

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestWebappResource(t *testing.T) {

	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../",
		VarFiles:     []string{"./variables/input.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	/*// Run `terraform output` to get the value of an output variable
	  CdnProfileName := terraform.Output(t, terraformOptions, "cdn_profile_name")
	  CdnEndpointName := terraform.Output(t, terraformOptions, "cdn_endpoint_name")*/
}
