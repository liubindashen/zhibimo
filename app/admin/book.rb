ActiveAdmin.register Book do
  index do
    id_column
    column :slug
    column :title
    column :created_at
    column :author_pen_name
    actions
  end
end
