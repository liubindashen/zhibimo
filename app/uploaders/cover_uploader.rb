# encoding: utf-8

class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  INFINITY = 100000

  storage :file

  def store_dir
    "uploads/books/covers/#{model.slug}"
  end

  def default_url(*args)
    "/images/default_cover.png"
  end

  version :preview do
    process :resize_to_fit => [130, INFINITY]
  end

  version :magazine do
    process :resize_to_fit => [1800, INFINITY]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
