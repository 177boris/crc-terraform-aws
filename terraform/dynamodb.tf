
# =================================================================
# DynamoDB table & items


resource "aws_dynamodb_table" "counter_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = local.common_tags
}

# create the one and only item this table needs

/* 
resource "aws_dynamodb_table_item" "tf_counter_table_items" {
  table_name = aws_dynamodb_table.counter_table.name
  hash_key   = aws_dynamodb_table.counter_table.hash_key
  item       = <<EOF
        {
            "ID":{"S": "visitor_count"},
            "val":{"N": "1"}
        }
    EOF
}
*/
