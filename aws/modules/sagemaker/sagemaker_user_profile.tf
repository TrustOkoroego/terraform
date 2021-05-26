#---------------------------------------------------
# AWS Sagemaker user profile 
#---------------------------------------------------
resource "aws_sagemaker_user_profile" "sagemaker_user_profile" {
  count = var.enable_sagemaker_user_profile ? 1 : 0

  user_profile_name         = var.sagemaker_user_profile_name != "" ? lower(var.sagemaker_user_profile_name) : "${lower(var.name)}-sagemaker-user-profile-${lower(var.environment)}"
  domain_id                 = var.sagemaker_user_profile_domain_id != "" ? var.sagemaker_user_profile_domain_id : (var.enable_sagemaker_domain ? aws_sagemaker_domain.sagemaker_domain.0.id : null)
  single_sign_on_user_value = var.sagemaker_user_profile_single_sign_on_user_value

  single_sign_on_user_identifier = var.sagemaker_user_profile_single_sign_on_user_identifier

  user_settings {
    execution_role = lookup(var.sagemaker_user_profile_user_settings, "execution_role", null)

    security_groups = lookup(var.sagemaker_user_profile_user_settings, "security_groups", null)

    dynamic "sharing_settings" {
      iterator = sharing_settings
      for_each = var.sagemaker_user_profile_sharing_settings

      content {
        notebook_output_option = lookup(sharing_settings.value, "notebook_output_option", null)
        s3_kms_key_id          = lookup(sharing_settings.value, "s3_kms_key_id", null)
        s3_output_path         = lookup(sharing_settings.value, "s3_output_path", null)
      }
    }

    dynamic "tensor_board_app_settings" {
      iterator = tensor_board_app_settings
      for_each = var.sagemaker_user_profile_tensor_board_app_settings

      content {
        dynamic "default_resource_spec" {
          iterator = default_resource_spec
          for_each = lookup(tensor_board_app_settings.value, "default_resource_spec", [])

          content {
            instance_type       = lookup(default_resource_spec.value, "instance_type", null)
            sagemaker_image_arn = lookup(default_resource_spec.value, "sagemaker_image_arn", null)
          }
        }
      }
    }

    dynamic "jupyter_server_app_settings" {
      iterator = jupyter_server_app_settings
      for_each = var.sagemaker_user_profile_jupyter_server_app_settings

      content {
        dynamic "default_resource_spec" {
          iterator = default_resource_spec
          for_each = lookup(jupyter_server_app_settings.value, "default_resource_spec", [])

          content {
            instance_type       = lookup(default_resource_spec.value, "instance_type", null)
            sagemaker_image_arn = lookup(default_resource_spec.value, "sagemaker_image_arn", null)
          }
        }
      }
    }

    dynamic "kernel_gateway_app_settings" {
      iterator = kernel_gateway_app_settings
      for_each = var.sagemaker_user_profile_kernel_gateway_app_settings

      content {
        dynamic "default_resource_spec" {
          iterator = default_resource_spec
          for_each = lookup(kernel_gateway_app_settings.value, "default_resource_spec", [])

          content {
            instance_type       = lookup(default_resource_spec.value, "instance_type", null)
            sagemaker_image_arn = lookup(default_resource_spec.value, "sagemaker_image_arn", null)
          }
        }

        dynamic "custom_image" {
          iterator = custom_image
          for_each = lookup(kernel_gateway_app_settings.value, "custom_image", [])

          content {
            app_image_config_name = lookup(custom_image.value, "app_image_config_name", null)
            image_name            = lookup(custom_image.value, "image_name", null)

            image_version_number = lookup(custom_image.value, "image_version_number", null)
          }
        }
      }
    }

  }

  tags = merge(
    {
      Name = var.sagemaker_user_profile_name != "" ? lower(var.sagemaker_user_profile_name) : "${lower(var.name)}-sagemaker-user-profile-${lower(var.environment)}"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = [
    aws_sagemaker_domain.sagemaker_domain
  ]
}
