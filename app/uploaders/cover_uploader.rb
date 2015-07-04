# encoding: utf-8

class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  FIT_MAX = 99999

  storage :file

  def store_dir
    "uploads/books/covers/#{model.slug}"
  end

  def default_url(*args)
    "/images/default_cover.png"
  end

  version :preview do
    process resize_to_fit: [FIT_MAX, 256]
  end

  version :magazine do
    process :resize_to_fit => [FIT_MAX, 2520]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private
  def crop(geometry)
    manipulate! do |img|      
      img.crop(geometry)
      img
    end    
  end
end
