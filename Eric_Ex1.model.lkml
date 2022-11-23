connection: "looker-private-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

#view is "like a" file
#Explore: is front end access


# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
datagroup: eric_lookml_orders_datagroup {
  sql_trigger: SELECT max(id) FROM my_tablename ;;
  max_cache_age: "24 hours"
  interval_trigger: "4 hours"
}

explore: order_items{
  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
    fields: [users.first_name, users.last_name, users.age, users.country]
  }
  join: inventory_items {
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}


explore: products{
  always_filter: {
    filters: [products.category: "jeans"]
  }
  join: inventory_items {
    type: inner
    relationship: one_to_many #Does this mean one product can have multiple inventory
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}


# explore: users {
#   sql_always_where: ${created_date} >= '2017-01-01' ;;
#   join: order_items {
#     view_label: "Orders After 2017 "
#     type: inner
#     relationship: one_to_many
#     sql_on: ${users.id} = ${order_items.user_id} ;;
#   }
# }
#add the dimensions in other views or just write code?
#using these as place holders
# view: table_name  {

#   dimension: quantity{
#     type: number
#     sql: ${TABLE}.quantity ;;
#   }

#   dimension: color {
#     type: string
#     sql: ${TABLE}.color ;;
#   }


# #what are some good use case for this?
#   dimension: return_status {
#     case: {
#       when: {
#         sql: ${TABLE}.return< 18 ;;
#         label: "children"
#       }
#       when: {
#         sql: ${TABLE}.age >= 18  ;;
#         label: "adult"
#       }
#       else: "unknown"
#     }
#   }

#   dimension: age_tier {
#     type: tier
#     tiers: [0,10,20,30,40,50,60,70,80,90]
#     sql: ${TABLE} ;;
#   }

#   dimension: zipcode {
#     type: zipcode
#     sql: ${TABLE}.zipcode ;;
#   }

#   measure: total_sales {
#     type: sum
#     sql: ${TABLE}.sale_price ;;
#   }

#   measure: min_sales {
#     type: min
#     sql: ${TABLE}.sale_price ;;
#   }

#   measure: max_sales {
#     type: max
#     sql: ${TABLE}.sale_price ;;
#   }

#   measure: average_sales {
#     type: average
#     sql: ${TABLE}.sale_price ;;
#   }
# }
