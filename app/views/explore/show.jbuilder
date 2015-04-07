json.title @book.title
json.cover_url @book.cover_url || 'https://sm3lir.cloudimage.io/s/width/210/https://www.gitbook.com/cover/book/karmazzin/eloquentjavascript_ru.jpg?build=1427995075544&v=6.11.8'

json.author do 
  json.username @book.user.username
end
