data "template_file" "kms_key_policy" {
	template = <<POLICY
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::829409305595:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::829409305595:user/DonaldDcku"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::829409305595:user/DonaldDcku"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::829409305595:user/DonaldDcku"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_kms_key" "kms_key_creation_1" {
	description		= "${var.kms_resource_name}"
	policy			= "${data.template_file.kms_key_policy.rendered}"
	deletion_window_in_days	= "${var.kms_deletion_window_in_days}"
	enable_key_rotation	= "${var.kms_enable_key_rotation}"
	tags	= {
		Name		= "${var.kms_resource_name}" 
                Project         = "${var.tag_project_code}"
                Department      = "${var.tag_department}"

	}
}

resource "aws_kms_alias" "kms_key_creation_1_alias"{
	name		= "alias/${var.kms_resource_name}"
	target_key_id	= "${aws_kms_key.kms_key_creation_1.key_id}"
}

output "cmk_arn" {
	value	= "${aws_kms_key.kms_key_creation_1.arn}"
}

output "cmk_alias" {
	value	= "${aws_kms_alias.kms_key_creation_1_alias.arn}"
}

output "cmk_id" {
	value	= "${aws_kms_key.kms_key_creation_1.key_id}"
}
