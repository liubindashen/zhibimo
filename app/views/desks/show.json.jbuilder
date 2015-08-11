json.currentUser do
  json.extract! @current_user, :id, :username
end

json.book do
  json.extract! @book, :id, :title
end
