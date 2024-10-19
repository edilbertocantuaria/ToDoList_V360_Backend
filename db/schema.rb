ActiveRecord::Schema[7.2].define(version: 2024_10_19_162038) do
  enable_extension "plpgsql"

  create_table "tags", force: :cascade do |t|
    t.string "tag_name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "task_lists", force: :cascade do |t|
    t.string "title"
    t.string "attachment"
    t.decimal "percentage"
    t.bigint "user_id", null: false
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_task_lists_on_tag_id"
    t.index ["user_id"], name: "index_task_lists_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.text "task_description"
    t.boolean "is_task_done", default: false
    t.bigint "task_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_list_id"], name: "index_tasks_on_task_list_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "user_picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "tags", "users"
  add_foreign_key "task_lists", "tags"
  add_foreign_key "task_lists", "users"
  add_foreign_key "tasks", "task_lists"
end
