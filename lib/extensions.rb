class String
  def remove_header
    gsub(/^(.)*\n/, "")
  end
end
